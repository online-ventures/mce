class AdminConstraint
  def matches?(request)
    return true if Rails.env.development?
    return false unless request.cookie_jar['user_credentials'].present?
    user = User.find_by_persistence_token(request.cookie_jar['user_credentials'].split(':')[0])
    user.present?
  end
end
