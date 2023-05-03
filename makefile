vpath %.s src
vpath %.o obj
vpath %.gb build

src = src/
obj = obj/
build = build/
bgb = bgb/

$(build)adventure.gb:	main.o
	rgblink -o $@ $^
	rgbfix -v -p 0xFF $@

$(obj)main.o:	main.s
	rgbasm -I $(src) -L -o $@ $^

test:	adventure.gb
	wine $(bgb)bgb64.exe $<
clean:
	rm $(obj)*.o 
