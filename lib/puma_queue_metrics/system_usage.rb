# frozen_string_literal: true

module PumaQueueMetrics
  module SystemUsage
    module_function

    STATM_PATH = '/proc/self/statm'

    def process_cpu_seconds
      Process.clock_gettime(Process::CLOCK_PROCESS_CPUTIME_ID)
    rescue StandardError
      nil
    end

    def resident_memory_bytes
      return unless File.readable?(STATM_PATH)

      statm = File.read(STATM_PATH).split
      pages = statm[1].to_i
      return if pages.zero?

      pages * page_size
    rescue StandardError
      nil
    end

    def page_size
      Process::Sys.getpagesize
    rescue StandardError
      4096
    end

    private_class_method :page_size
  end
end
