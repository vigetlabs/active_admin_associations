require 'test_helper'

class Admin::PostsControllerTest <  AdminControllerTestCase
  context 'Admin::PostsController' do
    setup do
      admin_login_as
      @post = Factory(:post)
      @tag1 = Factory(:tag)
      @tag2 = Factory(:tag)
      @post.tags << @tag1
    end
    
    context 'relate a resource' do
      setup do
        put :relate, :id => @post.id, :relationship_name => "tags",
          :related_id => @tag2.id
      end
      
      should respond_with(:redirect)
      should set_the_flash.to("The recored has been related.")
      should_change 'Tagging.count', :by => 1
      
      should 'properly have related the record' do
        assert_contains @post.tags(true), @tag2
      end
    end
    
    context 'unrelate a resource' do
      setup do
        put :unrelate, :id => @post.id, :relationship_name => "tags",
          :related_id => @tag1.id
      end
      
      should respond_with(:redirect)
      should set_the_flash.to("The recored has been unrelated.")
      should_change 'Tagging.count', :by => -1
      
      should 'properly have unrelated the record' do
        assert_does_not_contain @post.tags(true), @tag1
      end
    end
    
    context 'page related' do
      setup do
        get :page_related, :id => @post.id, :relationship_name => "tags", :page => 2
      end
      
      should respond_with(:success)
      should render_template("admin/shared/_collection_table")
    end
  end
end
