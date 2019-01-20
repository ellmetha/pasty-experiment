require 'sidekiq/testing'
require 'test_helper'

class SnippetCleanupSchedulerTest < ActiveSupport::TestCase
  test '#peform deletes all expired snippets' do
    FactoryBot.create(:snippet, expire_in: Time.now.utc - 7.days)
    FactoryBot.create(:snippet, expire_in: Time.now.utc - 1.days)
    snippet3 = FactoryBot.create(:snippet, expire_in: Time.now.utc + 7.days)
    snippet4 = FactoryBot.create(:snippet, expire_in: nil)

    Sidekiq::Testing.inline! do
      Scheduler::SnippetCleanupScheduler.perform_async
      assert_equal [snippet3, snippet4], Snippet.all
    end
  end
end
