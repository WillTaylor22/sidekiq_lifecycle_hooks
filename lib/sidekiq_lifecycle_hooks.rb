require 'lifecycle_job'

module SidekiqLifecycleHooks
  extend ActiveSupport::Concern

  included do
    after_create :enqueue_async_after_create_actions, if: -> { self.class.method_defined?(:async_after_create_actions) }
    after_update :enqueue_async_after_update_actions, if: -> { self.class.method_defined?(:async_after_update_actions) }
    after_destroy :enqueue_async_after_destroy_actions, if: -> { self.class.method_defined?(:async_after_destroy_actions) }
  end

  private

  def enqueue_async_after_create_actions
    LifecycleJob.perform_in(1.second, self.class.name, id, 'create')
  end

  def enqueue_async_after_update_actions
    LifecycleJob.perform_in(1.second, self.class.name, id, 'update')
  end

  def enqueue_async_after_destroy_actions
    LifecycleJob.perform_in(1.second, self.class.name, id, 'destroy', attributes.to_json)
  end
end
