module ActiveAdminAssociationsHelper
  def collection_relationship_manager(object, association)
    collection = object.send(association.name).page(1)
    relationship_class = object.class.reflect_on_association(association.name).klass
    columns = association.fields.presence || relationship_class.content_columns
    render :partial => 'admin/shared/collection_table', :locals => {
      :object => object,
      :collection => collection,
      :relationship => association.name,
      :columns => columns,
      :relationship_class => relationship_class
    }
  end
  
  def admin_form_for(record)
    active_admin_form_for [:admin, record] do |f|
      f.semantic_errors
      if active_admin_config.form_columns.present?
        f.inputs *active_admin_config.form_columns
      end
      if active_admin_config.active_association_form && active_admin_config.active_association_form.respond_to?(:call)
        active_admin_config.active_association_form.call(f)
      end
      f.buttons
    end
  end
  
  def edit_url_for(record)
    send("edit_admin_#{record.class.model_name.singular}_path", record)
  end
  
  def display_method_name_for(record)
    Formtastic::FormBuilder.collection_label_methods.find { |m| record.respond_to?(m) }
  end
  
  def display_name_for(record)
    record.send(display_method_name_for(record))
  end
  
  def resource_administrated?(model_class)
    ActiveAdmin.resources.include?(model_class)
  end
  
  def relate_to_url(object)
    send("relate_admin_#{object.class.model_name.singular}_path", object)
  end
  
  def page_entries_info(collection, options = {})
    if options[:entry_name]
      entry_name = options[:entry_name]
      entries_name = options[:entries_name]
    elsif collection.empty?
      entry_name = I18n.translate("active_admin.pagination.entry", :count => 1, :default => 'entry')
      entries_name = I18n.translate("active_admin.pagination.entry", :count => 2, :default => 'entries')
    else
      begin
        entry_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => 1)
        entries_name = I18n.translate!("activerecord.models.#{collection.first.class.model_name.i18n_key}", :count => collection.size)
      rescue I18n::MissingTranslationData
        entry_name = collection.first.class.name.underscore.sub('_', ' ')
      end
    end
    entries_name = entry_name.pluralize unless entries_name

    if collection.num_pages < 2
      case collection.size
      when 0; I18n.t('active_admin.pagination.empty', :model => entries_name)
      when 1; I18n.t('active_admin.pagination.one', :model => entry_name)
      else;   I18n.t('active_admin.pagination.one_page', :model => entries_name, :n => collection.total_count)
      end
    else
      offset = collection.current_page * collection.size
      total  = collection.total_count
      I18n.t('active_admin.pagination.multiple', :model => entries_name, :from => (offset - collection.size + 1), :to => offset > total ? total : offset, :total => total)
    end
  end
end
