class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.string :title
      t.float :no
      t.date :air_date
      t.time :air_time
      t.string :season
      t.string :channel
      t.boolean :watched
      t.references :show, index: true

      t.timestamps
    end
  end
end
