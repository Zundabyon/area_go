class CreateLures < ActiveRecord::Migration[8.0]
  def change
    create_table :lures do |t|
      t.references :user,      null: false, foreign_key: true
      t.string  :name,         null: false
      t.integer :lure_type,    null: false, default: 0
      t.string  :color_front,  null: false, default: "#ffffff"
      t.string  :color_back,   null: false, default: "#ffffff"
      t.decimal :weight,       precision: 5, scale: 2
      t.integer :buoyancy,     null: false, default: 3

      t.timestamps
    end

    add_index :lures, :lure_type
  end
end
