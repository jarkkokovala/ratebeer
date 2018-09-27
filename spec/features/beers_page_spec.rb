require 'rails_helper'

include Helpers

describe "Beer" do
    let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }

    it "when beer is created with valid content, is added to system" do
        visit new_beer_path

        fill_in('beer[name]', with:'Bisse')
        select('Koff', from:'beer[brewery_id]')
        select('IPA', from:'beer[style]')

        expect{
            click_button('Create Beer')
        }.to change{Beer.count}.by(1)
    end

    it "when beer is created with no name, is not added and error message is output" do
        visit new_beer_path

        select('Koff', from:'beer[brewery_id]')

        expect{
            click_button('Create Beer')
        }.not_to change{Beer.count}

        expect(page).to have_content 'Name is too short'
    end
end