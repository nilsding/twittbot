<%
  # This is the config for this botpart.
  # It is a hash and will be serialized to YAML and saved to 'etc/template_name.yml'.
  botpart_config = {
    string_to_repeat: 'BONG'
  }

  # Display a message after installation template installation
  post_install_message <<-MSG
Note: You installed a botpart which contains a task.

A task can only be called outside of a running Twittbot process, e.g. from an
UNIX shell or cron.
MSG
%>
Twittbot::BotPart.new :<%= @template_name %> do
  task :bong, desc: 'Big Ben Clock bong!' do
    repeats = Time.now.hour % 12
    repeats = 12 if repeats == 0
    bot.tweet "#{@config[:string_to_repeat]} " * repeats
  end
end
