class LifecycleJob
  include Sidekiq::Job
  sidekiq_options queue: :default, retry: 1

  def perform(class_name, record_id, action, previous_attrs = '{}')
    
    record = fetch_record(class_name, record_id, action, previous_attrs)
    unless record
      sleep 3 # waits for 3 seconds before retrying
      record = fetch_record(class_name, record_id, action, previous_attrs)
    end

    return unless record

    case action
    when 'create'
      record.async_after_create_actions
    when 'update'
      record.async_after_update_actions
    when 'destroy'
      record.async_after_destroy_actions
    end
  end

  private

  def fetch_record(class_name, record_id, action, previous_attrs)
    if action == 'destroy'
      class_name.constantize.new(JSON.parse(previous_attrs))
    else
      class_name.constantize.find_by(id: record_id)
    end
  end
end
