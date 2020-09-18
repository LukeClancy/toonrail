require 'rails_helper'
require 'devise'

#src: https://stackoverflow.com/questions/32628093/using-devise-in-rspec-feature-tests#32628294
=begin
module Auth
    def create_user!
      @user = User.create(email: 'foo@bar.com', password: '11111111')
    end
  
    def sign_in_user!
      setup_devise_mapping!
      sign_in @user
    end
  
    def sign_out_user!
      setup_devise_mapping!
      sign_out @user
    end
  
    def setup_devise_mapping!
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end
  
    def login_with_warden!
      login_as(@user, scope: :user)
    end
  
    def logout_with_warden!
      logout(:user)
    end
  
    def login_and_logout_with_devise
      sign_in_user!
      yield
      sign_out_user!
    end
  
    def login_and_logout_with_warden
      Warden.test_mode!
      login_with_warden!
      yield
      logout_with_warden!
      Warden.test_reset!
    end
end
=end
#module AuthHelpers
  def get_a_admin_id()
    admin = User.where(role: 'admin').order(id: :desc).first
    if admin == nil
      return 0
    end
    return admin.id
  end
  def get_a_user_id()
    user = User.all.order(id: :desc).first
    if user == nil
      return 0
    end
    return user.id
  end
  def get_create_admin()
    a = get_a_admin_id()
    if a == 0
      return create(:admin).id
    end
    return a
  end


RSpec.shared_context 'unauthenticated user' do
  before(:each) do
    if not @user.nil?
      @user = nil
    end
  end
  after(:each) do
  end  
end
RSpec.shared_context 'authenticated user' do
    before(:each) do
      if @user.nil?
        @user = create(:user)
      elsif @user.role == "admin"
        @user.destroy
        @user = create(:user)
      end
        sign_in(@user)
    end
    after(:each) do
        sign_out(@user)
        @user = nil
    end
end
RSpec.shared_context 'admin user' do
    before(:each) do
        if @user.nil?
          @user = create(:admin)
        elsif @user.role != "admin"
          @user.destroy
          @user = create(:admin)
        end
        sign_in(@user)
    end
    after(:each) do
        sign_out(@user)
        @user = nil
    end
end