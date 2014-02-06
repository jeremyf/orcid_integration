class CreateOrcidProfileRequests < ActiveRecord::Migration
  def change
    create_table :orcid_profile_requests do |t|
      t.integer :user_id, unique: true, index: true
      t.string :payload_attributes
      t.string :orcid_profile_id, unique: true, index: true
      t.timestamps
    end
  end
end
