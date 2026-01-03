# frozen_string_literal: true

require 'json'

module PumaQueueMetrics
  module PumaStats
    module_function

    def snapshot
      stats = read_stats
      return {} unless stats

      if stats['worker_status'].is_a?(Array) && stats['worker_status'].any?
        aggregate_workers(stats['worker_status'])
      else
        single_worker(stats)
      end
    end

    def read_stats
      return unless defined?(Puma) && Puma.respond_to?(:stats)

      data = Puma.stats
      data = data.call if data.respond_to?(:call)
      JSON.parse(data)
    rescue StandardError
      nil
    end

    def aggregate_workers(workers)
      workers.each_with_object({ backlog: 0, running: 0, pool_capacity: 0, max_threads: 0 }) do |worker, totals|
        status = worker.fetch('last_status', {})
        totals[:backlog] += status['backlog'].to_i
        totals[:running] += status['running'].to_i
        totals[:pool_capacity] += status['pool_capacity'].to_i
        totals[:max_threads] += status['max_threads'].to_i
      end
    end

    def single_worker(stats)
      {
        backlog: stats['backlog'].to_i,
        running: stats['running'].to_i,
        pool_capacity: stats['pool_capacity'].to_i,
        max_threads: stats['max_threads'].to_i
      }
    end

    private_class_method :read_stats, :aggregate_workers, :single_worker
  end
end
