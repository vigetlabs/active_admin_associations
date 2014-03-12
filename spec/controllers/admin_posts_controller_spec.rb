require 'spec_helper'

describe Admin::PostsController do
  let!(:post){ Factory(:post) }
  let!(:tag1){ Factory(:tag) }
  let!(:tag2){ Factory(:tag) }

  before do
    admin_login_as
    post.tags << tag1
  end
  
  describe 'relate a resource' do
    before do
      @initial_tagging_count = Tagging.count
      put :relate, :id => post.id, :relationship_name => "tags",
        :related_id => tag2.id
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('The recored has been related.') }

    it "adds a new tagging" do
      Tagging.count.should == @initial_tagging_count + 1
    end
    
    it 'properly relates the record' do
      post.tags(true).should include(tag2)
    end
  end
  
  describe 'unrelate a resource' do
    before do
      @initial_tagging_count = Tagging.count
      put :unrelate, :id => post.id, :relationship_name => "tags",
        :related_id => tag1.id
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('The recored has been unrelated.') }

    it "removes a tagging" do
      Tagging.count.should == @initial_tagging_count -1
    end
    
    it 'properly unrelates the record' do
      post.tags(true).should_not include(tag1)
    end
  end
  
  describe 'page related' do
    before do
      get :page_related, :id => post.id, :relationship_name => "tags", :page => 2
    end
    
    it { should respond_with(:success) }
    it { should render_template('admin/shared/_collection_table') }
  end
end
