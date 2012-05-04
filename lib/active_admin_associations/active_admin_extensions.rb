module ActiveAdmin
  class Resource
    attr_accessor :form_columns
    attr_accessor :form_relationships
    attr_accessor :active_association_form
  end
  
  class << self
    def resources
      application.namespaces.values.map{|n| n.resources.resources }.flatten.compact.map(&:resource_class)
    end
  end
end
