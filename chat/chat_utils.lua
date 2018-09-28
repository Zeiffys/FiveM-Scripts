function string.split(s)
	local t = {}
	local i = 1
	for v in s:gmatch("([^%s]+)") do
		t[i] = v
		i = i + 1
	end
	return t
end

function escape(s)
	s = s:gsub("%^([0-9/*_~=rbgypqocmwsu])", "")
	s = s:gsub("%^#([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])([0-9a-f][0-9a-f])", "")
	s = s:gsub("%s+", " ")
	return s
end