require 'spec_helper'

describe Admin::PostsController do
  let!(:post){ Factory(:post) }
  let!(:tag1){ Factory(:tag) }
  let!(:tag2){ Factory(:tag) }
  let!(:user){ Factory(:user) }

  before do
    admin_login_as
    post.tags << tag1
  end
  
  describe 'relate a tag' do
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

  describe 'relate a creator' do
    before do
      put :relate, :id => post.id, :relationship_name => "creator",
        :related_id => user.id
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('The recored has been related.') }
    
    it 'properly relates the record' do
      post.reload.creator(true).should == user
    end
  end
  
  describe 'unrelate a tag' do
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

  describe 'unrelate a creator' do
    before do
      put :unrelate, :id => post.id, :relationship_name => "creator"
    end
    
    it { should respond_with(:redirect) }
    it { should set_the_flash.to('The recored has been unrelated.') }

    it "removes the creator" do
      post.reload.creator(true).should be_nil
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
