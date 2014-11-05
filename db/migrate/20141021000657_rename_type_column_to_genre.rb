class RenameTypeColumnToGenre < ActiveRecord::Migration
  def change
    rename_column :shows, :type, :genre
  end
end
