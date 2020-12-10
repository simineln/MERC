class CreateReadings < ActiveRecord::Migration[6.0]
  def change
    create_table :readings do |t|
      t.integer :meter_id
      t.datetime :date
      t.float :ad_p
      t.float :ad_m
      t.float :rd_p
      t.float :rd_m
      t.float :aec_p
      t.float :aec_m
      t.float :rec_p
      t.float :rec_m
      t.float :vph1
      t.float :vph2
      t.float :vph3
      t.float :iph1
      t.float :iph2
      t.float :iph3
      t.float :cosPHI
      t.float :THD_U
      t.float :THD_I

      t.timestamps
    end
  end
end
