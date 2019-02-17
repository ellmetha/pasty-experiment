# frozen_string_literal: true

require 'test_helper'

class CreateSnippetTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test '#resolve creates a snippet' do
    result = Schema.execute(
      %{mutation {
        createSnippet(
          lexer: "python",
          content:"import datetime",
          expiration: "hours_1"
        ) {
          id
        }
      }},
      context: { current_user: @user }
    )
    snippet = Snippet.find_by(id: result['data']['createSnippet']['id'])
    assert_predicate snippet, 'present?'
    assert_equal 'python', snippet.lexer
    assert_equal 'import datetime', snippet.content
    now_dt = Time.now
    assert now_dt + 1.hour - 2.seconds < snippet.expire_in
    assert now_dt + 1.hour + 2.seconds > snippet.expire_in
    assert_not snippet.is_one_time?
  end

  test '#resolve cannot create a snippet without an expiration' do
    result = Schema.execute(
      %{mutation {
        createSnippet(
          lexer: "python",
          content:"import datetime"
        ) {
          id
        }
      }},
      context: { current_user: @user }
    )
    assert_includes result['errors'][0]['message'], 'expiration'
  end

  test '#resolve expects an authenticated user to work' do
    result = Schema.execute(
      %{mutation {
        createSnippet(
          lexer: "python",
          content:"import datetime",
          expiration: "hours_1"
        ) {
          id
        }
      }}
    )
    assert_operator result['errors'].length, :>, 0
    assert_includes result['errors'][0]['message'], 'not authenticated'
  end
end
