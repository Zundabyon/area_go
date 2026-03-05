class CreateFacilities < ActiveRecord::Migration[8.0]
  def change
    create_table :facilities do |t|
      t.string  :name,         null: false
      t.string  :address
      t.decimal :latitude,     precision: 10, scale: 7
      t.decimal :longitude,    precision: 10, scale: 7
      t.string  :place_id
      t.string  :phone_number
      t.string  :website_url
      t.text    :description
      t.string  :prefecture
      t.boolean :is_verified,  default: false

      t.timestamps
    end

    add_index :facilities, :place_id, unique: true
    add_index :facilities, [ :latitude, :longitude ]
    add_index :facilities, :prefecture
  end
end
