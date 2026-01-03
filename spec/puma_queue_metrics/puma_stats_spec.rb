# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics::PumaStats do
  describe '.snapshot' do
    it 'aggregates worker statuses when clustered' do
      stats = {
        'worker_status' => [
          { 'last_status' => { 'backlog' => 2, 'running' => 1, 'pool_capacity' => 3, 'max_threads' => 5 } },
          { 'last_status' => { 'backlog' => 1, 'running' => 2, 'pool_capacity' => 4, 'max_threads' => 5 } }
        ]
      }
      stub_const('Puma', double(stats: JSON.generate(stats)))

      snapshot = described_class.snapshot

      expect(snapshot).to eq(backlog: 3, running: 3, pool_capacity: 7, max_threads: 10)
    end

    it 'returns single worker stats when cluster data absent' do
      stats = {
        'backlog' => '4',
        'running' => '2',
        'pool_capacity' => '8',
        'max_threads' => '16'
      }
      stub_const('Puma', double(stats: JSON.generate(stats)))

      expect(described_class.snapshot).to eq(
        backlog: 4,
        running: 2,
        pool_capacity: 8,
        max_threads: 16
      )
    end

    it 'returns an empty hash when Puma is unavailable' do
      hide_const('Puma')

      expect(described_class.snapshot).to eq({})
    end
  end
end
