class AddRepositoryToAssociation < ActiveRecord::Migration[5.1]
  def change
    add_reference :associations, :repository, foreign_key: true
  end
end
