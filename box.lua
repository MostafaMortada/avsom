h = "0123456789ABCDEF"
io.write("       ")
for i = 1, 16 do
	io.write(h:sub(i, i), " ")
end
j = 9472
for i = 0, 9 do
	io.write("\nU+25", i, "x ")
	for o = 0, 15 do
		io.write(utf8.char(j + 16*i + o), " ")
	end
end
io.write("\n")
