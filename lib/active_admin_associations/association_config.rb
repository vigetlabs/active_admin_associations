module ActiveAdminAssociations
  class AssociationConfig
    include Enumerable
    
    class Association
      attr_reader :name
      attr_reader :fields

      def initialize(name, fields = [], &block)
        @name = name.to_sym
        @fields = fields
        instance_exec(&block) if block_given?
      end
      
      def field(name)
        @fields << name
      end
      
      def fields(*names)
        @fields += names
      end
    end
    
    attr_reader :association_configs
    delegate :each, :to => :association_configs

    def initialize(&block)
      @association_configs = []
      instance_exec(&block)
    end
    
    def blank?
      @association_configs.blank?
    end
    
    def [](association_name)
      @association_configs.detect {|a| a.name == association_name.to_sym }
    end
    
    def association(name, fields = [], &block)
      @association_configs << Association.new(name, fields, &block)
    end
    
    def associations(*names)
      names.each do |name|
        @association_configs << Association.new(name)
      end
    end
  end
end
