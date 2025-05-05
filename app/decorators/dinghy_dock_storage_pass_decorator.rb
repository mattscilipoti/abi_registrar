class DinghyDockStoragePassDecorator < AmenityPassDecorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def self.icon_name
    helpers.icon_for_scope('dinghy')
  end

  def slip_number
    object.location
  end

  def self.table_name
    'dinghy_dock_storage_passes'
  end
end
