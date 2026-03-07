class AllowNullBuoyancyOnLures < ActiveRecord::Migration[8.0]
  def change
    # スプーンは浮力なし（nil）を許容するよう NOT NULL 制約を外す
    change_column_null :lures, :buoyancy, true
  end
end
