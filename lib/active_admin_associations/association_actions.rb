module ActiveAdminAssociations
  module AssociationActions
    def association_actions
      member_action :unrelate, :method => :put do
        reflection = resource_class.reflect_on_association(params[:relationship_name].to_sym)
        if reflection.collection?
          related_record = reflection.klass.find(params[:related_id])
          resource.send(params[:relationship_name]).delete(related_record)
        else
          resource.update_attribute("#{params[:relationship_name]}_id", nil)
        end
        flash[:notice] = "The recored has been unrelated."
        redirect_to request.headers["Referer"].presence || admin_dashboard_url
      end

      member_action :relate, :method => :put do
        reflection = resource_class.reflect_on_association(params[:relationship_name].to_sym)
        if reflection.collection?
          record_to_relate = reflection.klass.find(params[:related_id])
          resource.send(params[:relationship_name]) << record_to_relate
        else
          resource.update_attribute("#{params[:relationship_name]}_id", record_to_relate)
        end
        flash[:notice] = "The recored has been related."
        redirect_to request.headers["Referer"].presence || admin_dashboard_url
      end

      member_action :page_related, :method => :get do
        relationship_name = params[:relationship_name].to_sym
        render :partial => 'admin/shared/collection_table', :locals => {
          :object             => resource,
          :collection         => resource.send(relationship_name).page(params[:page]),
          :relationship       => relationship_name,
          :columns            => active_admin_config.form_relationships[relationship_name],
          :relationship_class => resource_class.reflect_on_association(relationship_name).klass
        }
      end
    end
  end
end