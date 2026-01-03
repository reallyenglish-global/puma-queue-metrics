# Puma Queue

Small Rack-compatible exporter that publishes Puma backlog/CPU/memory metrics in Prometheus format. Useful for wiring Kubernetes HPAs (or any Prometheus consumer) to scale Rails pods on queue depth rather than CPU alone.

## Installation

Add this gem to your application:

```ruby
gem 'puma-queue-metrics', git: 'https://github.com/your-org/puma-queue-metrics'
# or when developing locally
# gem 'puma-queue-metrics', path: '../puma-queue-metrics'
```

Run `bundle install` and configure the exporter via an initializer:

```ruby
PumaQueueMetrics.configure do |config|
  config.metric_prefix = 'myapp'
  config.sampler = PumaQueueMetrics::Sampler.new
end
```

Expose the rack app:

```ruby
# config/routes.rb
match '/metrics', to: PumaQueueMetrics.rack_app, via: :get
```

If you already capture backlog metrics elsewhere (e.g. existing instrumentation), inject your own stats provider:

```ruby
PumaQueueMetrics.configure do |config|
  config.sampler = PumaQueueMetrics::Sampler.new(
    puma_stats_provider: PumaQueueMetrics::PerformanceCollectorAdapter
  )
end
```

## Development

1. Run `bundle install`
2. Execute `bundle exec rake spec`
3. Use `bundle exec rubocop` (optional) to keep formatting consistent.
