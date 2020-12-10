class AddSubregionMeter < ActiveRecord::Migration[6.0]
  def change
    add_column :meters, :subregion, :string
  end
end
