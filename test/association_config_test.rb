require 'test_helper'

class AutocompleterTest < ActiveSupport::TestCase
  context 'AssociationConfig' do
    setup do
      @config = ActiveAdminAssociations::AssociationConfig.new do
        associations :pages, :photos
        association :tags, [:name]
        association :posts do
          fields :title, :published_at, :creator
        end
        association :videos do
          field :title
          field :description
        end
        association :products, [:name, :pid] do
          field :description
        end
      end
    end
    
    should 'correctly configure multiple associtions at a time' do
      assert @config[:pages].fields.blank?
      assert @config[:photos].fields.blank?
    end
    
    should 'correctly configure with a fields parameter' do
      assert_equal [:name], @config[:tags].fields
    end
    
    should 'correctly configure with a block using the fields method' do
      assert_equal [:title, :published_at, :creator], @config[:posts].fields
    end
    
    should 'correctly configure with a block using the field method' do
      assert_equal [:title, :description], @config[:videos].fields
    end
    
    should 'correctly configure with a block and the fields parameter' do
      assert_equal [:name, :pid, :description], @config[:products].fields
    end
  end
end
