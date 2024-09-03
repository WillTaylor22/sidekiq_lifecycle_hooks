require 'lifecycle_job'

module SidekiqLifecycleHooks
  extend ActiveSupport::Concern

  included do
    after_create_commit :enqueue_async_after_create_actions, if: -> { self.class.method_defined?(:async_after_create_actions) }
    after_update_commit :enqueue_async_after_update_actions, if: -> { self.class.method_defined?(:async_after_update_actions) }
    before_destroy :prepare_async_after_destroy_actions, if: -> { self.class.method_defined?(:async_after_destroy_actions) }
    after_destroy_commit :enqueue_async_after_destroy_actions, if: -> { self.class.method_defined?(:async_after_destroy_actions) }
  end

  private

  def enqueue_async_after_create_actions
    LifecycleJob.perform_async(self.class.name, id, 'create')
  end

  def enqueue_async_after_update_actions
    LifecycleJob.perform_async(self.class.name, id, 'update')
  end

  def prepare_async_after_destroy_actions
    @destroyed_attributes = attributes.to_json
  end

  def enqueue_async_after_destroy_actions
    LifecycleJob.perform_async(self.class.name, id, 'destroy', @destroyed_attributes)
  end
end
