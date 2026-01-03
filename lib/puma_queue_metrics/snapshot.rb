# frozen_string_literal: true

module PumaQueueMetrics
  class Snapshot
    attr_reader :backlog, :running_threads, :pool_capacity, :max_threads,
                :cpu_seconds_total, :memory_rss_bytes

    def initialize(backlog:, running_threads:, pool_capacity:, max_threads:, cpu_seconds_total:, memory_rss_bytes:)
      @backlog = backlog
      @running_threads = running_threads
      @pool_capacity = pool_capacity
      @max_threads = max_threads
      @cpu_seconds_total = cpu_seconds_total
      @memory_rss_bytes = memory_rss_bytes
    end

    def to_prometheus(metric_prefix: 'turtle')
      lines = []
      prefix = metric_prefix
      append_gauge(lines, "#{prefix}_puma_backlog", 'Current Puma backlog (requests waiting for a worker)', backlog)
      append_gauge(lines, "#{prefix}_puma_running_threads", 'Threads currently running application code', running_threads)
      append_gauge(lines, "#{prefix}_puma_pool_capacity", 'Available Puma threads across the pool', pool_capacity)
      append_gauge(lines, "#{prefix}_puma_max_threads", 'Configured Puma max threads', max_threads)
      append_counter(lines, "#{prefix}_process_cpu_seconds_total", 'Total CPU time consumed by the Rails process', cpu_seconds_total)
      append_gauge(lines, "#{prefix}_process_resident_memory_bytes", 'Resident memory used by the Rails process', memory_rss_bytes)
      lines << '' unless lines.empty?
      lines.join("\n")
    end

    private

    def append_gauge(lines, name, help, value)
      append_metric(lines, name, help, 'gauge', value)
    end

    def append_counter(lines, name, help, value)
      append_metric(lines, name, help, 'counter', value)
    end

    def append_metric(lines, name, help, type, value)
      return if value.nil?

      lines << "# HELP #{name} #{help}"
      lines << "# TYPE #{name} #{type}"
      lines << "#{name} #{value}"
    end
  end
end
