require 'spec_helper'

describe AutocompleteController do
  let!(:tag){ Factory(:tag, :name => 'Music') }
  
  describe 'get #index' do
    before do
      get :index, :model => 'tag', :q => "Mus", :format => 'json'
    end
    
    it { should respond_with(:success) }
    it { should respond_with_content_type(:json) }
  end
  
  describe 'get #index with no value' do
    before do
      get :index, :model => 'tag', :format => 'json'
    end
    
    it { should respond_with(:success) }
    it { should respond_with_content_type(:json) }
  end
end
