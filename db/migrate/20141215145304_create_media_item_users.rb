class CreateMediaItemUsers < ActiveRecord::Migration
  def up
    create_table :media_item_users do |t|
      t.integer :user_id
      t.integer :media_item_id
      t.timestamps
    end
  end

  def down
    drop_table :media_item_users
  end
end
