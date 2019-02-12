# frozen_string_literal: true

module Mutations
  class CreateSnippet < BaseMutation
    argument :lexer, String, required: true
    argument :content, String, required: true
    argument :expiration, String, required: true

    type Types::SnippetType

    def resolve(lexer: nil, content: nil, expiration: nil)
      authorize_authenticated_user
      snippet = Snippet.new(
        lexer: lexer,
        content: content,
        expiration: expiration,
        user: context[:current_user]
      )
      snippet.require_expiration
      return snippet if snippet.save!
    end
  end
end
