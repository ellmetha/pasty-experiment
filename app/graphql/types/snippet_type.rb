# frozen_string_literal: true

module Types
  class SnippetType < Types::BaseObject
    graphql_name 'Snippet'
    description 'The Snippet type'

    field :id, ID, null: false
    field :lexer, String, null: false
    field :content, String, null: false
    field :expire_in, GraphQL::Types::ISO8601DateTime, null: true
    field :is_one_time, Boolean, null: false
    field :views_counter, Int, null: false
    field :created_at, GraphQL::Types::ISO8601DateTime, null: false
    field :updated_at, GraphQL::Types::ISO8601DateTime, null: true
  end
end
