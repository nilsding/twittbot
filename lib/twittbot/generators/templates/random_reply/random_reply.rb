<%
  # This is the config for this botpart.
  # It is as a hash and will be serialized to YAML, and then stored in 'etc/template_name.yml'.
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
  puts @config[:replies].sample
end