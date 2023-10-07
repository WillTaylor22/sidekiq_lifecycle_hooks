class LifecycleJob
  include Sidekiq::Job
  sidekiq_options queue: :default, retry: 1

  def perform(class_name, record_id, action, previous_attrs = '{}')
    return unless (record = if action == 'destroy'
               class_name.constantize.new(JSON.parse(previous_attrs))
             else
               class_name.constantize.find_by(id: record_id)
             end)

    case action
    when 'create'
      record.async_after_create_actions
    when 'update'
      record.async_after_update_actions
    when 'destroy'
      record.async_after_destroy_actions
    end
  end
end
