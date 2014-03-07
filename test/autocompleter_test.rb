require 'test_helper'

class AutocompleterTest < ActiveSupport::TestCase
  context 'Autocompleter' do
    setup do
      @tag = Factory(:tag, :name => "Space")
    end
    
    context 'with a custom formatter' do
      setup do
        Rails.application.config.activeadmin_associations.autocomplete_result_formatter = proc {|record, autocomplete_attribute, autocomplete_options|
          {"name" => record.send(autocomplete_attribute), "id"  => record.id}
        }
      end
      teardown do
        Rails.application.config.activeadmin_associations.autocomplete_result_formatter = nil
      end
      
      should 'return the result with the correct format' do
        results = Tag.autocomplete_results("spa")
        assert_equal({"name" => "Space", "id" => @tag.id}, results.first)
      end
    end
    
    context 'with defulat formatter' do
      should 'return the result with the correct format' do
        results = Tag.autocomplete_results("spa")
        assert_equal({"label" => "Space", "value" => "Space", "id" => @tag.id}, results.first)
      end
    end
    
    context 'with a custom label formatter that is a method on the class' do
      setup do
        Tag.autocomplete_options[:format_label] = :format_label_for_autocomplete
      end
      teardown do
        Tag.autocomplete_options = {}
      end
      
      should 'return the result with the correct format' do
        results = Tag.autocomplete_results("spa")
        assert_equal({"label" => "Space: #{@tag.taggings.count}", "value" => "Space", "id" => @tag.id}, results.first)
      end
    end
    
    context 'with a custom label formatter that is a method on the class' do
      setup do
        Tag.autocomplete_options[:format_label] = proc{|record|
          "#{record.name}: Tag"
        }
      end
      teardown do
        Tag.autocomplete_options = {}
      end
      
      should 'return the result with the correct format' do
        results = Tag.autocomplete_results("spa")
        assert_equal({"label" => "Space: Tag", "value" => "Space", "id" => @tag.id}, results.first)
      end
    end
  end
end
