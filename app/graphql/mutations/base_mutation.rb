# frozen_string_literal: true

module Mutations
  # This class is used as a parent for all mutations, and it is the place to have common utilities.
  class BaseMutation < GraphQL::Schema::Mutation
    null false

    def authorize_authenticated_user
      raise GraphQL::ExecutionError, 'User not authenticated' if context[:current_user].blank?
    end
  end
end
