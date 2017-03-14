require "spec_helper"

RSpec.describe App , :type => :controller do

  def app
    App
  end
  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
     { first_name: "test_first1", last_name: "test_last1", email: "test#{rand(10 ** 8)}@test.com", email_notifications_opt: "123454678", cell_phone: "123456789",
      sms_notifications_opt: "123456789", password: "12345678", password_confirmation: "12345678", enabled: "true" }
  }

  let(:invalid_attributes) {
    {first_name: "test_first1", last_name: "test_last1", email: "test@test.com"}
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }
  describe "GET #index" do
    it "assigns all users as @users" do
      user = User.create! valid_attributes
      get '/users'
      expect( JSON.parse(last_response.body)["response"]["data"].collect{|l| l["email"]}).to include(user.email)
      last_response.status.should == 200
    end
  end

  describe "GET #show" do
    it "assigns the requested user as @user" do
      user = User.create! valid_attributes
      get "/users/#{user.id}"
      expect(JSON.parse(last_response.body)["response"]["data"]["email"]).to include(user.email)
      last_response.status.should == 200
    end

    it "User not found" do
      get '/users/54564564353'
      expect(JSON.parse(last_response.body)["response"]["status"]).to eq(false)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new User" do
        post '/users', valid_attributes
        expect(JSON.parse(last_response.body)["response"]["data"]["first_name"]).to eq("test_first1")
        last_response.status.should == 200
      end

      it "assigns a newly created user as @user" do
        post '/users', valid_attributes
        last_response.should be_ok
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        params = invalid_attributes
        user = User.find_or_create_by params
        post '/users', params
        expect(JSON.parse(last_response.body)["response"]["status"]).to eq(false)
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
         { first_name: "test_first2", last_name: "test_last2", email: "test#{rand(10 ** 8)}@test.com", email_notifications_opt: "123454678", cell_phone: "123456789",
          sms_notifications_opt: "123456789", password: "12345678", password_confirmation: "12345678", enabled: "true"}
      }

      it "updates the requested user" do
        user = User.create! valid_attributes
        put "/users/#{user.id}", new_attributes
        user.reload
        expect(user.first_name).to eq("test_first2")
      end

      it "assigns the requested user as @user" do
        user = User.create! valid_attributes
        put "/users/#{user.id}", valid_attributes
        last_response.should be_ok
      end
    end

    context "with invalid params" do
      it "assigns the user as @user" do
        user_1 = User.find_or_create_by invalid_attributes
        user = User.create! valid_attributes
        put "/users/#{user.id}", {email: user_1.email}
        expect(JSON.parse(last_response.body)["response"]["status"]).to eq(false)
      end
    end
  end

  describe "DELETE #destroy" do
    it "<de></de>stroys the requested user" do
      user = User.create! valid_attributes
      expect {
        delete "/users/#{user.id}"
      }.to change(User, :count).by(-1)
    end

    it "<de></de> User not found" do
      delete "/users/hdfshdsgh"
      expect(JSON.parse(last_response.body)["response"]["status"]).to eq(false)
    end
  end
   
  describe "GET #forgot_password" do
    it "forgot password the requested user" do
      user = User.create! valid_attributes
      get '/forgot_password',{email: user.email}
      last_response.should be_successful
    end

    it "<de></de> User not found" do
      get '/forgot_password',{email: ""}
      expect(JSON.parse(last_response.body)["response"]["status"]).to eq(false)
    end
  end

  describe "GET #reset_password" do
    it "reset password the requested user" do
      user = User.create! valid_attributes
      user.forgot_password_with_email
      get '/reset_password', {email: user.email, old_password: user.reset_password_token,
         password: "1234567890", password_confirmation: "1234567890" }
      user.reload
      expect(user.password).to eq("1234567890")
    end
  end
end