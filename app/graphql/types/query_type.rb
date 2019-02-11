# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :snippet, SnippetType, null: true do
      description 'Find a snippet by ID'
      argument :id, ID, required: true
    end

    field :snippet_connection, SnippetType.connection_type, null: false do
      description 'List snippets'
    end

    def snippet(id:)
      authorize_authenticated_user
      Snippet.find(id)
    end

    def snippet_connection
      authorize_authenticated_user
      Snippet.all
    end

    private

    def authorize_authenticated_user
      raise GraphQL::ExecutionError, 'User not authenticated' if context[:current_user].blank?
    end
  end
end
