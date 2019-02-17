# frozen_string_literal: true

class Schema < GraphQL::Schema
  default_max_page_size(100)
  mutation(Types::MutationType)
  query(Types::QueryType)
end
