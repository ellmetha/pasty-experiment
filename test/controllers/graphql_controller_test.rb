# frozen_string_literal: true

require 'test_helper'

class SnippetControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test '#execute allows to execute a query as an authenticated user using an auth token' do
    user = FactoryBot.create(:user)
    token = AuthToken.generate(user)
    snippet = FactoryBot.create(:snippet)
    post(
      graphql_url,
      params: { query: '{snippetConnection{edges{node{id}}}}' },
      headers: { 'X-Pasty-Access-Token': token }
    )
    assert_response :success
    result = JSON.parse(@response.body)
    assert_operator result['data']['snippetConnection']['edges'].length, :==, 1
    assert_equal snippet.id, result['data']['snippetConnection']['edges'][0]['node']['id']
  end

  test '#execute allows to execute a query as an authenticated user using sessions' do
    user = FactoryBot.create(:user)
    sign_in user
    snippet = FactoryBot.create(:snippet)
    post(
      graphql_url,
      params: { query: '{snippetConnection{edges{node{id}}}}' }
    )
    assert_response :success
    result = JSON.parse(@response.body)
    assert_operator result['data']['snippetConnection']['edges'].length, :==, 1
    assert_equal snippet.id, result['data']['snippetConnection']['edges'][0]['node']['id']
  end

  test '#execute returns the appropriate error message in case of a not authenticated request' do
    FactoryBot.create(:snippet)
    post(
      graphql_url,
      params: { query: '{snippetConnection{edges{node{id}}}}' }
    )
    assert_response :success
    result = JSON.parse(@response.body)
    assert_operator result['errors'].length, :>, 0
    assert_includes result['errors'][0]['message'], 'not authenticated'
  end
end
