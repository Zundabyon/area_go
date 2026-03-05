class CreateCatchRecords < ActiveRecord::Migration[8.0]
  def change
    create_table :catch_records do |t|
      t.references :user,     null: false, foreign_key: true
      t.references :facility, null: false, foreign_key: true
      t.references :lure,     null: true,  foreign_key: true

      t.decimal  :size_cm,              precision: 5, scale: 1
      t.string   :fish_species
      t.decimal  :latitude,             precision: 10, scale: 7
      t.decimal  :longitude,            precision: 10, scale: 7
      t.decimal  :depth_m,              precision: 5, scale: 2
      t.jsonb    :fishing_method_data,  default: {}
      t.text     :memo
      t.datetime :caught_at,            null: false
      t.time     :stocking_time

      t.timestamps
    end

    add_index :catch_records, :caught_at
    add_index :catch_records, :fishing_method_data, using: :gin
  end
end
