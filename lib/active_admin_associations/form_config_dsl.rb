module ActiveAdminAssociations
  module FormConfigDSL
    def active_association_form(&block)
      config.active_association_form = block
    end

    def form_columns(*column_names)
      config.form_columns = column_names.flatten
    end

    def form_associations(&block)
      config.form_associations = AssociationConfig.new(&block)
    end
  end
end