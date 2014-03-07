class AutocompleteController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render :json => autocomplete_results
      }
    end
  end
  
  private
  
  def autocomplete_results
    query_term.present? ? model.autocomplete_results(query_term) : []
  end
  
  def model
    params[:model].classify.constantize
  end
  
  def query_param_name
    if activeadmin_associations_config.autocomplete_query_term_param_names.present?
      activeadmin_associations_config.autocomplete_query_term_param_names.detect do |param_name|
        params.keys.map(&:to_sym).include?(param_name.to_sym)
      end
    else
      :q
    end
  end
  
  def query_term
    params[query_param_name]
  end
  
  def activeadmin_associations_config
    Rails.application.config.activeadmin_associations
  end
end
