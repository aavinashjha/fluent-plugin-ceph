Ceph plugin for [Fluentd](http://fluentd.org)

## What's Ceph?
Ceph is a distributed object store and file system designed to provide excellent performance, reliability and scalability.

## Installation
(1) gem build fluent-plugin-ceph.gemspec
(2) sudo /usr/sbin/td-agent-gem install fluent-plugin-ceph-0.1.0.gem
(3) Restart td-agent service.

## Configuration

<source>
  @type ceph
  tag ceph
  arguments health, osd tree, osd stat
  granularity 5
</source>

## Output Format
For health argument, output will look like this:

{"health":{"health_services":[{"mons":[{"name":"ceph-02","kb_total":37024320,"kb_used":12097884,"kb_avail":23022668,"avail_percent":62,"last_updated":"2016-07-26 12:32:08.862700","store_stats":{"bytes_total":20814955,"bytes_sst":0,"bytes_log":2285109,"bytes_misc":18529846,"last_updated":"0.000000"},"health":"HEALTH_OK"}]}]},"timechecks":{"epoch":5,"round":0,"round_status":"finished"},"summary":[{"severity":"HEALTH_ERR","summary":"308 pgs are stuck inactive for more than 300 seconds"},{"severity":"HEALTH_WARN","summary":"308 pgs stale"},{"severity":"HEALTH_WARN","summary":"308 pgs stuck stale"}],"overall_status":"HEALTH_ERR","detail":[]}

With multiple arguments, every argument will have a response in the above JSON with key as the argument name. 
## Supported options

```
All options supported in ceph commands
```

## Copyright

Copyright (c) 2016 Avinash Jha. See LICENSE.txt for
further details.

