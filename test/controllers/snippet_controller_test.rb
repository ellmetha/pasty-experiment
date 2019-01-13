require 'test_helper'

class SnippetControllerTest < ActionDispatch::IntegrationTest
  test 'snippet access works as expected' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    assert_response :success
    assert_select 'code', snippet.content
  end

  test 'snippet view counter is incremented when the snippet is browsed' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    snippet.reload
    assert_equal snippet.views_counter, 1
  end

  test 'defines a copy of the showed snippet to allow the user to edit' do
    snippet = FactoryBot.create(:snippet)
    get snippet_url(snippet)
    assert_equal assigns(:new_snippet_from_current).lexer, snippet.lexer
    assert_equal assigns(:new_snippet_from_current).content, snippet.content
  end

  test 'destroys a one-time snippet that is being viewed for the second time' do
    snippet = FactoryBot.create(:snippet, is_one_time: true, views_counter: 1)
    get snippet_url(snippet)
    assert_raises(ActiveRecord::RecordNotFound) do
      Snippet.find(snippet.id)
    end
  end

  test 'allows plain text rendering of a snippet using the raw GET parameter' do
    snippet = FactoryBot.create(:snippet, lexer: 'python', content: 'import datetime')
    get snippet_url(snippet), params: { raw: '' }
    assert_response :success
    assert_equal 'text/plain', @response.content_type
  end
end
