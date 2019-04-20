class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :city
      t.string :last_tavg
      t.references :client, foreign_key: true

      t.timestamps
    end
  end
end
