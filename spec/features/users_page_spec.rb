require 'rails_helper'

include Helpers

describe "User" do
  before :each do
    FactoryBot.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username: 'Pekka', password: 'Foobar1')

      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
  end

  it "is redirected back to signin form if wrong credentials given" do
    sign_in(username: 'Pekka', password: 'wrong')

    expect(current_path).to eq(signin_path)
    expect(page).to have_content 'Signin failed!'
  end

  it "when signed up with good credentials, is added to the system" do
    visit new_user_path
    fill_in('user_username', with:'Brian')
    fill_in('user_password', with:'Secret55')
    fill_in('user_password_confirmation', with:'Secret55')
  
    expect{
      click_button('Create User')
    }.to change{User.count}.by(1)
  end

  it "when ratings are created, are displayed on users page and there is favorite style and brewery" do
    user = User.first
    user2 = FactoryBot.create :user, username:"Keijo"
    brewery = FactoryBot.create :brewery, name:"Koff"
    brewery2 = FactoryBot.create :brewery, name:"Olvi"
    style = FactoryBot.create :style, name:"IPA"
    beer1 = FactoryBot.create :beer, name:"iso 3", brewery:brewery
    beer2 = FactoryBot.create :beer, name:"Karhu", style:style, brewery:brewery2
    r1 = FactoryBot.create :rating, score: 10, beer: beer1, user: user
    r2 = FactoryBot.create :rating, score: 20, beer: beer2, user: user
    r3 = FactoryBot.create :rating, score: 30, beer: beer2, user: user2

    visit user_path(user)
    expect(page).to have_content "Favorite style: IPA"
    expect(page).to have_content "Favorite brewery: Olvi"
    expect(page).to have_content "Ratings, average: 15"
    expect(page).to have_content "#{beer1.name}, #{r1.score} points"
    expect(page).to have_content "#{beer2.name}, #{r2.score} points"
    expect(page).not_to have_content "#{beer2.name}, #{r3.score} points"
  end
end