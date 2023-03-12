local socket = require("socket");
local host = "stun.l.google.com";
local port = 19302;

local servers = {
	{"stun.l.google.com", 19302},
}


host = socket.dns.toip(host)
local udp = socket.udp()

local data = string.char(0x00 , 0x01 , 0x00 , 0x00 , 0x21 , 0x12 , 0x00, 0x30   , 0xa4 , 0x42 , 0x31 , 0x4a , 0x73 , 0x77 , 0x7a , 0x33 , 0x55 , 0x39 , 0x33 , 0x71);

print("Using host '" ..host.. "' and port " ..port.. "...")
print("Printed data");

--Ask the stun server
udp:settimeout(3)
sent, err = udp:sendto(data, host, port);
if err then print(err) os.exit() end

--Get from server
dgram, err = udp:receive()
if not dgram then print(err, "Second") os.exit() end

--Interpret data
local function hexToDec(nStr)
	return tonumber(nStr, 16);
end
local function decToHex(n)
	string.format("%x", input * 255)
end


local binaryData = string.byte(dgram, 1, dgram:len());

print(string.byte(dgram, 1, dgram:len()));



io.read();

udp:close();