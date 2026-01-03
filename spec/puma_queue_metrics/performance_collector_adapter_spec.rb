# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics::PerformanceCollectorAdapter do
  describe '.snapshot' do
    it 'extracts Puma metrics from the collector payload' do
      payload = {
        puma: {
          backlog: 1,
          running: 2,
          pool_capacity: 3,
          max_threads: 4
        }
      }
      stub_const('PerformanceMetricsCollector', double(latest_snapshot: payload))

      expect(described_class.snapshot).to eq(
        backlog: 1,
        running: 2,
        pool_capacity: 3,
        max_threads: 4
      )
    end

    it 'returns an empty hash when the data cannot be read' do
      hide_const('PerformanceMetricsCollector')

      expect(described_class.snapshot).to eq({})
    end
  end
end
