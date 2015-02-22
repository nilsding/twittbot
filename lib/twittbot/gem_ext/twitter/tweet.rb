module Twitter
  class Tweet
    def reply(tweet_text, options = {})
      return if $bot.nil? or $bot[:client].nil?
      opts = {
        reply_all: false
      }.merge(options)

      mentions = self.mentioned_users(opts[:reply_all])

      result = "@#{mentions.join(" @")} #{tweet_text}"[(0...140)]

      $bot[:client].update result, in_reply_to_status_id: self.id
    end

    def retweet
      return if $bot.nil? or $bot[:client].nil?
      $bot[:client].retweet self.id
    end

    # Scans the tweet text for screen names.
    # @param reply_all [Boolean] Include all users in the reply.
    # @param screen_name [String] The user's screen name (i.e. that one who clicked "Reply")
    # @return [Array] An array of user names.
    def mentioned_users(reply_all = true, screen_name = $bot[:config][:screen_name])
      userlist = [ self.user.screen_name ]
      if reply_all
        self.text.scan /@([A-Za-z0-9_]{1,16})/ do |user_name|
          user_name = user_name[0]
          userlist << user_name unless userlist.include?(user_name) or screen_name == user_name
        end
      end
      userlist
    end
  end
end