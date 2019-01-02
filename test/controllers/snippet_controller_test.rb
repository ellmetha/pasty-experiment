require 'test_helper'

class SnippetControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get snippet_index_url
    assert_response :success
  end
end
