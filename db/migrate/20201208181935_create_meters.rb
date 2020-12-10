class CreateMeters < ActiveRecord::Migration[6.0]
  def change
    create_table :meters do |t|
      t.string :profile
      t.string :name
      t.integer :number
      t.string :account
      t.integer :region_id
      t.integer :type
      t.integer :kt
      t.boolean :inverted

      t.timestamps
    end
  end
end
