# Sidekiq Lifecycle Hooks

[![Gem Version](https://badge.fury.io/rb/sidekiq_lifecycle_hooks.svg)](https://badge.fury.io/rb/sidekiq_lifecycle_hooks)

Async model lifecycle hooks for Rails, using Sidekiq.

This Ruby on Rails gem lets you replace `after_create`, `after_update`, and `after_destroy` with asynchronous equivelants, improving the performance and decreasing the memory usage of your web server.

Ideal for offloading notifications, analytics, webhooks, large DB writes and anything else that doesn't *need* to delay your response.

This approach is generally easier to write and maintain than creating a whole sidekiq job for every little task. The ease of use also encourages good async hygiene.


## Installation

Setup [Sidekiq](https://github.com/sidekiq/sidekiq) as your background task runner.

Add this line to your application's Gemfile:

```ruby
gem 'sidekiq_lifecycle_hooks'
```

And then execute:

```bash
$ bundle install
```

Include `SidekiqLifecycleHooks` in your ApplicationRecord

```ruby
class ApplicationRecord < ActiveRecord::Base
  include SidekiqLifecycleHooks
end
```

## Usage

In each model, replace any synchronous lifecycle hooks with the following:

```ruby
class MyModel < ApplicationRecord

  # Replace these:
  after_create :report_to_analytics
  after_update :something_else
  after_destroy :another_thing

  # With these:
  def async_after_create_actions
    report_to_analytics
    # and_you_can_add_more_than_one ...
  end

  def async_after_update_actions
    something_else
  end

  def async_after_destroy_actions # READ NOTE BELOW
    another_thing
  end

end
```

## How it works

These methods enqueue a Sidekiq job called `LifecycleJob` which loads your model (or a shallow clone, if after deleting), then runs any methods required.


## Usage notes

### after_destroy creates a shallow clone

async_after_destroy_actions instantiates
`YourObject.new(previous_object_attributes)`
and then runs the methods from this new model.

Any child models of the original will already have been destroyed or rendered inaccessible. If you require those, use a regular before_destroy hook.


### Separate mission critical actions

Errors prevent subsequent methods from running.

```
  def async_after_create_actions
    report_to_analytics
    raise # Oops
    create_slack_notification # Will not run
  end
```

Enqueue mission critical tasks in seperate Sidekiq jobs.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/WillTaylor22/sidekiq_lifecycle_hooks. This project is intended to be a safe, welcoming space for collaboration. Please be chill in this project's codebase and issue tracker.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
