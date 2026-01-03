# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PumaQueueMetrics do
  before do
    described_class.instance_variable_set(:@configuration, nil)
  end

  describe '.configure' do
    it 'yields a configuration instance' do
      yielded = nil

      described_class.configure do |config|
        yielded = config
        config.metric_prefix = 'api'
      end

      expect(yielded).to be_a(PumaQueueMetrics::Configuration)
      expect(described_class.configuration.metric_prefix).to eq('api')
    end
  end

  describe '.rack_app' do
    it 'memoizes an exporter built with the configured sampler' do
      sampler = instance_double(PumaQueueMetrics::Sampler)
      exporter = instance_double(PumaQueueMetrics::Exporter)
      allow(PumaQueueMetrics::Exporter).to receive(:new).with(sampler: sampler).and_return(exporter)

      described_class.configure { |config| config.sampler = sampler }

      expect(described_class.rack_app).to be(exporter)
      expect(described_class.rack_app).to be(exporter)
    end
  end

  describe '.snapshot' do
    it 'delegates to the configured sampler' do
      snapshot = PumaQueueMetrics::Snapshot.new(
        backlog: 1,
        running_threads: 2,
        pool_capacity: 3,
        max_threads: 4,
        cpu_seconds_total: 5,
        memory_rss_bytes: 6
      )
      sampler = instance_double(PumaQueueMetrics::Sampler, snapshot: snapshot)
      described_class.configure { |config| config.sampler = sampler }

      expect(described_class.snapshot).to eq(snapshot)
    end
  end
end
