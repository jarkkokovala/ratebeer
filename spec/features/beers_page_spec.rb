require 'rails_helper'

include Helpers

describe "Beer" do
    let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
    let!(:style) { FactoryBot.create :style, name:"IPA" }
    let!(:user) { FactoryBot.create :user, username:"Pekka", password:"Foobar1"}

    it "when beer is created with valid content, is added to system" do
        sign_in(username: 'Pekka', password: 'Foobar1')

        visit new_beer_path

        fill_in('beer[name]', with:'Bisse')
        select('Koff', from:'beer[brewery_id]')
        select('IPA', from:'beer[style_id]')

        expect{
            click_button('Create Beer')
        }.to change{Beer.count}.by(1)
    end

    it "when beer is created with no name, is not added and error message is output" do
        sign_in(username: 'Pekka', password: 'Foobar1')

        visit new_beer_path

        select('Koff', from:'beer[brewery_id]')

        expect{
            click_button('Create Beer')
        }.not_to change{Beer.count}

        expect(page).to have_content 'Name is too short'
    end
end