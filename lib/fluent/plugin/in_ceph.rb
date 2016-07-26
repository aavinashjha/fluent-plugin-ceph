require 'fluent/mixin/rewrite_tag_name'
require 'json'
require 'date'

module Fluent
  class CephInput < Input

    Plugin.register_input('ceph', self)

    def initialize
      super
    end

    config_param :tag, :string
    config_param :ceph_path, :string, :default => "ceph"
    config_param :arguments, :string, :default => "health"
    config_param :granularity, :integer, :default => 1
    config_param :hostname_command, :string, :default => "hostname"

    include Fluent::Mixin::RewriteTagName

    def configure(conf)
      super
      @commands = Hash.new
      if @arguments.include? ","
          @arguments.split(",").each do |argument|
              @commands[argument.strip] = "#{@ceph_path} #{argument.strip} --format json"
          end
      else
          @commands[@arguments.strip] = "#{@ceph_path} #{@arguments.strip} --format json"
      end
      @hostname = `#{@hostname_command}`.chomp!
    end

    def emit_message
      @output = Hash.new
      @pids = Array.new
      @commands.each do |argument, command|
          io = IO.popen(command, "r")
          pid = io.pid
          json = io.read.strip
          @output[argument] = json && json.length >= 2 ? JSON.parse(json) : nil
          Process.detach(pid)
          Process.kill(:TERM, pid)
          @pids.push pid
      end
      @output['eventtime'] = DateTime.parse(Time.now.to_s).strftime("%d/%m/%Y %H:%M:%S")
      router.emit(@tag.dup, Engine.now, @output)
    end

    def start
      @loop = Coolio::Loop.new
      @tw = TimerWatcher.new(@granularity, true,  &method(:emit_message))
      @tw.attach(@loop)
      @thread = Thread.new(&method(:run))
    end

    def shutdown
      @pids.each { |pid|
          Process.detach(pid) 
          Process.kill(:TERM, pid)
      }
      @tw.detach
      @loop.stop
      @thread.join
    end

    def run
      begin
        @loop.run
      rescue
        $log.error "unexpected error", :error=>$!.to_s
        $log.error_backtrace
      end
    end

    def restart
      @pids.each { |pid|
          Process.detach(@pid)
          Process.kill(:TERM, @pid)
      }
      @tw.detach
      @tw = TimerWatcher.new(@delay, true,  &method(:emit_message))
      @tw.attach(@loop)
    end

    class TimerWatcher < Coolio::TimerWatcher
      def initialize(interval, repeat, &method)
        @emit_message = method
        super(interval, repeat)
      end

      def on_timer
        @emit_message.call
      rescue
        $log.error $!.to_s
        $log.error_backtrace
      end
    end
  end
end
