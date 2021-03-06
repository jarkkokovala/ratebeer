require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )
    allow(ApixuApi).to receive(:weather_in).with("helsinki").and_return(
      nil
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
        [ Place.new( name:"Bryggeri", id: 1 ), Place.new( name:"Kaisla", id: 2 ) ]
        )
    allow(ApixuApi).to receive(:weather_in).with("helsinki").and_return(
      nil
    )

    visit places_path
    fill_in('city', with: 'helsinki')
    click_button "Search"

    expect(page).to have_content "Bryggeri"
    expect(page).to have_content "Kaisla"
  end

  it "if no places are found, notice is displayed" do
    allow(BeermappingApi).to receive(:places_in).with("invalid").and_return( [] )
    allow(ApixuApi).to receive(:weather_in).with("helsinki").and_return(
      nil
    )
    
    visit places_path
    fill_in('city', with: 'invalid')
    click_button "Search"

    expect(page).to have_content "No locations in invalid"
  end
end
