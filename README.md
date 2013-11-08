# ActiveAdmin Associations

[![Code Climate](https://codeclimate.com/github/vigetlabs/active_admin_associations.png)](https://codeclimate.com/github/vigetlabs/active_admin_associations)

This extends ActiveAdmin to allow for better editing of associations.

## Setup

### Install the gem

Add this to your `Gemfile`:

    gem 'aa_associations'

Then run `bundle install`.

### Includes styles we'll need

Add `@import "active_admin_associations";` to the top of your `app/assets/stylesheets/active_admin.css.scss`

These styles are used by both the autocomplete functionality and the association tables at the bottom of form pages.

### Autocomplete

On many applications you end up with large datasets, trying to select an element from those data sets via a select input (Formtastic's default) is less then ideal for a couple reasons. One, it's hard to navigate a large select list. Two, loading all those records into memory to populate the select list can be time consuming and cause the page to load slowly.

So I've packaged [jquery-tokeninput](https://github.com/loopj/jquery-tokeninput), an autocomplete results controller, and an ActiveRecord macro together to help improve this.

If you aren't interested in using any of this just add this to your `application.rb` config:

    config.aa_associations.autocomplete = false

If you do want it here's how you set it up:

#### Setting up autocomplete

First, we'll need to make sure the JS and CSS is setup for the admin part of the site.

* Add `//= require active_admin_associations` to the top of your `app/assets/javascripts/active_admin.js` file.
* Add `autocomplete` statements to models you want to be able to autocomplete in the admin.
  * This first parameter it takes is a column/attribute name like `:title`.
  * The second parameter is an options hash which for now only uses 1 value `:format_label`
    Format Label isn't needed for jquery.tokeninput.js but it is useful when using jQueryUI's autocomplete in other parts of your site. It can allow you to custom format the display label for the autocomplete results displayed by jQueryUI.
    The `:format_label` option should be either a symbol that is a name of a method on an instance of the model, or a proc (or anything that responds to call) that takes 1 parameter which will be the record.
    Example:
      <code><pre>
        autocomplete :name, :format_label => proc {|speaker|
          label =  "<span id=\"speaker-#{speaker.id}\">#{speaker.name} <em>("
          label << "#{speaker.position}, " unless speaker.position.blank?
          label << "#{speaker.talk_count} talk#{'s' unless speaker.talk_count == 1})</em></span>"
          label
        }
      </pre></code>
* Set values for `config.aa_associations.autocomplete_models` in your `config/application.rb`. This should be a list of the models that you have added `autocomplete` statements to:

      `config.aa_associations.autocomplete_models = %w(post user tag)`

If you plan to use other autocomplete JS libraries there are 2 other configs you may want to look at:

Different libraries send different param names for the query to the autocomplete endpoint you give it. For instance, jquery.tokeninput uses the `q` parameter while jQueryUI uses the `term` parameter. If no setting is given we will just use the `q` parameter. To configure this you need a statement like this in your `config/application.rb`:

    config.aa_associations.autocomplete_query_term_param_names = [:q, :term]

It might happen that the hash the autocomplete ActiveRecord macro provides for individual results won't play nice with the JS autocomplete plugin you're using. In this case we provide a way to format individual results yourself. Just assign an object that responds to call (like a proc) to `config.aa_associations.autocomplete_result_formatter` in your `config/application.rb` like so:

    config.aa_associations.autocomplete_result_formatter = proc { |record, autocomplete_attribute, autocomplete_options|
      {:name => record.send(autocomplete_attribute), :id => record.id,
        :another_value => record.send(autocomplete_options[:other_value_method])}
    }


### Other Configuration

We add functionality so that when you do a destroy action you are redirected back to the Referer or the ActiveAdmin Dashboard. If you'd like to remove this functionality you can just put this in your `config/application.rb`:

    config.aa_associations.destroy_redirect = false


### Setup your admin resource definitions

The main thing this Rails Engine provides is a way to easily configure simple forms that handle `has_many` relationships better then how ActiveAdmin does out of the box. Since we don't override any core ActiveAdmin functionality you can include this in resources you want to use it on and not on others.

#### Here's how you get started:

Add `association_actions` somewhere inside your ActiveAdmin resource definition block:

    ActiveAdmin.register Post do
      association_actions
      # ...
    end

You then also need to tell it you want to use the form template bundled with this Engine:

    ActiveAdmin.register Post do
      association_actions
      
      form :partial => "admin/shared/form"
      # ...
    end

Now you need to define the columns and the `has_many` relationships:

    ActiveAdmin.register Post do
      association_actions
      
      form :partial => "admin/shared/form"
      
      form_columns :title, :body, :slug, :author, :published_at, :featured
      
      form_associations do
        association :tags, [:name, :post_count]
        association :revisions do
          fields :version_number, :created_at, :update_at
        end
      end
    end

#### Defining the columns you want to edit in your form:

Pass to the `form_columns` method a list of column that there should be inputs for on the form.


#### Defining associations to manage at the bottom of edit pages:

The `form_associations` is used to define the associations you want to manage at the bottom of the edit pages. This method takes a block that is used to define these associations and the columns to display.

If you use the `associations` method inside the block then you can define multiple associations at once:

    form_associations do
      association :tags, :revisions
    end

In this case all the `content_columns` for the models will be used as the columns in the association tables. This is probably good for getting started quickly but you'll probably find you quickly outgrow it.

You can use individual `association` method calls and pass the list of attributes/methods to use as columns in the table:

    form_associations do
      association :tags, [:name, :post_count]
    end

You can also define the columns inside a block passed to the `association` method with a call to the `fields` method:

    form_associations do
      association :revisions do
        fields :version_number, :created_at, :update_at
      end
    end

Or if you prefer you can use multiple calls to the `field` method:

    form_associations do
      association :revisions do
        field :version_number
        field :created_at
        field :update_at
      end
    end

You are also free to mix and match:

    form_associations do
      association :revisions, [:version_number] do
        fields :created_at, :another_column
        field :update_at
      end
    end


#### Fine grained control over the form:

If you want more control over the main part of the form you can define a `active_association_form` which takes a block with 1 parameter (which is the form object):

    ActiveAdmin.register Post do
      association_actions
      
      form :partial => "admin/shared/form"
      
      active_association_form do |f|
        f.inputs do
          f.input :title
          f.input :body
          f.input :slug, :label => "This is the value that will be used in the URL bar for the post."
        end
        f.inputs do
          f.input :author, :as => :select
          f.input :published_at
        end
      end
      
      form_associations do
        association :tags, [:name, :post_count]
        association :revisions do
          fields :version_number, :created_at, :update_at
        end
      end
    end

#### Overriding the templates

If this still doesn't give you the power you're looking for you can override any of the partial templates this engine uses.

* `admin/shared/_form.html.erb` – you probably don't want to override this one instead you probably want to use your own `_form.html.erb` template in your `app/views/admin/RESOURCE_NAME` directory and have this in your AA resource config: `form :partial => 'form'`. But if you really want to change how all the aa_associations forms look you can.
* `admin/shared/_collection_tabe.html.erb` – this is how we generate the tables for the `has_many` relationships below the form. Once again not something I'd recommend editing.
* `admin/shared/_association_collection_table_actions.html.erb` – this defines the actions that you can do on each related record. The default is "edit" and "unrelate". You may want to override this for instance to define different actions for different models.
* `admin/shared/_add_to_association.html.erb` – This is the form to relate existing records to the parent record.


## Contributing to ActiveAdmin Associations
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2012 Brian Landau (Viget). See MIT_LICENSE.txt for further details.
