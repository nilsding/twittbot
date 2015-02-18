<%
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