return function()
	local handle = io.popen("read -sn1 -t 1 a; echo $a")
	local key = handle:read()
	handle:close()
	return key
end
