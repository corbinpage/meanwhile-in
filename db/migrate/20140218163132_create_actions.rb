class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.text :text
      t.timestamp :start_time
      t.text :url
      t.text :caption
      t.text :username
      t.text :custom1
      t.text :custom2
      t.text :custom3

      t.timestamps
    end
  end
end
