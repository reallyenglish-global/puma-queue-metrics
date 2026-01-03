# frozen_string_literal: true

module PumaQueueMetrics
  class Exporter
    CONTENT_TYPE = 'text/plain; version=0.0.4'

    def initialize(sampler:, metric_prefix: PumaQueueMetrics.configuration.metric_prefix)
      @sampler = sampler
      @metric_prefix = metric_prefix
    end

    def call(_env)
      snapshot = @sampler.snapshot
      body = snapshot.to_prometheus(metric_prefix: @metric_prefix)
      [200, { 'Content-Type' => CONTENT_TYPE, 'Content-Length' => body.bytesize.to_s }, [body]]
    end
  end
end
