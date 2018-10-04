require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name:"Koff" }
  let!(:style) { FactoryBot.create :style, name:"IPA" }
  let!(:beer1) { FactoryBot.create :beer, name:"iso 3", style:style, brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name:"Karhu", style:style, brewery:brewery }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: 'Pekka', password: 'Foobar1')
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "when new ratings are added, are listed on" do
    r1 = FactoryBot.create :rating, score: 10, beer: beer1, user: user
    r2 = FactoryBot.create :rating, score: 20, beer: beer2, user: user

    visit ratings_path

    expect(page).to have_content "#{beer1.name} #{r1.score}"
    expect(page).to have_content "#{beer2.name} #{r2.score}"
    expect(page).to have_content "Number of ratings: #{user.ratings.count}"
  end

  it "when rating is removed, it goes away" do
    r1 = FactoryBot.create :rating, score: 10, beer: beer1, user: user
    r2 = FactoryBot.create :rating, score: 20, beer: beer2, user: user

    visit user_path(user)
    click_link('delete', match: :first)
    expect(Rating.count).to be(1)
  end
end