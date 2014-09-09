require 'spec_helper'

describe AutocompleteController do
  let!(:tag){ Factory(:tag, :name => 'Music') }
  
  describe 'get #index' do
    before do
      get :index, :model => 'tag', :q => "Mus", :format => 'json'
    end
    
    it { should respond_with(:success) }

    it "responds with json" do
      response.content_type.should == "application/json"
    end
  end

  describe 'get #index with autocomplete_query_term_param_names config setting set' do
    before do
      Rails.application.config.activeadmin_associations.autocomplete_query_term_param_names = [:q, :term]
      get :index, :model => 'tag', :q => "Mus", :format => 'json'
    end
    after do
      Rails.application.config.activeadmin_associations.autocomplete_query_term_param_names = nil
    end
    
    it { should respond_with(:success) }

    it "responds with json" do
      response.content_type.should == "application/json"
    end
  end
  
  describe 'get #index with no value' do
    before do
      get :index, :model => 'tag', :format => 'json'
    end
    
    it { should respond_with(:success) }

    it "responds with json" do
      response.content_type.should == "application/json"
    end
  end
end
