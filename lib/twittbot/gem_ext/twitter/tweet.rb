module Twitter
  class Tweet
    # Creates a reply to this tweet.
    # @param tweet_text [:String] tweet text
    # @param options [Hash] A customizable set of options.
    # @option options [Boolean] :reply_all (false) Add all users mentioned in the tweet text to the reply.
    def reply(tweet_text, options = {})
      return if $bot.nil? or $bot[:client].nil?
      opts = {
        reply_all: false
      }.merge(options)

      mentions = self.mentioned_users(opts[:reply_all])

      result = "@#{mentions.join(" @")} #{tweet_text}"[(0...140)]

      $bot[:client].update result, in_reply_to_status_id: self.id
    rescue Twitter::Error => e
      puts "caught Twitter error while replying: #{e.message}"
    end

    # Retweets this tweet.
    def retweet
      return if $bot.nil? or $bot[:client].nil?
      $bot[:client].retweet self.id
    rescue Twitter::Error => e
      puts "caught Twitter error while retweeting: #{e.message}"
    end
    alias rt retweet

    # Favourites a tweet
    def favourite
      return if $bot.nil? or $bot[:client].nil?
      $bot[:client].favorite self.id
    rescue Twitter::Error => e
      puts "caught Twitter error while favouriting: #{e.message}"
    end
    alias fav favourite
    alias fave favourite
    # for the 'muricans
    alias favorite favourite

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

    # Returns the full expanded tweet (over 140 characters)
    # @return [String] The expanded tweet
    def expanded_text
      self.attrs.dig(:extended_tweet, :full_text) || full_text || text
    end
  end
end
