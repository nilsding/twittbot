module Twitter
  class User
    # @return [Boolean] whether the current user is a botadmin
    def admin?
      return false if $bot.nil? or $bot[:config].nil?
      $bot[:config][:admins].include? self.id
    end
  end
end