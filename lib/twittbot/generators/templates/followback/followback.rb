Twittbot::BotPart.new :<%= @template_name %> do
  on :follow do |obj|
    if obj.target.screen_name == @config[:screen_name] # only follow source if the target was the bot
      bot.follow(obj.source.id)
    end
  end
end