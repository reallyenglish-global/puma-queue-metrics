# frozen_string_literal: true

module PumaQueueMetrics
  module PerformanceCollectorAdapter
    module_function

    def snapshot
      return {} unless defined?(PerformanceMetricsCollector)

      payload = PerformanceMetricsCollector.latest_snapshot
      puma_stats = fetch_value(payload, :puma)
      return {} unless puma_stats

      {
        backlog: fetch_value(puma_stats, :backlog),
        running: fetch_value(puma_stats, :running),
        pool_capacity: fetch_value(puma_stats, :pool_capacity),
        max_threads: fetch_value(puma_stats, :max_threads)
      }
    rescue StandardError
      {}
    end

    def fetch_value(value, key)
      return unless value

      if value.is_a?(Hash)
        value[key.to_s] || value[key.to_sym]
      end
    end
    private_class_method :fetch_value
  end
end
