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
udp:settimeout(5)
sent, err = udp:sendto(data, host, port);
if err then print(err) os.exit() end

--Get from server
dgram, err = udp:receive()
if not dgram then print(err, " on receive") os.exit() end

--Interpret data
local function hexToDec(nStr)
	return tonumber(nStr, 16);
end
local function decToHex(n)
	return string.format("%x", tonumber(n));
end


local binaryData = {string.byte(dgram, 1, dgram:len())};

local portHex = decToHex(binaryData[#binaryData-5]) .. decToHex(binaryData[#binaryData-4]);
local ourPort = hexToDec(portHex);

print(ourPort);

local ourIp = tostring(binaryData[#binaryData-3]) .. "." ..
	tostring(binaryData[#binaryData-2]) .. "." ..
	tostring(binaryData[#binaryData-1]) .. "." ..
	tostring(binaryData[#binaryData])
print(ourIp);


print(arg[1]);

while true do
	dgram, err = udp:receive()
	if not dgram then
		print(err, " on receive")
	else
		print(dgram);
	end
end

udp:close();