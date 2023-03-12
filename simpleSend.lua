local socket = require("socket");

if not arg[1] and not arg[2] then
	print("Usage: lua simpleSend.lua 1.2.3.4 <port>");
end
local host = arg[1];
local port = tonumber(arg[2]);

host = socket.dns.toip(host)
local udp = socket.udp()

print("Using host '" ..host.. "' and port " ..port.. "...")

--Ask the stun server
udp:settimeout(3)
sent, err = udp:sendto("Hello, world!", host, port);
if err then print(err) os.exit() end

udp:close();