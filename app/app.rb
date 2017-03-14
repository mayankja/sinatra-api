class App < Sinatra::Base
  set :show_exceptions, false
  configure do
    register Sinatra::StrongParams
  end

  ALLOWS_PARAMS =  [:id, :first_name, :last_name, :email, :email_notifications_opt, :cell_phone, :sms_notifications_opt, :password, :password_confirmation, :enabled, :old_password]
  # GET /users
  # this for the user listing
  get '/users' do
    @users = User.all
    json response: {
        status: true,
        data: @users
      }
  end
  
  # POST /users
  # this for the user create
  post '/users', allows: ALLOWS_PARAMS, needs: [:first_name, :last_name, :email] do
    @user = User.new(params)
    if @user.save
      json response: {
        status: true,
        data: @user,
      }
    else
      json response: {
        status: false,
        errors: @user.errors
      }
    end
  end
  
  # GET /users/1
  # this for the user show  
  get '/users/:id' do
    @user = User.where(id: params[:id])[0]
    if @user
      json response: {
        status: true,
        data: @user
      }
    else
      json response: {
        status: false,
        errors: "User not found"
      }
    end
  end

  # PUT /users
  # this for the user update
  put '/users/:id', allows: ALLOWS_PARAMS do
    @user = User.where(id: params[:id])[0]
    if @user && @user.update(params)
      json response: {
        status: true,
        data: @user
      }
    else
      json response: {
        status: false,
        errors: (@user ? @user.errors : "User not found")
      }
    end
  end
  
  # DELETE /users/1
  # this for the user destroy
  delete '/users/:id' do
    @user = User.where(id: params[:id])[0]
    if @user && @user.destroy
      json response: {
        status: true,
        data: "Deleted"
      }
    else
      json response: {
        status: false,
        errors: "User not found"
      }
    end
  end

  # this for the forgot_password of the user
  get '/forgot_password' do
    @user = User.where(email: params[:email])[0]
    if @user
      @user.forgot_password_with_email
      json response: { status: true, message: "Please check your email. An otp has been sent to it."}
    else
       json response: { status: false, errors: "Invalid user email" }
    end
  end
  
  # this for the reset_password of the user
  get '/reset_password', allows: ALLOWS_PARAMS , needs: [:password, :password_confirmation, :email, :old_password]do
    @user = User.where(email: params[:email], reset_password_token: params[:old_password])[0]
    if @user && @user.update(params)
      @user.update_columns(reset_password_token: "")
      json response: { status: true, message: "Your password has been reset successfully."}
    else
      json response: { status: false, errors: "Invalid user email and old password" }
    end
  end

  error RequiredParamMissing do
    json response: { status: false, errors: "One or more required parameters were missing" }
  end

  error Sinatra::NotFound do
    json response: { status: false, errors: "Not Found"}
  end
end