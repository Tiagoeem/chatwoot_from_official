class Api::V1::ThemeController < Api::BaseController
  def colors
    theme_colors = Rails.application.config.try(:theme).try(:[], 'colors') || {}
    render json: theme_colors
  end
end
