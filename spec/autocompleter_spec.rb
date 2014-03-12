require 'spec_helper'

describe ActiveAdminAssociations::Autocompleter do
  let!(:tag) { Factory(:tag, :name => "Space") }
  
  context 'with a custom formatter' do
    before do
      Rails.application.config.activeadmin_associations.autocomplete_result_formatter = proc {|record, autocomplete_attribute, autocomplete_options|
        {"name" => record.send(autocomplete_attribute), "id"  => record.id}
      }
    end
    after do
      Rails.application.config.activeadmin_associations.autocomplete_result_formatter = nil
    end
    
    it 'returns the result with the correct format' do
      results = Tag.autocomplete_results("spa")
      results.first.should == {"name" => "Space", "id" => tag.id}
    end
  end
  
  context 'with defulat formatter' do
    it 'returns the result with the correct format' do
      results = Tag.autocomplete_results("spa")
      results.first.should == {"label" => "Space", "value" => "Space", "id" => tag.id}
    end
  end
  
  context 'with a custom label formatter that is a method on the class' do
    before do
      Tag.autocomplete_options[:format_label] = :format_label_for_autocomplete
    end
    after do
      Tag.autocomplete_options = {}
    end
    
    it 'returns the result with the correct format' do
      results = Tag.autocomplete_results("spa")
      results.first.should == {"label" => "Space: #{tag.taggings.count}", "value" => "Space", "id" => tag.id}
    end
  end
  
  context 'with a custom label formatter that is a method on the class' do
    before do
      Tag.autocomplete_options[:format_label] = proc{|record|
        "#{record.name}: Tag"
      }
    end
    after do
      Tag.autocomplete_options = {}
    end
    
    it 'return the result with the correct format' do
      results = Tag.autocomplete_results("spa")
      results.first.should == {"label" => "Space: Tag", "value" => "Space", "id" => tag.id}
    end
  end
end
