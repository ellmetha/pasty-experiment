# frozen_string_literal: true

require 'sidekiq-scheduler'

module Scheduler
  class SnippetCleanupScheduler
    include Sidekiq::Worker

    def perform
      Snippet.expired.in_batches.delete_all
    end
  end
end
