module Twitter
  class DirectMessage
    # Replies to this direct message.
    # @param direct_message_text [:String] direct message text
    def reply(direct_message_text)
      return if $bot.nil? or $bot[:client].nil?

      $bot[:client].create_direct_message self.sender.id, direct_message_text
    rescue Twitter::Error => e
      puts "caught Twitter error while replying via DM: #{e.message}"
    end
  end
end