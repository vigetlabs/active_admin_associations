require 'spec_helper'

describe 'ActiveAdmin Association interface' do
  let!(:post){ Factory(:post) }
  let!(:tag){ Factory(:tag) }

  before do
    admin_login_as
    post.tags = [tag]
  end
  
  describe 'editing a post' do
    before do
      visit "/admin/posts/#{post.id}/edit"
    end
    
    it 'has correct inputs from form_columns config' do
      page.should have_selector('form.post fieldset.inputs input#post_title')
      page.should have_selector('form.post fieldset.inputs textarea#post_body')
      page.should have_selector('form.post fieldset.inputs input#post_creator_id')
    end
    
    it 'has correct inputs from active_association_form config' do
      page.should have_selector('form.post fieldset#more-inputs input.my-date-picker#post_published_at')
      page.should have_selector('form.post fieldset#more-inputs input#post_featured')
    end
    
    it 'has correct token input for post creator' do
      token_input = page.find('form.post fieldset.inputs input.token-input#post_creator_id')
      token_input["type"].should == 'hidden'
      token_input['data-model-name'].should == 'user'
      token_input['value'].should == '1'
      MultiJson.decode(token_input['data-pre']).should == [{"value" => "Bill Tester", "id" => post.creator_id}]
    end
    
    it 'has a form to relate new tags' do
      page.should have_selector('.relationship-table#relationship-table-tags form.relate-to-form')
      page.should have_selector('#relationship-table-tags form.relate-to-form input[type="hidden"]#relationship_name')
      
      page.find('#relationship-table-tags form.relate-to-form input#relationship_name')['value'].should == 'tags'

      token_input = page.find('#relationship-table-tags form.relate-to-form input.token-input#related_id')
      token_input['data-model-name'].should == 'tag'
    end
    
    it 'has a table of the related tags' do
      page.should have_xpath('//div[@id="relationship-table-tags"]//table[@class="index_table"]/thead//th[text()="Name"]')

      related_tag_name = page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr[td[1][text()=#{tag.id}]]//td[2]").text
      related_tag_name.should == tag.name

      edit_link = page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/a[text()='Edit']")
      expect(edit_link['href']).to match(%r{\A/admin/tags/\d+/edit})
      
      page.should have_xpath("//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/form//input[@type='submit'][@value='Unrelate']")

      unrelate_form = page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/form[@class='button_to']")

      unrelate_url = unrelate_form['action']
      expect(unrelate_url).to match(%r{\A/admin/posts/#{post.id}/unrelate})

      query_params = unrelate_url.split('?')[1].split('&')
      query_params.should =~ ["related_id=#{tag.id}", 'relationship_name=tags']
    end
  end

  describe 'deleting a post' do
    before do
      visit "/admin/posts"
    end

    it "redirects back to posts index view" do
      delete_link_tag = page.find('table#index_table_posts tbody tr:first a.delete_link')
      delete_link_tag.click
      current_path.should == "/admin/posts"
    end
  end

  describe 'editing a tag' do
    before do
      visit "/admin/tags/#{tag.id}/edit"
    end
    
    it 'have a table of the related posts' do
      page.should have_xpath('//div[@id="relationship-table-posts"]//table[@class="index_table"]/thead//th[text()="Title"]')

      post_title_text = page.find(:xpath, "//div[@id='relationship-table-posts']//table[@class='index_table']/tbody//tr[td[1][text()=#{post.id}]]//td[2]").text
      post_title_text.should == post.title

      post_creator_name = page.find(:xpath, "//div[@id='relationship-table-posts']//table[@class='index_table']/tbody//tr[td[1][text()=#{post.id}]]//td[3]").text
      post_creator_name.should == post.creator.name
    end
  end
end
