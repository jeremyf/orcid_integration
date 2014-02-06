class CreateOrcidProfileRequests < ActiveRecord::Migration
  def change
    create_table :orcid_profile_requests do |t|
      t.integer :user_id, unique: true, index: true, null: false
      t.string :given_names
      t.string :family_name
      t.string :primary_email
      t.string :orcid_profile_id, unique: true, index: true
      t.timestamps
    end
  end
end
