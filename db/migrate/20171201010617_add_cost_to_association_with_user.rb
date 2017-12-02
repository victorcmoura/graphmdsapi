class AddCostToAssociationWithUser < ActiveRecord::Migration[5.1]
  def change
    add_column :association_with_users, :cost, :integer
  end
end
