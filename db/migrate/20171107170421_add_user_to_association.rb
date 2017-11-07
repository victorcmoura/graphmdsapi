class AddUserToAssociation < ActiveRecord::Migration[5.1]
  def change
    add_reference :associations, :user, foreign_key: true
  end
end
