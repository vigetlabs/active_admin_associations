require 'test_helper'

class AutocompleteControllerTest < ActionController::TestCase
  context 'AutocompleteController' do
    setup do
      @tag = Factory(:tag, :name => 'Music')
    end
    
    context 'get #index' do
      setup do
        get :index, :model => 'tag', :q => "Mus", :format => 'json'
      end
      
      should respond_with(:success)
      should respond_with_content_type(:json)
    end
  end
end
