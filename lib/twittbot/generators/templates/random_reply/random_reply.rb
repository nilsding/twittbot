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
  on :tweet do |tweet|
    next if tweet.user.screen_name == @config[:screen_name]
    next unless tweet.text.include? @config[:screen_name]
    tweet.reply @config[:replies].sample, reply_all: true
  end
end