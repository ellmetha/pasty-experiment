# frozen_string_literal: true

class CreateSnippets < ActiveRecord::Migration[5.2]
  def change
    create_table :snippets, id: :uuid do |t|
      t.text :content, null: false
      t.string :lexer, null: false
      t.datetime :expire_in
      t.boolean :is_one_time, null: false, default: false

      t.timestamps
    end
  end
end
