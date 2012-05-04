module Formtastic
  module Inputs
    class TokenInput
      include Base
      
      def to_html
        input_wrapping do
          label_html <<
            builder.hidden_field(input_name, input_html_options)
        end
      end
      
      def input_html_options
        super.merge({
         :required          => nil,
         :autofocus         => nil,
         :class             => 'token-input',
         'data-model-name' => reflection.klass.model_name.singular
        }).tap do |html_options|
          if record.present?
            html_options["data-pre"] = prepopulated_value.to_json
          end
        end
      end
      
      def prepopulated_value
        [{"value" => name_value, "id" => record.id}]
      end
      
      def name_method
        builder.collection_label_methods.find { |m| record.respond_to?(m) }
      end
      
      def name_value
        record.send(name_method)
      end
      
      def record
        @object.send(method)
      end
    end
  end
end
