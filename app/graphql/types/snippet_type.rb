# frozen_string_literal: true

module Types
  class SnippetType < Types::BaseObject
    graphql_name 'Snippet'
    description 'The Snippet type'

    field :id, ID, null: false, description: 'Snippet ID'
    field :lexer, String, null: false, description: 'Snippet language'
    field :content, String, null: false, description: 'Snippet content'
    field :expire_in, GraphQL::Types::ISO8601DateTime, null: true, description: 'Expiration date'
    field :is_one_time, Boolean, null: false, description: 'One-time status'
    field :views_counter, Int, null: false, description: 'Number of views'
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
