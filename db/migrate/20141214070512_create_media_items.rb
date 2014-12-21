class CreateMediaItems < ActiveRecord::Migration
  def up
    create_table :media_items do |t|
      t.string :name
      t.string :url
      t.integer :user_id
      t.timestamps
    end
  end

  def down
    drop_table :media_items
  end
end
