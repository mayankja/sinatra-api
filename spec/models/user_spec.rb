#require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) {
     { first_name: "test_first1", last_name: "test_last1", email: "test#{rand(10 ** 8)}@test.com", email_notifications_opt: "123454678", cell_phone: "123456789",
      sms_notifications_opt: "123456789", password: "12345678", password_confirmation: "12345678", enabled: "true" }
  }

  subject {
    described_class.new(valid_attributes)
  }
  
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a first_name" do
    subject.first_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a last_name" do
    subject.last_name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "is uniq an email" do
    subject.email = nil
    expect(subject).to_not be_valid
  end

  it "#forgot_password_with_email" do
    user = User.create! valid_attributes
    user.forgot_password_with_email
    user.reload
    expect(user.reset_password_token).to_not eq("")
  end

  it "#forgot_password_with_phone_number" do
    user = User.create! valid_attributes
    user.forgot_password_with_phone_number
    user.reload
    expect(user.reset_password_token).to_not eq("")
  end

  it "#auto_generate_password" do
    user = User.create!(first_name: "test_first1", last_name: "test_last1", email: "test#{rand(10 ** 8)}@test.com", email_notifications_opt: "123454678", cell_phone: "123456789",
      sms_notifications_opt: "123456789")
    expect(user.password).to_not eq(nil)
  end
end
