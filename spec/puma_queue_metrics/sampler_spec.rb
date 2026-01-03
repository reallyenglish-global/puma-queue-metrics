# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics::Sampler do
  describe '#snapshot' do
    it 'assembles a snapshot from Puma stats and system usage' do
      puma_stats_provider = double(
        'PumaStats',
        snapshot: {
          backlog: 10,
          running: 4,
          pool_capacity: 12,
          max_threads: 16
        }
      )
      system_usage = double(
        'SystemUsage',
        process_cpu_seconds: 3.75,
        resident_memory_bytes: 256
      )

      sampler = described_class.new(
        puma_stats_provider: puma_stats_provider,
        system_usage: system_usage
      )

      snapshot = sampler.snapshot

      expect(snapshot.backlog).to eq(10)
      expect(snapshot.running_threads).to eq(4)
      expect(snapshot.pool_capacity).to eq(12)
      expect(snapshot.max_threads).to eq(16)
      expect(snapshot.cpu_seconds_total).to eq(3.75)
      expect(snapshot.memory_rss_bytes).to eq(256)
    end
  end
end
