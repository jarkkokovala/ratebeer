require 'rails_helper'

describe "Beerlist page" do
  before :all do
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: ['headless', 'disable-gpu'] }
    )

    Capybara.register_driver :selenium do |app|
      if ENV.has_key?('TRAVIS')
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: ['headless', 'disable-gpu'] },
          'tunnel-identifier' => ENV["TRAVIS_JOB_NUMBER"]
        )

        hub_url = "#{ENV["SAUCE_USERNAME"]}:#{ENV["SAUCE_ACCESS_KEY"]}@localhost:4445"
        
        Capybara::Selenium::Driver.new(app, 
          browser: :remote, 
          url: "http://#{hub_url}/wd/hub", 
          desired_capabilities: capabilities)
      else
        capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
          chromeOptions: { args: ['headless', 'disable-gpu'] }
        )    

        Capybara::Selenium::Driver.new app,
          browser: :chrome,
          desired_capabilities: capabilities      
      end
    end
    WebMock.disable_net_connect!(allow_localhost: true) 
  end

  before :each do
    @brewery1 = FactoryBot.create(:brewery, name:"Koff")
    @brewery2 = FactoryBot.create(:brewery, name:"Schlenkerla")
    @brewery3 = FactoryBot.create(:brewery, name:"Ayinger")
    @style1 = Style.create name:"Lager"
    @style2 = Style.create name:"Rauchbier"
    @style3 = Style.create name:"Weizen"
    @beer1 = FactoryBot.create(:beer, name:"Nikolai", brewery: @brewery1, style:@style1)
    @beer2 = FactoryBot.create(:beer, name:"Fastenbier", brewery:@brewery2, style:@style2)
    @beer3 = FactoryBot.create(:beer, name:"Lechte Weisse", brewery:@brewery3, style:@style3)
  end

  it "shows the known beers", js:true do
    visit beerlist_path

    puts page.html if ENV.has_key?('TRAVIS')

    expect(page).to have_content "Nikolai"
  end

  it "shows the beers in correct order", js:true do
    visit beerlist_path

    expect(find('table').find('tr:nth-child(2)')).to have_content "Fastenbier"
    expect(find('table').find('tr:nth-child(3)')).to have_content "Lechte Weisse"
    expect(find('table').find('tr:nth-child(4)')).to have_content "Nikolai"
  end
end
