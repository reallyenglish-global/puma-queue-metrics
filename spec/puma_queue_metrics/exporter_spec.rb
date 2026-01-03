# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics::Exporter do
  describe '#call' do
    it 'renders the current snapshot as a Rack response' do
      snapshot = instance_double(PumaQueueMetrics::Snapshot)
      allow(snapshot).to receive(:to_prometheus).with(metric_prefix: 'api').and_return("metrics\n")
      sampler = instance_double(PumaQueueMetrics::Sampler, snapshot: snapshot)

      response = described_class.new(sampler: sampler, metric_prefix: 'api').call({})

      expect(response[0]).to eq(200)
      expect(response[1]).to include(
        'Content-Type' => 'text/plain; version=0.0.4',
        'Content-Length' => "8"
      )
      expect(response[2]).to eq(["metrics\n"])
    end
  end
end
