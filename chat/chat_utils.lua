function string.split(s)
	local t = {}
	local i = 1
	for v in string.gmatch(s, "([^%s]+)") do
		t[i] = v
		i = i + 1
	end
	return t
end

function escape(s)
	return s:gsub("%^([0-9*_~=r])", "")
end