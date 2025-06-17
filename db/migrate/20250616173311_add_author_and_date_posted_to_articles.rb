class AddAuthorAndDatePostedToArticles < ActiveRecord::Migration[8.0]
  def change
    add_column :articles, :author, :string
    add_column :articles, :date_posted, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
