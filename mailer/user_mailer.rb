require 'pony'
class UserMailer
  OPTIONS = { :via_options => {
                   address:              'smtp.gmail.com',
                   port:                  587,
                   domain:               'gmail.com',
                   user_name:            ENV['SMTP_USER_NAME'],
                   password:             ENV['SMTP_PASSWORD'],
                   authentication:       'plain',
                   enable_starttls_auto: true  
                },
            :via                  => :smtp }

  def initialize
    Pony.options = OPTIONS
  end
  
  def forgot_password(user)
    body = "Your OTP is: #{user.reset_password_token}"
    Pony.mail(:to => user.email, :from => 'notifications@example.com', :subject => 'Forgot Password', :html_body => body)
  end
end


# Needed my Mail to send our email
        
