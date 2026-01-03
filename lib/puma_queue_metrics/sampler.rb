# frozen_string_literal: true

module PumaQueueMetrics
  class Sampler
    def initialize(puma_stats_provider: PumaQueueMetrics::PumaStats, system_usage: PumaQueueMetrics::SystemUsage)
      @puma_stats_provider = puma_stats_provider
      @system_usage = system_usage
    end

    def snapshot
      stats = @puma_stats_provider.snapshot || {}
      Snapshot.new(
        backlog: stats[:backlog],
        running_threads: stats[:running],
        pool_capacity: stats[:pool_capacity],
        max_threads: stats[:max_threads],
        cpu_seconds_total: @system_usage.process_cpu_seconds,
        memory_rss_bytes: @system_usage.resident_memory_bytes
      )
    end
  end
end
