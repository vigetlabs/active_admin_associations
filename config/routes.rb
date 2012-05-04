if Rails.application.config.aa_associations.autocomplete_models
  models = Rails.application.config.aa_associations.autocomplete_models.join('|')
  Rails.application.routes.draw do
    match '/autocomplete/:model' => 'autocomplete#index', :model => /(#{models})/,
      :defaults => { :format => 'json' }
  end
end
