
# 失敗する
#
# Failures:
#
#   1) UserMailer account_activation renders the headers
#      Failure/Error: = link_to "Activate", edit_account_activation_url(@user.activation_token, email: @user.email)
#
#      ActionView::Template::Error:
#        Missing host to link to! Please provide the :host parameter, set default_url_options[:host], or set :only_path to true



require "rails_helper"

RSpec.describe UserMailer, type: :mailer do

  describe "account_activation" do
    let(:user) { create(:user) }
    let(:mail) { UserMailer.account_activation(user) }
    before { user.activation_token = User.new_token }
    it "renders the headers" do
      expect(mail.subject).to eq "Account activation"
      expect(mail.to).to eq user.email
      # expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq "noreply@example.com"
      # expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match user.name
      expect(mail.body.encoded).to match user.activation_token
      expect(mail.body.encoded).to match user.email
    end
  end

  describe "password_reset" do
    let(:mail) { UserMailer.password_reset }

    it "renders the headers" do
      expect(mail.subject).to eq("Password reset")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end




# require "rails_helper"
#
# RSpec.describe UserMailer, type: :mailer do
#   describe "account_activation" do
#     let(:mail) { UserMailer.account_activation }
#
#     it "renders the headers" do
#       expect(mail.subject).to eq("Account activation")
#       expect(mail.to).to eq(["to@example.org"])
#       expect(mail.from).to eq(["from@example.com"])
#     end
#
#     it "renders the body" do
#       expect(mail.body.encoded).to match("Hi")
#     end
#   end
#
#   describe "password_reset" do
#     let(:mail) { UserMailer.password_reset }
#
#     it "renders the headers" do
#       expect(mail.subject).to eq("Password reset")
#       expect(mail.to).to eq(["to@example.org"])
#       expect(mail.from).to eq(["from@example.com"])
#     end
#
#     it "renders the body" do
#       expect(mail.body.encoded).to match("Hi")
#     end
#   end
#
# end
