# frozen_string_literal: true

require_relative 'lib/puma_queue_metrics/version'

Gem::Specification.new do |spec|
  spec.name          = 'puma-queue'
  spec.version       = PumaQueueMetrics::VERSION
  spec.authors       = ['Joey Wang']
  spec.email         = ['engineering@reallyenglish.com']

  spec.summary       = 'Expose Puma backlog, CPU, and memory metrics for autoscaling'
  spec.description   = 'Lightweight exporter that scrapes Puma stats or existing collectors and renders Prometheus text for HPA/Prometheus consumers.'
  spec.homepage      = 'https://github.com/reallyenglish/puma-queue'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*.rb', 'README.md', 'LICENSE']
  spec.require_paths = ['lib']

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage

  spec.add_dependency 'rack', '>= 2.0'
end
