class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :shortcode_sensor
      t.string :epc
      t.string :area
      t.string :timestamp

      t.timestamps
    end
  end
end
