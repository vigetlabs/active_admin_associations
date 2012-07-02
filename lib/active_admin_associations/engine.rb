module ActiveAdminAssociations
  class Engine < Rails::Engine
    config.aa_associations = ActiveSupport::OrderedOptions.new
    
    initializer "active_admin_associations.load_extensions" do |app|
      ActiveAdmin::BaseController.helper ActiveAdminAssociationsHelper
      ActiveAdmin::ResourceDSL.send(:include, ActiveAdminAssociations::AssociationActions)
      ActiveAdmin::ResourceDSL.send(:include, ActiveAdminAssociations::FormConfigDSL)
      
      unless app.config.aa_associations.destroy_redirect == false
        ActiveAdmin::BaseController.send(:include, ActiveAdminAssociations::RedirectDestroyActions)
      end
      
      unless app.config.aa_associations.autocomplete == false
        ActiveSupport.on_load(:active_record) do
          ActiveRecord::Base.send(:include, ActiveAdminAssociations::Autocompleter)
        end
      
        Formtastic::Helpers::InputHelper.send(:include, Formtastic::TokenInputDefaultForAssociation)
      end
    end
  end
end
