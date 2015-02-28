<%
  # This is the config for this botpart.
  # It is a hash and will be serialized to YAML and saved to 'etc/template_name.yml'.
  botpart_config = {
    tweets: [
      "I'm a bot!",
      "Fun fact: I run on @nilsding's Twittbot.  https://github.com/nilsding/twittbot",
      "My admin is too lazy to change the default values.",
      "things to do when you're drunk:\n\n1. drink more\n2. repeat step 1",
      "#{'fox ' * 25}"
    ]
  }
%>
Twittbot::BotPart.new :<%= @template_name %> do
  # Every 15 minutes...
  every 15, :minutes do
    # ... tweet a random entry of the :tweets list that you configured
    bot.tweet @config[:tweets].sample
  end
end