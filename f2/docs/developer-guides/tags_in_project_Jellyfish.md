Tags in Project Jellyfish
============

This document contains information on how tags are implemented in Project Jellyfish and how they can be used.

#### Setup Process

Add the `acts-as-taggable-on` (see <a href="https://github.com/mbleigh/acts-as-taggable-on" target="_blank">acts-as-taggable-on</a>) to your Gemfile:

```ruby
gem 'acts-as-taggable-on'
```

and bundle:

```shell
bundle install
```

Create migrations for the `tags` and `taggings` tables that the gem requires

```shell
# For the latest (>2.4.1) versions :
rake acts_as_taggable_on_engine:install:migrations
```

Run migrations

```shell
rake db:migrate
```

#### Usage

Add `acts_as_taggable` or `acts_as_taggable_on` to model that we want to enable tags upon

```ruby
class Product < ActiveRecord::Base
  acts_as_taggable # Alias for acts_as_taggable_on :tags
  acts_as_taggable_on :clouds, :apps
end
```

Add the following to add, remove or view tags

```ruby
p = Product.where(id: 1).first
p.tag_list.add('awesome')   # add a single tag to generic tag context
p.tag_list.add('cool', 'slick')  # add a multiple tags to generic tag context
p.cloud_list.add('aws')  # add a single tag to cloud tag context
p.save # persist changes to db

p.tag_list
# => ['awesome', 'cool', 'slick']

p.cloud_list
# => ['aws']

```

Context agnostic tags can be added via `record.tag_list.add('tag')` whereas context specific tags like `:clouds` can be added with the list method specific to that context - i.e. `record.cloud_list.add('tag')`

#### Finding Tagged Objects

Acts As Taggable On uses scopes to create an association for tags.
This way you can mix and match to filter down your results.

```ruby
class User < ActiveRecord::Base
  acts_as_taggable_on :tags, :skills
  scope :by_join_date, order("created_at DESC")
end

User.tagged_with("awesome").by_join_date
User.tagged_with("awesome").by_join_date.paginate(:page => params[:page], :per_page => 20)

# Find users that matches all given tags:
User.tagged_with(["awesome", "cool"], :match_all => true)

# Find users with any of the specified tags:
User.tagged_with(["awesome", "cool"], :any => true)

# Find users that has not been tagged with awesome or cool:
User.tagged_with(["awesome", "cool"], :exclude => true)

# Find users with any of the tags based on context:
User.tagged_with(['awesome', 'cool'], :on => :tags, :any => true).tagged_with(['smart', 'shy'], :on => :skills, :any => true)
```

You can also use `:wild => true` option along with `:any` or `:exclude` option. It will be looking for `%awesome%` and `%cool%` in SQL.

__Tip:__ `User.tagged_with([])` or `User.tagged_with('')` will return `[]`, an empty set of records.


#### Schema Relations

![Taggable Gem Schema Relationships](https://cloud.githubusercontent.com/assets/9356425/6903634/4a6997f2-d6e1-11e4-88ee-ec93ac352173.jpg)
