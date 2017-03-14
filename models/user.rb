require 'pony'

class User
  include Mongoid::Document

  field :first_name, type: String
  field :last_name,  type: String
  field :email, type: String
  field :email_notifications_opt, type: String
  field :cell_phone, type: String
  field :sms_notifications_opt, type: String
  field :password, type: String
  field :password_confirmation, type: String
  field :enabled, type: Boolean
  field :reset_password_token, type: String
  
  # validation 
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates_confirmation_of :password
  # old_password is used in place of reset_password_token 
  alias_attribute :old_password, :reset_password_token
  
  after_create :auto_generate_password
  
  # Sending actual notifications for the forgot password to email
  def forgot_password_with_email
    update(reset_password_token: rand(10 ** 8))
    UserMailer.new.forgot_password(self)
  end
  
  # Sending actual notifications for the forgot password to phon number
  def forgot_password_with_phone_number
    update(reset_password_token: rand(10 ** 8))
    msg = "Your OTP is: #{reset_password_token}"
    @twilio_client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN'])
    begin
      @twilio_client.messages.create(to:"#{cell_phone}", from: ENV['TWILIO_PHONE_NUMBER'], body: msg)
    rescue Exception => e
      puts e.message
    end
  end

  # If the password is not supplied via a create (POST) request then we will 
  # auto generate a random password for them
  def auto_generate_password
    if password.nil?
      rand_password = rand(10 ** 8).to_s
      update(password: rand_password, password_confirmation: rand_password)
    end
  end
end
