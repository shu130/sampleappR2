



TopPages
  Home
    should text "Sample App"
    should have title "Ruby on Rails Tutorial Sample App"
    should not have title "Home | Ruby on Rails Tutorial Sample App"
  Help
    should text "Help"
    should have title "Help | Ruby on Rails Tutorial Sample App"
  About
    should text "About Us"
    should have title "About | Ruby on Rails Tutorial Sample App"
  Contact
    should text "Contact"
    should have title "Contact | Ruby on Rails Tutorial Sample App"


# chap05
# spec/features/top_pages_spec.rb

require 'rails_helper'

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



full_title ヘルパーメソッド
subject

scenario が 使えなかったので describe に変更

Failure/Error: before { visit root_path }
 `before` is not available from within an example (e.g. an `it` block) or from constructs that run in the scope of an example (e.g. `before`, `let`, etc). It is only available on an example group (e.g. a `describe` or `context` block).




# chap03
# spec/features/top_pages_spec.rb

require 'rails_helper'

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
