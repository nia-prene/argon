INCLUDE "hardware.inc"

SECTION "Camera", ROM0

Camera_open_shutter::
	; Copy the tilemap
	
	
	ld a, 0;		this is the map

	ld bc, Maps_l
	add a, c;		
	ld c, a
	ld a, d
	adc a, 0
	ld b, a
	ld a, [bc]
	ld e, a
	
	ld a, 0;		this is the map

	ld bc, Maps_h
	add a, c
	ld c, a
	ld a, b
	adc a, 0
	ld b, a
	ld a, [bc]
	ld d, a

	
	ld hl, $9800;		point at tilemap vram
	ld bc, 1024;		get size of full tilemap
.loop:
	ld a, [de];		get a tile
	ld [hl+], a;		put it in vram
	inc de;			point at next byte of map
	dec bc;			count down tilemap size			
	ld a, c
	and %11111;		if finished with a row
	jp nz, :+
		ld a,e;			move to the next row
		add a, 32;		TODO make this map width
		ld e,a
		ld a,d
		adc 0;			TODO make this map width
		ld d,a
:
	ld a, b;		while tiles remain
	or a, c
	jp nz, .loop

	ld a, LCDCF_ON | LCDCF_BGON;	turn  LCD on
	ld [rLCDC], a
	ret

