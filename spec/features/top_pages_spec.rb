require 'rails_helper'
# require 'rspec/its'

RSpec.feature "TopPages", type: :feature do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  scenario "Home" do
    visit 'tops/home'
    expect(page).to have_content('Sample App')
    expect(page).to have_title("Home | #{base_title}")
  end

  scenario "Help" do
    visit 'tops/help'
    expect(page).to have_content('Help')
    expect(page).to have_title("Help | #{base_title}")
  end

  scenario "About" do
    visit 'tops/about'
    expect(page).to have_content('About Us')
    expect(page).to have_title("About | #{base_title}")
  end

  scenario "Contact" do
    visit 'tops/contact'
    expect(page).to have_content('Contact')
    expect(page).to have_title("Contact | #{base_title}")
  end

end
