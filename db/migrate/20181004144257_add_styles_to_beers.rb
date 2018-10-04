class AddStylesToBeers < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :beers, :styles
  end
end
