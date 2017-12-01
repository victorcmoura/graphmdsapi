class AddVisitedToAssociationWithUser < ActiveRecord::Migration[5.1]
  def change
    add_column :association_with_users, :visited, :boolean
  end
end
