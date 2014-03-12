module AdminLoginControllerHelper
  def admin_login_as(admin_user = Factory(:admin_user))
    request.env["devise.mapping"] = Devise.mappings[:admin_user]
    sign_in admin_user
    admin_user
  end
end
