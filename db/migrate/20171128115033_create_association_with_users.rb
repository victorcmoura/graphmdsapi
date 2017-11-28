class CreateAssociationWithUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :association_with_users do |t|
      t.integer :user_one_id
      t.integer :user_two_id
      t.timestamps
    end
    add_index :association_with_users, [:user_one_id, :user_two_id]
  end
end
