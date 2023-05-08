vpath %.asm src
vpath %.o obj
vpath %.gb build

src = src/
obj = obj/
build = build/
bgb = bgb/

$(build)adventure.gb:	camera.o main.o maps.o tiles.o
	rgblink -o $@ --sym $(build)adventure.sym $^ 
	rgbfix -v -p 0xFF $@

$(obj)main.o:	main.asm
	rgbasm -h -I $(src) -L -o $@ $^

$(obj)tiles.o:	tiles.asm
	rgbasm -h -I $(src) -L -o $@ $^

$(obj)maps.o:	maps.asm
	rgbasm -h -I $(src) -L -o $@ $^

$(obj)camera.o:	camera.asm
	rgbasm -h -I $(src) -L -o $@ $^

test:	adventure.gb
	wine $(bgb)bgb64.exe $< -watch 
clean:
	rm $(obj)*.o 
