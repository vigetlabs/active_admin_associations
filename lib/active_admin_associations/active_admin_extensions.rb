module ActiveAdmin
  class Resource
    attr_accessor :form_columns
    attr_accessor :form_associations
    attr_accessor :active_association_form
  end
  
  class << self
    def resources
      application.namespaces.values.map{|n| 
        n.resources.resources
      }.flatten.compact.select{|r|
        r.class == ActiveAdmin::Resource
      }.map(&:resource_class)
    end
  end
end
