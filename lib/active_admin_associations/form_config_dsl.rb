module ActiveAdminAssociations
  module FormConfigDSL
    def active_association_form(&block)
      config.active_association_form = block
    end

    def form_columns(column_names)
      config.form_columns = column_names
    end

    def form_relationships(relations)
      config.form_relationships = ActiveSupport::OrderedHash[relations]
    end
  end
end