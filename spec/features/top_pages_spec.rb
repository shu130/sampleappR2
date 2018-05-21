require 'rails_helper'
# require 'rspec/its'

RSpec.feature "TopPages", type: :feature do

  subject { page }

  describe "Home" do
    before { visit root_path }
    it { should have_content('Sample App') }
    it { should have_title(full_title "") }
    it { should_not have_title(full_title "Home") }
  end

  describe "Help" do
    before { visit help_path }
    it { should have_content('Help') }
    it { should have_title(full_title "Help") }
  end

  describe "About" do
    before { visit about_path }
    it { should have_content('About Us') }
    it { should have_title(full_title "About") }
  end

  describe "Contact" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title "Contact") }
  end

end



# RSpec.feature "TopPages", type: :feature do
#
#   let(:base_title) { "Ruby on Rails Tutorial Sample App" }
#
#   scenario "Home" do
#     visit root_path
#     expect(page).to have_content('Sample App')
#     expect(page).to have_title("Home | #{base_title}")
#   end
#
#   scenario "Help" do
#     visit help_path
#     expect(page).to have_content('Help')
#     expect(page).to have_title("Help | #{base_title}")
#   end
#
#   scenario "About" do
#     visit about_path
#     expect(page).to have_content('About Us')
#     expect(page).to have_title("About | #{base_title}")
#   end
#
#   scenario "Contact" do
#     visit contact_path
#     expect(page).to have_content('Contact')
#     expect(page).to have_title("Contact | #{base_title}")
#   end
#
# end
