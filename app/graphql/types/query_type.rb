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
      Snippet.find(id)
    end

    def snippet_connection
      Snippet.all
    end
  end
end
