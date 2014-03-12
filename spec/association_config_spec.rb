require 'spec_helper'

describe ActiveAdminAssociations::AssociationConfig do
  subject do
    ActiveAdminAssociations::AssociationConfig.new do
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
  
  it 'correctly configure multiple associtions at a time' do
    subject[:pages].fields.should be_blank
    subject[:photos].fields.should be_blank
  end
  
  it 'correctly configure with a fields parameter' do
    subject[:tags].fields.should == [:name]
  end
  
  it 'correctly configure with a block using the fields method' do
    subject[:posts].fields.should == [:title, :published_at, :creator]
  end
  
  it 'correctly configure with a block using the field method' do
    subject[:videos].fields.should == [:title, :description]
  end
  
  it 'correctly configure with a block and the fields parameter' do
    subject[:products].fields.should == [:name, :pid, :description]
  end
end
