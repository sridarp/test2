Implementation of Pre and Post Hooks
============

Hooks in Jellyfish are implemented through <a href="http://api.rubyonrails.org/classes/ActiveSupport/Notifications.html" target="_blank">ActiveSupport::Notifications</a> which are part of Rails. Each controller in Jellyfish inherits a private `pre_hook` and `post_hook` method from the <a href="https://github.com/projectjellyfish/api/blob/master/app/controllers/application_controller.rb" target="_blank">Rails Application Controller</a>.

```ruby
class ApplicationController < ActionController::Base
  ...
  private
  ...
  def pre_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/pre_hook', params)
  end
  def post_hook
    ActiveSupport::Notifications.instrument(controller_name + '#' + action_name + '/post_hook', params)
  end
  ...
end
```

### How to Instrument Pre and Post Hooks

To instrument a Pre or Post hook from a controller, add the corresponding `before_action :pre_hook` or `after_action :post_hook` as follows:

```ruby
class SessionsController < Devise::SessionsController
  before_action :pre_hook
  after_action :post_hook
  ...
end
```

This will instrument Pre and Post hook events to subscribers when any route in the controller is triggered.

Hooks are currently active on the following controllers:
- [Project_approvals](https://github.com/projectjellyfish/api/blob/master/app/controllers/project_approvals_controller.rb#L2-L3)
- [Project_staff](https://github.com/projectjellyfish/api/blob/master/app/controllers/project_staff_controller.rb#L2-L3)
- [Projects](https://github.com/projectjellyfish/api/blob/master/app/controllers/projects_controller.rb#L4-L6)
- [Sessions](https://github.com/projectjellyfish/api/blob/master/app/controllers/sessions_controller.rb#L5-L6)
- [Staff](https://github.com/projectjellyfish/api/blob/master/app/controllers/staff_controller.rb#L2-L3)
- ~~[Manage IQ Products](https://github.com/projectjellyfish/api/blob/master/app/controllers/manage_iq_products_controller.rb#L3-L5)~~
- [Products](https://github.com/projectjellyfish/api/blob/master/app/controllers/products_controller.rb#L3-L5)
- [Alerts](https://github.com/projectjellyfish/api/blob/master/app/controllers/alerts_controller.rb#L3-L5)

### How to Subscribe to a Pre or Post Hook (from API)

You can subscribe to instrumented hooks in Jellyfish by adding them under the <a href="https://github.com/projectjellyfish/api/tree/master/config/initializers" target="_blank">`config/initializers`</a> directory.

For example, we could add a new file named `subscribers.rb` to our initializers directory with the following content:

```ruby
...
ActiveSupport::Notifications.subscribe('sessions#create/pre_hook') do |*args|
  # SOME PRE HOOK ACTION
end
ActiveSupport::Notifications.subscribe('sessions#create/post_hook') do |*args|
  # SOME POST HOOK ACTION
end
...
```

Rails will then automatically subscribe to the `sessions#create/pre_hook` and `sessions#create/post_hook` events upon 
initialization.

To see which events correspond to which routes, you can run `rake routes` from the terminal:

```shell
$ rake routes
				Prefix Verb   URI Pattern                   Controller#Action
		 staff_session POST   /staff/sign_in(.:format)      sessions#create
 destroy_staff_session DELETE /staff/sign_out(.:format)		sessions#destroy
 ```

In the above example, we see that the `staff/sign_in` and `staff/sign_out` are mapped to the `sessions#create` 
and `sessions#destroy` routes respectively. Using that information, we can subscribe to Pre and Post hooks using the 
following naming convention:

```ruby
controller_name + '#' + action_name + '/pre_hook'  # FOR A PRE HOOK EVENT
controller_name + '#' + action_name + '/post_hook' # FOR A POST HOOK EVENT
```

ActiveSupport::Notifications provides access to the following attributes which we can use from within our hook 
subscription:

```ruby
...
ActiveSupport::Notifications.subscribe('sessions#create/pre_hook') do |*args|
  @name    = args[0] # => String, name of the event
  @start   = args[1] # => Time, when the instrumented block started execution
  @finish  = args[2] # => Time, when the instrumented block ended execution
  @id      = args[3] # => String, unique ID for this notification
  @payload = args[4] # => Params Hash - custom data specific to route that triggered event
  ...
  # USER DEFINED CODE
  ...
end
...
```

### How to Subscribe to a Pre or Post Hook (from a module)

Subscribing to a Pre or Post hook from a module should be analogous to subscribing from within API. Make sure that the 
module includes Rails and define your subscriptions in a way that will get picked up by Rails on initialization.

