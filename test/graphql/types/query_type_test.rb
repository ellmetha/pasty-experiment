# frozen_string_literal: true

require 'test_helper'

class QueryTypeTest < ActiveSupport::TestCase
  setup do
    @user = FactoryBot.create(:user)
  end

  test '#snippet finds a snippet using a specific ID' do
    snippet = FactoryBot.create(:snippet, lexer: :python, content: 'import datetime')
    result = Schema.execute(
      %{{
        snippet(id: "#{snippet.id}") {
          id
          lexer
          content
        }
      }},
      context: { current_user: @user }
    )
    assert_equal(
      result['data']['snippet'],
      { 'id' => snippet.id, 'lexer' => snippet.lexer, 'content' => snippet.content }
    )
  end

  test '#snippet expects an authenticated user to work' do
    snippet = FactoryBot.create(:snippet)
    result = Schema.execute(
      %{{
        snippet(id: "#{snippet.id}") {
          id
          lexer
          content
        }
      }}
    )
    assert_operator result['errors'].length, :>, 0
    assert_includes result['errors'][0]['message'], 'not authenticated'
  end

  test '#snippet_connection return paginated lists of snippets' do
    15.times { FactoryBot.create(:snippet, lexer: :python) }
    result = Schema.execute(
      %{{
        snippetConnection(first: 5) {
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          edges {
            node {
              id
              lexer
              content
            }
          }
        }
      }},
      context: { current_user: @user }
    )
    assert_includes result['data']['snippetConnection'], 'pageInfo'
    assert_includes result['data']['snippetConnection']['pageInfo'], 'endCursor'
    assert_includes result['data']['snippetConnection']['pageInfo'], 'startCursor'
    assert_includes result['data']['snippetConnection']['pageInfo'], 'hasPreviousPage'
    assert_includes result['data']['snippetConnection']['pageInfo'], 'hasNextPage'
    assert_equal true, result['data']['snippetConnection']['pageInfo']['hasNextPage']
    assert_operator result['data']['snippetConnection']['edges'].length, :==, 5
    assert_equal 'python', result['data']['snippetConnection']['edges'][0]['node']['lexer']
  end

  test '#snippet_connection expects an authenticated user to work' do
    6.times { FactoryBot.create(:snippet, lexer: :python) }
    result = Schema.execute(
      %{{
        snippetConnection(first: 5) {
          pageInfo {
            endCursor
            startCursor
            hasPreviousPage
            hasNextPage
          }
          edges {
            node {
              id
              lexer
              content
            }
          }
        }
      }}
    )
    assert_operator result['errors'].length, :>, 0
    assert_includes result['errors'][0]['message'], 'not authenticated'
  end
end
