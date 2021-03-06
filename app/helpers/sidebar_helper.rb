module SidebarHelper
  def render_blue_sidebar
    allowed_controllers = {
      businesses: %w[show],
      expenses: %w[index show new create edit update],
      invoices: %w[index show new create edit update],
      payments: %w[index show new create edit update],
      invoice_equivalents: %w[index show new create edit update],
      contacts: %w[index show new create edit update],
      budgets: %w[index new create edit update],
      exports: %w[new create]
    }
    return if allowed_controllers[controller_name.to_sym].nil?

    allowed_controllers[controller_name.to_sym].include?(action_name)
  end
end
