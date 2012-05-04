module ActiveAdminAssociations
  module RedirectDestroyActions
    def destroy
      destroy!{ request.headers["Referer"].presence || admin_dashboard_url }
    end
  end
end
