module Fluent
  class ElasticsearchTimestampCheckFilter < Filter
    Fluent::Plugin.register_filter('elasticsearch_timestamp_check', self)

    def configure(conf)
      super
      require 'date'
    end

    def start
      super
    end

    def shutdown
      super
    end

    def filter(tag, time, record)
      existing = record['@timestamp'] || record['timestamp'] || record['time']
      if existing
        record['@timestamp'] =
          DateTime.parse(existing).strftime('%Y-%m-%dT%H:%M:%S.%L%z')
        record['fluent_converted_timestamp'] =
          DateTime.parse(existing).strftime('%Y-%m-%dT%H:%M:%S.%L%z')
        $log.debug("Timestamp parsed: #{record['@timestamp']}")
      else
        record['@timestamp'] = Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
        record['fluent_added_timestamp'] =
          Time.now.strftime('%Y-%m-%dT%H:%M:%S.%L%z')
        $log.debug("Timestamp added: #{record['@timestamp']}")
      end
      record
    end
  end
end

