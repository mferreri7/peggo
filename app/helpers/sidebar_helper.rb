module SidebarHelper
  def render_blue_sidebar
    allowed_controllers = {
      buildings: %w[show],
      properties: %w[index show new edit],
      owners: %w[index]
    }
    allowed_controllers[controller_name.to_sym].include?(action_name)
  end
end