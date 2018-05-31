


# chap05
spec/features/site_layout_spec.rb

require 'rails_helper'

RSpec.feature "SiteLayout", type: :feature do

  it "should have right links" do
    visit root_path
    click_link "Home"
    expect(page).to have_title(full_title "")
    click_link "sample app"
    expect(page).to have_title(full_title "")
    click_link "About"
    expect(page).to have_title(full_title "About")
    click_link "Help"
    expect(page).to have_title(full_title "Help")
    click_link "Contact"
    expect(page).to have_title(full_title "Contact")
  end

end
