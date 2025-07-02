class AddForeignKeytoComment < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :comments, :comments, column: :parent_id
  end
end
