class PointStylesToRealStyles < ActiveRecord::Migration[5.2]
  def change
    Beer.all.each do |b|
      b.style = Style.all.find_by(name:b.old_style)
      b.save
    end
  end
end
