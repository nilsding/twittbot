<%
  # This is the config for this botpart.
  # It is a hash and will be serialized to YAML and saved to 'etc/template_name.yml'.
  botpart_config = {
    tags: [
      'twittbot',
      '#nilsding'
    ]
  }

  # Display a message after installation template installation
  post_install_message <<-MSG
Note: This botpart may require some changes to the bot's config:

  If you want to include tweets from users other than those your bot follows,
  add the same tags you have in your etc/#{@template_name}.yml to the ':track:'
  section of your #{::Twittbot::CONFIG_FILE_NAME}.
MSG
%>
Twittbot::BotPart.new :<%= @template_name %> do
  # When there's a new tweet in the timeline...
  on :tweet do |tweet, opts|
    # ... ignore this tweet if it is from ourselves ...
    next if tweet.user.screen_name == @config[:screen_name]
    # ... check if the tweet text contains at least one of the tags defined in your config...
    @config[:tags].each do |tag|
      if tweet.text.downcase.include? tag.downcase
        # ... and finally retweet it, if the tweet is not a retweet.
        tweet.retweet unless opts[:retweet]
        break
      end
    end
  end
end
