class AddGenreToBooks < ActiveRecord::Migration[6.1]
  def change
    add_column :books, :genre, :string
  end
end
