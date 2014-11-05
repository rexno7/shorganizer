class CreateShows < ActiveRecord::Migration
  def change
    create_table :shows do |t|
      t.string :name
      t.string :watch_url
      t.string :scrape_url
      t.string :type

      t.timestamps
    end
  end
end
