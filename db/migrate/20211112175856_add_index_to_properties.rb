class AddIndexToProperties < ActiveRecord::Migration[6.1]
  def up
    add_earthdistance_index :properties
  end

  def down
    remove_earthdistance_index :properties
  end
end
