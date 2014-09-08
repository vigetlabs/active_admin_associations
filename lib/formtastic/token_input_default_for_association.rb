module Formtastic
  module TokenInputDefaultForAssociation
    extend ActiveSupport::Concern
    
    included do
      alias_method_chain :default_input_type, :token_default_for_association
      public :default_input_type
    end
    
    def default_input_type_with_token_default_for_association(method, options = {})
      if @object
        reflection = reflection_for(method)
        if reflection && reflection.klass.respond_to?(:autocomplete_attribute) && reflection.macro == :belongs_to
          return :token
        end
      end
      default_input_type_without_token_default_for_association(method, options)
    end
  end
end
