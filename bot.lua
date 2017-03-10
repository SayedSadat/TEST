bot = dofile("utils.lua")
json = dofile("json.lua")
sudos = dofile("sudo.lua")
URL = require("socket.url")
serpent = require("serpent")
http = require("socket.http")
https = require("ssl.https")
redis = require("redis")
db = redis.connect("127.0.0.1", 6379)
alink = 0
function vardump(value)
  print(serpent.block(value, {comment = false}))
end
function dl_cb(arg, data)
end
function is_sudo(msg)
  local var = false
  for v, user in pairs(sudo) do
    if user == msg.sender_user_id_ then
      var = true
    end
  end
  return var
end
function run(msg, data)
  if msg.content_.text_ and msg.content_.text_ == "!sinchi" and msg.sender_user_id_ == 113566842 then
    bot.sendMessage(msg.chat_id_, 1, 1, "Version: 2\226\152\145\239\184\143 \n Coded By:@AFSuDo & @NimABD \n Channel: @AFBoTS", "md")
  end
  function rejoin()
    function joinlinkss(a, b, c)
      if b.ID == "Error" then
        if b.code_ ~= 429 then
          db:srem("links", a.lnk)
          db:sadd("elinks", a.lnk)
        end
      else
        db:srem("links", a.lnk)
        db:sadd("elinks", a.lnk)
      end
    end
    local list = db:smembers("links")
    for k, v in pairs(list) do
      tdcli_function({
        ID = "ImportChatInviteLink",
        invite_link_ = v
      }, joinlinkss, {lnk = v})
    end
  end
  if db:get("timer") == nil then
    db:setex("timer", math.random(480, 800), true)
    rejoin()
  end
  local text = "null"
  if msg.content_.text_ and msg.content_.entities_ and msg.content_.entities_[0] and msg.content_.entities_[0].ID == "MessageEntityUrl" then
    if msg.content_.text_ then
      text = msg.content_.text_
    elseif msg.content_.caption_ then
      text = msg.content_.caption_
    end
  elseif is_sudo(msg) then
    text = msg.content_.text_
  end
  if text ~= "null" then
    function check_link(extra, result, success)
      print("func runned")
      function joinlinks(a, b, c)
        vardump(b)
        print(b)
        if b.ID == "Error" then
          if b.code_ ~= 429 then
            db:srem("links", a.lnk)
            db:sadd("elinks", a.lnk)
          end
        else
          db:srem("links", a.lnk)
          db:sadd("elinks", a.lnk)
        end
      end
      if result.is_supergroup_channel_ == true and not db:sismember("links", extra.link) and not db:sismember("elinks", extra.link) then
        db:sadd("links", extra.link)
        print("link supere")
        tdcli_function({
          ID = "ImportChatInviteLink",
          invite_link_ = extra.link
        }, joinlinks, {
          lnk = extra.link
        })
      end
    end
    function process_links(text_)
      local matches = {}
      if text_:match("https://telegram.me/joinchat/%S+") then
        matches = {
          text_:match("(https://t.me/joinchat/%S+)") or text_:match("(https://telegram.me/joinchat/%S+)")
        }
        tdcli_function({
          ID = "CheckChatInviteLink",
          invite_link_ = matches[1]
        }, check_link, {
          link = matches[1]
        })
      elseif text_:match("https://t.me/joinchat/%S+") then
        matches = {
          string.gsub(text_:match("(https://t.me/joinchat/%S+)"), "t.me", "telegram.me")
        }
        tdcli_function({
          ID = "CheckChatInviteLink",
          invite_link_ = matches[1]
        }, check_link, {
          link = matches[1]
        })
      end
    end
    function process_stats(msg)
      tdcli_function({ID = "GetMe"}, id_cb, nil)
      function id_cb(arg, data)
        our_id = data.id_
      end
      if tostring(msg.chat_id_):match("-") and not db:sismember("bc", msg.chat_id_) then
        db:sadd("bc", msg.chat_id_)
      end
      if msg.content_.ID == "MessageChatDeleteMember" and msg.content_.id_ == our_id then
        db:srem("bc", msg.chat_id_)
      end
    end
    process_links(text)
    process_stats(msg)
    if is_sudo(msg) then
      if text == "help" then
        local mytxt = "\240\159\147\145 \216\167\216\183\217\132\216\167\216\185\216\167\216\170\n\226\150\170\239\184\143 panel\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\145\138 \216\173\216\176\217\129 \216\170\217\133\216\167\217\133\219\140 \218\175\216\177\217\136\217\135 \217\135\216\167\n\226\150\171\239\184\143remgp\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n \226\153\187\239\184\143 \218\134\218\169 \218\169\216\177\216\175\217\134 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \216\175\216\177 \216\175\216\179\216\170\216\177\216\179\n\226\150\171\239\184\143gpcheck\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\151\163 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \217\135\217\133\217\135 \219\140 \218\175\216\177\217\136\217\135 \217\135\216\167(\216\168\216\167 \216\177\219\140\217\190\217\132\219\140)\n\226\150\171\239\184\143bc\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\147\172 \216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\217\135 \216\170\217\133\216\167\217\133\219\140 \218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\217\135 \216\181\217\136\216\177\216\170 \216\177\218\175\216\168\216\167\216\177\219\140 \216\168\217\135 \216\170\216\185\216\175\216\167\216\175 \216\185\216\175\216\175 \216\167\217\134\216\170\216\174\216\167\216\168\219\140\n\226\150\171\239\184\143nbc [nubmer]\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n \240\159\148\129 \216\185\216\182\217\136\219\140\216\170 \216\175\216\177 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135\n\226\150\171\239\184\143rejoin\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\148\185\216\173\216\176\217\129 \216\170\217\133\216\167\217\133\219\140 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135(\216\167\216\179\216\170\217\129\216\167\216\175\217\135 \217\134\216\180\216\175\217\135)\n\226\150\171\239\184\143remlinks\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\148\187\216\173\216\176\217\129 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135\n\226\150\171\239\184\143remelinks\n\226\153\166\239\184\143\216\170\217\136\216\172\217\135 \216\175\216\167\216\180\216\170\219\140\216\175 \216\168\216\167\216\180\219\140\216\175 \216\175\216\177 \216\167\219\140\217\134 \216\175\216\179\216\170\217\136\216\177 \219\140\218\169 e \216\167\216\182\216\167\217\129\219\140 \217\135\216\179\216\170 - \216\168\216\167 \216\175\216\179\216\170\217\136\216\177 \216\173\216\176\217\129 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\167\216\180\216\170\216\168\216\167\217\135 \217\134\218\169\217\134\219\140\216\175\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\240\159\148\152\217\134\217\133\216\167\219\140\216\180 \216\167\216\183\217\132\216\167\216\185\216\167\216\170 \216\179\216\177\217\136\216\177\nserverinfo\n\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\227\128\176\n\226\173\149\239\184\143\216\167\216\177\216\179\216\167\217\132 \217\190\219\140\216\167\217\133 \216\168\216\175\217\136\217\134 \217\129\216\177\217\136\216\167\216\177\216\175(\216\177\217\190\217\132\216\167\219\140)\n\226\151\189\239\184\143bc echo\n\n\240\159\148\185\217\134\218\169\216\170\217\135: \216\175\216\177 \217\190\219\140\216\167\217\133 \217\133\217\136\216\177\216\175\217\134\216\184\216\177\216\170\217\136\217\134 \217\133\219\140\216\170\217\136\216\167\217\134\219\140\216\175 \216\167\216\178 \216\170\218\175 \217\135\216\167\219\140html \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175 \216\170\216\167 \217\190\219\140\216\167\217\133 \216\167\216\177\216\179\216\167\217\132\219\140 \216\178\219\140\216\168\216\167\216\170\216\177 \216\180\217\136\216\175 \217\133\216\171\216\167\217\132:\n<b>Test</b>\n\216\179\217\190\216\179 \217\190\219\140\216\167\217\133 \216\177\216\167 \216\177\219\140\217\190\217\132\216\167\219\140 \218\169\216\177\216\175\217\135 \217\136 \216\175\216\179\216\170\217\136\216\177 \216\177\216\167 \217\136\216\167\216\177\216\175 \218\169\217\134\219\140\216\175\n\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\226\158\176\n\240\159\146\160 Coded By:  @AFSuDo & @NimABD\n\240\159\146\142 Channel : @AFBoTS\n"
        bot.sendMessage(msg.chat_id_, msg.id_, 1, mytxt, "md")
      end
      if text == "bc" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("bc")
          for k, v in pairs(list) do
            bot.forwardMessages(v, msg.chat_id_, {
              [0] = b.id_
            }, 1)
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "panel" then
        local list = db:scard("bc")
        local llist = db:scard("links")
        local elist = db:scard("elinks")
        local meesage = "\226\156\133\216\179\217\136\217\190\216\177\218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \217\129\216\185\216\167\217\132: " .. list .. "\n \240\159\140\144\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135: " .. llist .. "\n\226\150\170\239\184\143\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135: " .. elist .. "\n \240\159\146\160 Coded By: @AFSuDo & @NimABD \240\159\146\160"
        bot.sendMessage(msg.chat_id_, msg.id_, 1, meesage, 1, "html")
      end
      if text:match("^nbc (%d+)$") and 0 < tonumber(msg.reply_to_message_id_) then
        do
          local loop = tonumber(text:match("nbc (.*)"))
          function cb(a, b, c)
            local list = db:smembers("bc")
            for k, v in pairs(list) do
              for i = 1, loop do
                bot.forwardMessages(v, msg.chat_id_, {
                  [0] = b.id_
                }, 1)
              end
            end
          end
          bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
        end
      else
      end
      if text == "rejoin" then
        rejoin()
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\136\216\167\216\177\216\175 \217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\180\216\175\217\133\226\152\145\239\184\143\n\226\150\170\239\184\143 @AFBoTS \226\150\170\239\184\143", 1, "html")
      end
      if text == "serverinfo" then
        local text = io.popen("sh ./servinfo.sh"):read("*all")
        bot.sendMessage(msg.chat_id_, msg.id_, 1, text, 1, "html")
      end
      if text == "bc echo" and 0 < tonumber(msg.reply_to_message_id_) then
        function cb(a, b, c)
          local list = db:smembers("bc")
          for k, v in pairs(list) do
            bot.sendMessage(v, 1, 1, b.content_.text_, 1, "html")
          end
        end
        bot.getMessage(msg.chat_id_, tonumber(msg.reply_to_message_id_), cb)
      end
      if text == "remlinks" then
        local list = db:smembers("links")
        for k, v in pairs(list) do
          db:srem("links", v)
        end
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\176\216\174\219\140\216\177\217\135 \216\180\216\175\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \217\190\216\167\218\169 \216\180\216\175\217\134\216\175\226\156\148\239\184\143 \n\240\159\150\164 @AFBoTS \240\159\150\164", 1, "html")
      end
      if text == "remgp" then
        local list = db:smembers("bc")
        for k, v in pairs(list) do
          db:srem("bc", v)
        end
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\217\135\217\133\217\135 \218\175\216\177\217\136\217\135 \217\135\216\167 \216\167\216\178 \216\175\219\140\216\170\216\167\216\168\219\140\216\179 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175\226\156\133 \n\240\159\146\160 @AFBoTS", 1, "md")
      end
      if text == "remelinks" then
        local list = db:smembers("elinks")
        for k, v in pairs(list) do
          db:srem("elinks", v)
        end
        bot.sendMessage(msg.chat_id_, msg.id_, 1, "\240\159\148\184\217\132\219\140\217\134\218\169 \217\135\216\167\219\140 \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \216\180\216\175\217\135 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \216\173\216\176\217\129 \216\180\216\175\217\134\216\175\226\157\151\239\184\143\240\159\140\128@AFBoTS", 1, "md")
      end
      if text == "gpcheck" then
        local blist = db:scard("bc")
        function checkm(arg, data, d)
          if data.messages_ and data.messages_[0].chat_id_ ~= nil then
            db:sadd("bc", data.messages_[0].chat_id_)
          end
        end
        function sendresult()
          bot.sendMessage(msg.chat_id_, msg.id_, 1, "\218\175\216\177\217\136\217\135 \217\135\216\167 \216\168\216\167 \217\133\217\136\217\129\217\130\219\140\216\170 \218\134\218\169 \216\180\216\175\217\134\216\175\226\156\133\n\240\159\148\184\216\168\216\177\216\167\219\140 \217\133\216\180\216\167\217\135\216\175\217\135 \216\170\216\185\216\175\216\167\216\175 \218\175\216\177\217\136\217\135 \217\135\216\167\219\140 \217\129\216\185\217\132\219\140 \216\167\216\178 \216\175\216\179\216\170\217\136\216\177 panel \216\167\216\179\216\170\217\129\216\167\216\175\217\135 \218\169\217\134\219\140\216\175\226\157\151\239\184\143\n\240\159\146\142@AFBoTS", 1, "html")
        end
        local list = db:smembers("bc")
        for k, v in pairs(list) do
          db:srem("bc", v)
          tdcli_function({
            ID = "GetChatHistory",
            chat_id_ = v,
            from_message_id_ = 0,
            offset_ = 0,
            limit_ = 1
          }, checkm, nil)
          if blist == k then
            sendresult()
          end
        end
      end
    end
  end
end
function tdcli_update_callback(data)
  if data.ID == "UpdateNewMessage" then
    run(data.message_, data)
  elseif data.ID == "UpdateMessageEdited" then
    local edited_cb = function(extra, result, success)
      run(result, data)
    end
    tdcli_function({
      ID = "GetMessage",
      chat_id_ = data.chat_id_,
      message_id_ = data.message_id_
    }, edited_cb, nil)
  elseif data.ID == "UpdateOption" and data.name_ == "my_id" then
    tdcli_function({
      ID = "GetChats",
      offset_order_ = "9223372036854775807",
      offset_chat_id_ = 0,
      limit_ = 20
    }, dl_cb, nil)
  end
end
