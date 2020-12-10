class ChangeTypeColumnMeters < ActiveRecord::Migration[6.0]
  def change
    rename_column :meters, :type, :format
  end
end
