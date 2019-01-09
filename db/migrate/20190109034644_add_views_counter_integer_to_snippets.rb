class AddViewsCounterIntegerToSnippets < ActiveRecord::Migration[5.2]
  def change
    add_column :snippets, :views_counter, :integer, null: false, default: 0
  end
end
