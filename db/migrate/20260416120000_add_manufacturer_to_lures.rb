class AddManufacturerToLures < ActiveRecord::Migration[8.0]
  def change
    add_column :lures, :manufacturer, :string
  end
end
