# frozen_string_literal: true

class AddUserRefToSnippets < ActiveRecord::Migration[5.2]
  def change
    add_reference :snippets, :user, foreign_key: true
  end
end
