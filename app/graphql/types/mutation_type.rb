# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_snippet, mutation: Mutations::CreateSnippet
  end
end
