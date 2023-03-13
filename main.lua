local socket = require("socket");

local udp = socket.udp()

udp:settimeout(1)

local function askStun(sock)
	local host = "stun.l.google.com";
	local port = 19302;

	host = socket.dns.toip(host)
	local data = string.char(0x00 , 0x01 , 0x00 , 0x00 , 0x21 , 0x12 , 0x00, 0x30   , 0xa4 , 0x42 , 0x31 , 0x4a , 0x73 , 0x77 , 0x7a , 0x33 , 0x55 , 0x39 , 0x33 , 0x71);
	
	--Ask the stun server
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
	
	local ourIp = tostring(binaryData[#binaryData-3]) .. "." ..
		tostring(binaryData[#binaryData-2]) .. "." ..
		tostring(binaryData[#binaryData-1]) .. "." ..
		tostring(binaryData[#binaryData]);

	return ourIp, ourPort;
end

local ourIp, ourPort = askStun(udp);
local theirIp, theirPort;
print("we think we at", udp:getsockname())
print("We are at", ourIp, ourPort);

while true do
	dgram, err = udp:receive()
	if not dgram then
		print(err, " on receive")
		local newIp, newPort = askStun(udp);
		if newIp == ourIp and newPort == ourPort then
			--print("IP and Port are the same");
		else
			print("We NEWLY at", ourIp, ourPort);
			os.exit();
		end

		if theirIp then
			for q = 1, 5 do
				udp:sendto("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA", theirIp, theirPort);
			end
			print("Sent to " .. theirIp .. ":" .. theirPort .. " from " .. ourIp .. ":" .. ourPort);
		end

		--While we are here, let's check if we have a peer to find
		if not theirIp then
			local file = io.open("peer.txt", "r");
			if file then
				print("GOT FILE:");
				local text = file:read("*all");
				local ip1, ip2, ip3, ip4, portnoy = text:match("(%d+)%.(%d+)%.(%d+)%.(%d+)%:(%d+)");
				theirPort = tonumber(portnoy);
				theirIp = string.format("%s.%s.%s.%s", ip1, ip2, ip3, ip4);
				print(string.format("_%s_ : %d", theirIp, theirPort));
				file:close();
			end
		end
	else
		print(dgram);
	end
end

udp:close();