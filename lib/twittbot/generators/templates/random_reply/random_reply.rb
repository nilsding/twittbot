<%
  # This is the config for this botpart.
  # It is a hash and will be serialized to YAML and saved to 'etc/template_name.yml'.
  botpart_config = {
    replies: [
      "Yes.",
      "No.",
      "Absolutely.",
      "I don't think so.",
      "Maybe.",
    ]
  }
%>
Twittbot::BotPart.new :<%= @template_name %> do
  # When someone mentions the bot...
  on :mention do |tweet|
    # ... reply to the tweet with a random entry of the :replies list that you
    # configured and also include every person that was mentioned in the tweet.
    tweet.reply @config[:replies].sample, reply_all: true
  end
end