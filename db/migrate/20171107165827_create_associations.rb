class CreateAssociations < ActiveRecord::Migration[5.1]
  def change
    create_table :associations do |t|

      t.timestamps
    end
  end
end
