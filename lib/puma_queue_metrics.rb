# frozen_string_literal: true

require_relative 'puma_queue_metrics/version'
require_relative 'puma_queue_metrics/puma_stats'
require_relative 'puma_queue_metrics/system_usage'
require_relative 'puma_queue_metrics/snapshot'
require_relative 'puma_queue_metrics/sampler'
require_relative 'puma_queue_metrics/performance_collector_adapter'
require_relative 'puma_queue_metrics/configuration'
require_relative 'puma_queue_metrics/exporter'

module PumaQueueMetrics
  class << self
    def configure
      yield configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def rack_app
      configuration.exporter ||= Exporter.new(sampler: configuration.sampler)
    end

    def snapshot
      configuration.sampler.snapshot
    end
  end
end
