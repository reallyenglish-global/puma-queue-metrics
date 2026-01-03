# frozen_string_literal: true

module PumaQueueMetrics
  class Configuration
    attr_writer :sampler
    attr_accessor :metric_prefix
    attr_reader :exporter

    def initialize
      @metric_prefix = 'turtle'
    end

    def sampler
      @sampler ||= PumaQueueMetrics::Sampler.new
    end

    def exporter=(value)
      @exporter = value
    end
  end
end
