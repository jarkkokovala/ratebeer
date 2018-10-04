class AddNameToStyles < ActiveRecord::Migration[5.2]
  def change
    add_column :styles, :name, :string
  end
end
