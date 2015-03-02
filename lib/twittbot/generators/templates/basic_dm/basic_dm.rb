<%
  # This is the config for this botpart.
  # It is a hash and will be serialized to YAML and saved to 'etc/template_name.yml'.
  botpart_config = {
    magic_word: "Supercalifragilisticexpialidocious" # (I'll buy you a beer if you can spell this correctly while drunk)
  }
%>
Twittbot::BotPart.new :<%= @template_name %> do
  # This command gives a BotAdmin the ability to tweet via the bot.
  #
  # Example usage (via direct message):
  # !twet This is a tweet
  cmd :twet do |args, _user|
    bot.tweet args
  end

  # This command gives anyone who is followed by the bot the ability to echo
  # back their direct message.
  #
  # Example usage:
  # !echo Hello, world!
  cmd :echo, admin: false do |args, user|
    bot.dm user, args
  end

  ## Uncomment this if you want to remotely stop the bot.
  ##
  ## Example usage:
  ## !stop Supercalifragilisticexpialidocious
  #cmd :stop do |args, user|
  #  exit 0 if args.downcase == @config[:magic_word].downcase
  #end

  # Of course, there's a :direct_message callback too.  This applies to
  # everything that is not a command.
  on :direct_message do |dm|
    if dm.sender.admin?  # You can check if an user is an admin by using the .admin? method.
      dm.reply "You're an admin!  You can use !twet to tweet nice things."
    else
      dm.reply "You're an ordinary user!  Try using !echo on me."
    end
  end
end