class AutocompleteController < ApplicationController
  def index
    respond_to do |format|
      format.json {
        render :json => model.autocomplete_results(query_term)
      }
    end
  end
  
  private
  
  def model
    params[:model].classify.constantize
  end
  
  def query_param_name
    if aa_associations_config.autocomplete_query_term_param_names.present?
      aa_associations_config.autocomplete_query_term_param_names.detect do |param_name|
        params.keys.map(&:to_sym).include?(param_name.to_sym)
      end
    else
      :q
    end
  end
  
  def query_term
    params[query_param_name]
  end
  
  def aa_associations_config
    Rails.application.config.aa_associations
  end
end
