class CreateSearches < ActiveRecord::Migration[7.1]
  def change
    create_table :searches do |t|
      t.string :query
      t.string :ip_address
      t.integer :times, default: 1

      t.timestamps
    end

    add_index :searches, :query
    add_index :searches, :ip_address
  end
end
