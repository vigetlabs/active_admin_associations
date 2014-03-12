module AdminLoginIntegrationHelper
  def admin_login_as(admin_user = Factory(:admin_user))
    visit '/admin/login'
    fill_in 'admin_user_email', :with => admin_user.email
    fill_in 'admin_user_password', :with => 'BaudP0wer!'
    click_button 'Login'
  end
end
