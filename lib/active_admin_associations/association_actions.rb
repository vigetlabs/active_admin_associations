module ActiveAdminAssociations
  module AssociationActions
    def association_actions
      controller do
        include InstanceMethods
      end

      member_action :unrelate, :method => :put do
        unrelate_record
      end

      member_action :relate, :method => :put do
        relate_record
      end

      member_action :page_related, :method => :get do
        page_related_resources
      end
    end

    module InstanceMethods
      private

      def unrelate_record
        if relationship_reflection.collection?
          related_record = relationship_class.find(params[:related_id])
          resource.send(relationship_name).delete(related_record)
        else
          resource.update_attribute(relationship_reflection.foreign_key, nil)
        end

        redirect_back_or_dashboard("The recored has been unrelated.")
      end

      def relate_record
        if relationship_reflection.collection?
          record_to_relate = relationship_class.find(params[:related_id])
          resource.send(relationship_name) << record_to_relate
        else
          resource.update_attribute(relationship_reflection.foreign_key, params[:related_id])
        end

        redirect_back_or_dashboard("The recored has been related.")
      end

      def page_related_resources
        association_config  = active_admin_config.form_associations[relationship_name]
        association_columns = association_config.fields.presence || relationship_class.content_columns
        
        render :partial => 'admin/shared/collection_table', :locals => {
          :object             => resource,
          :collection         => resource.send(relationship_name).page(params[:page]),
          :relationship       => relationship_name,
          :columns            => association_columns,
          :relationship_class => relationship_class
        }
      end

      def relationship_name
        params[:relationship_name].to_sym
      end

      def relationship_reflection
        resource_class.reflect_on_association(relationship_name)
      end

      def relationship_class
        relationship_reflection.klass
      end

      def redirect_back_or_dashboard(flash_message)
        flash[:notice] = flash_message
        redirect_to request.headers["Referer"].presence || admin_dashboard_url
      end
    end
  end
end
