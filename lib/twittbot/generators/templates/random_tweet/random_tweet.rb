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

  ## Uncomment the next few lines if you want to add new tweets to the tweet
  ## list on the fly using direct messages.
  ##
  ## Example usage:
  ## !atwt Tweet text
  #cmd :atwt do |args|
  #  # adds args (usually the tweet text) to the list of random tweets unless
  #  # args already is in the list
  #  @config[:tweets] << args unless @config[:tweets].include? args
  #end
  #
  ## Auto-save!  \o/
  #every 1, :hour do
  #  save_config
  #end
end