# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics::Snapshot do
  describe '#to_prometheus' do
    let(:snapshot) do
      described_class.new(
        backlog: 5,
        running_threads: 3,
        pool_capacity: 9,
        max_threads: 16,
        cpu_seconds_total: 1.5,
        memory_rss_bytes: 1024
      )
    end

    it 'renders gauges and counters with the provided prefix' do
      text = snapshot.to_prometheus(metric_prefix: 'app')

      expect(text).to include("# HELP app_puma_backlog")
      expect(text).to include("app_puma_backlog 5")
      expect(text).to include("app_process_resident_memory_bytes 1024")
      expect(text).to end_with("\n")
    end

    it 'omits metrics whose values are nil' do
      nil_snapshot = described_class.new(
        backlog: nil,
        running_threads: 1,
        pool_capacity: nil,
        max_threads: nil,
        cpu_seconds_total: nil,
        memory_rss_bytes: 2
      )

      text = nil_snapshot.to_prometheus(metric_prefix: 'app')

      expect(text).not_to include('app_puma_backlog')
      expect(text).to include('app_puma_running_threads')
      expect(text).to include('app_process_resident_memory_bytes')
    end
  end
end
