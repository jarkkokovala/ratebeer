require 'rails_helper'

RSpec.describe Beer, type: :model do
  let(:test_brewery) { Brewery.new name: "Koff", year: 1896 }
  describe "is not saved" do
    it "without name" do
      beer = Beer.create style: "Lager", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
    it "without style" do
      beer = Beer.create name: "Koff 3", brewery: test_brewery

      expect(beer).not_to be_valid
      expect(Beer.count).to eq(0)
    end
  end
  it "is saved with name, style and brewery" do
    beer = Beer.create name: "Koff 3", style: "Lager", brewery: test_brewery

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
end
