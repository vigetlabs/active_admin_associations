require 'test_helper'

class ActiveAdminAssociationsTest < ActionDispatch::IntegrationTest
  setup do
    admin_login_as
    @post = Factory(:post)
    @tag = Factory(:tag)
    @post.tags = [@tag]
  end
  
  context 'editing a post' do
    setup do
      visit "/admin/posts/#{@post.id}/edit"
    end
    
    should 'have correct inputs from form_columns config' do
      assert page.has_selector?('form.post fieldset.inputs input#post_title'), 'no input for Post title'
      assert page.has_selector?('form.post fieldset.inputs textarea#post_body'), 'no input for Post body'
      assert page.has_selector?('form.post fieldset.inputs input#post_creator_id'), 'no input for Post creator'
    end
    
    should 'have correct inputs from active_association_form config' do
      assert page.has_selector?('form.post fieldset#more-inputs input.my-date-picker#post_published_at'), 'no input for Post published_at'
      assert page.has_selector?('form.post fieldset#more-inputs input#post_featured'), 'no input for Post featured'
    end
    
    should 'have correct token input for post creator' do
      token_input = page.find('form.post fieldset.inputs input.token-input#post_creator_id')
      assert_equal 'hidden', token_input["type"]
      assert_equal 'user', token_input['data-model-name']
      assert_equal '1', token_input['value']
      assert_equal [{"value" => "Bill Tester", "id" => @post.creator_id}], MultiJson.decode(token_input['data-pre'])
    end
    
    should 'have a form to relate new tags' do
      assert page.has_selector?('.relationship-table#relationship-table-tags form.relate-to-form')
      assert page.has_selector?('#relationship-table-tags form.relate-to-form input[type="hidden"]#relationship_name')
      assert_equal 'tags', page.find('#relationship-table-tags form.relate-to-form input#relationship_name')['value']
      token_input = page.find('#relationship-table-tags form.relate-to-form input.token-input#related_id')
      assert_equal 'tag', token_input['data-model-name']
    end
    
    should 'have a table of the related tags' do
      assert page.has_xpath?('//div[@id="relationship-table-tags"]//table[@class="index_table"]/thead//th[text()="Name"]')
      assert_equal @tag.name, page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr[td[1][text()=#{@tag.id}]]//td[2]").text
      edit_link = page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/a[text()='Edit']")
      assert_match %r{\A/admin/tags/\d+/edit}, edit_link['href']
      
      assert page.has_xpath?("//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/form//input[@type='submit'][@value='Unrelate']")
      unrelate_form = page.find(:xpath, "//div[@id='relationship-table-tags']//table[@class='index_table']/tbody//tr/td[3]/form[@class='button_to']")
      unrelate_url = unrelate_form['action']
      assert_match %r{\A/admin/posts/#{@post.id}/unrelate}, unrelate_url
      query_params = unrelate_url.split('?')[1].split('&')
      assert_same_elements ["related_id=#{@tag.id}", 'relationship_name=tags'], query_params
    end
  end

  context 'editing a tag' do
    setup do
      visit "/admin/tags/#{@tag.id}/edit"
    end
    
    should 'have a table of the related posts' do
      assert page.has_xpath?('//div[@id="relationship-table-posts"]//table[@class="index_table"]/thead//th[text()="Title"]')
      assert_equal @post.title, page.find(:xpath, "//div[@id='relationship-table-posts']//table[@class='index_table']/tbody//tr[td[1][text()=#{@post.id}]]//td[2]").text
      assert_equal @post.creator.name, page.find(:xpath, "//div[@id='relationship-table-posts']//table[@class='index_table']/tbody//tr[td[1][text()=#{@post.id}]]//td[3]").text
    end
  end
end
