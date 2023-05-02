vpath %.s src
vpath %.o obj
src = src/
obj = obj/
build = build/

$(build)adventure.gb:	main.o
	rgblink -o $@ $^
	rgbfix -v -p 0xFF $@

$(obj)main.o:	main.s
	rgbasm -I $(src) -L -o $@ $^

clean:
	rm $(obj)*.o 
