class AddPublicationDateToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :publication_date, :date
  end
end
