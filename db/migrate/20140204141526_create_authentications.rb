class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id, index: true, null: false
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :access_token
      t.string :refresh_token
      t.timestamp :expires_at, index: true
      t.timestamps
    end
    add_index :authentications, [:provider, :uid], unique: true
  end
end
