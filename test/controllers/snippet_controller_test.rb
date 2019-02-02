# frozen_string_literal: true

require 'test_helper'

class SnippetControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test 'snippet access works as expected' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    assert_response :success
    assert_select 'code', snippet.content
  end

  test '#show increments the snippet view counter when the snippet is browsed' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    snippet.reload
    assert_equal snippet.views_counter, 1
  end

  test '#show defines a copy of the showed snippet to allow the user to edit it' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    assert_select 'select#snippet_lexer option[selected="selected"]', Snippet::LEXERS[snippet.lexer]
    assert_select 'textarea#snippet_content', snippet.content
  end

  test '#show destroys a one-time snippet if it is being viewed for the second time' do
    snippet = FactoryBot.create(:snippet, is_one_time: true, views_counter: 1)
    get snippet_url(snippet)
    assert_raises(ActiveRecord::RecordNotFound) do
      Snippet.find(snippet.id)
    end
  end

  test '#show allows plain text rendering of a snippet using the raw GET parameter' do
    snippet = FactoryBot.create(:snippet, lexer: 'python', content: 'import datetime')
    get snippet_url(snippet), params: { raw: '' }
    assert_response :success
    assert_equal 'text/plain', @response.content_type
  end

  test '#create creates a new snippet' do
    post(
      snippets_url,
      params: { snippet: { lexer: 'python', content: 'import datetime', expiration: 'days_7' } }
    )
    assert_response :found
    assert_equal Snippet.all.count, 1
    snippet = Snippet.first
    assert_equal snippet.lexer, 'python'
    assert_equal snippet.content, 'import datetime'
    now_dt = Time.now
    assert now_dt + 7.days - 2.seconds < snippet.expire_in
    assert now_dt + 7.days + 2.seconds > snippet.expire_in
  end

  test '#create creates a new snippet associated with the current user if any' do
    user = FactoryBot.create(:user)
    sign_in user
    post(
      snippets_url,
      params: { snippet: { lexer: 'python', content: 'import datetime', expiration: 'days_7' } }
    )
    assert_response :found
    assert_equal Snippet.all.count, 1
    snippet = Snippet.first
    assert_equal user, snippet.user
  end

  test '#create enforces validation of single-value expiration' do
    post snippets_path, params: { snippet: { lexer: 'python', content: 'import datetime' } }
    assert_response :success
    assert_select '.field_with_errors select#snippet_expiration', 1
  end

  test '#user_list cannot be accessed by an anonymous user' do
    get list_user_snippets_path
    assert_redirected_to new_user_session_path
  end

  test '#user_list lists the snippets of a user' do
    user = FactoryBot.create(:user)
    sign_in user

    FactoryBot.create(:snippet, lexer: 'python', content: 'import datetime', user: user)
    FactoryBot.create(:snippet, lexer: 'ruby', content: 'puts "Hello"')

    get list_user_snippets_path
    assert_select '.snippet-preview pre code', 1
    assert_select '.snippet-preview pre code', 'import datetime'
  end
end
