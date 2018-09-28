description "Improved Old Chat"

ui_page "html/index.html"

shared_script "chat_utils.lua"
client_script "chat_emoji.lua"
client_script "chat_client.lua"
server_script "chat_server.lua"

files {
	"html/index.html",
	"html/style.css",
	"html/chat.js",
}
