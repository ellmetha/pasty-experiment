# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    description 'The query root of this schema'

    field :snippet, SnippetType, null: true do
      description 'Find a snippet by ID'
      argument :id, ID, required: true
    end

    def snippet(id:)
      Snippet.find(id)
    end
  end
end
