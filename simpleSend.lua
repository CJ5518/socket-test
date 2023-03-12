local socket = require("socket");

if not arg[1] and not arg[2] then
	print("Usage: lua simpleSend.lua 1.2.3.4 <port>");
end
local host = arg[1];
local port = tonumber(arg[2]);
print(host, port);
local udp = socket.udp()

print("Using host '" .. host .. "' and port " .. port .. "...")

--Ask the stun server
udp:settimeout(3)
for q = 1, 3 do
sent, err = udp:sendto("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", host, port); end
if err then print(err) os.exit() end

udp:close();
