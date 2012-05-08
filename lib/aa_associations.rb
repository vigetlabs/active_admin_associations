require 'active_support'
require 'activeadmin'
require 'active_admin_associations/version'
require 'active_admin_associations/active_admin_extensions'
require 'formtastic/token_input_default_for_association'
require 'formtastic/inputs/token_input'

module ActiveAdminAssociations
  extend ActiveSupport::Autoload

  eager_autoload do
    autoload :AssociationActions
    autoload :FormConfigDSL
    autoload :RedirectDestroyActions
    autoload :Autocompleter
    autoload :AssociationConfig
  end
end

require 'active_admin_associations/engine'
