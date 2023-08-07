INCLUDE "hardware.inc"
SECTION "Camera RAM", WRAM0

Camera_xPos:
	ds 3
Camera_yPos:
	ds 3

SECTION "Camera", ROM0

Camera_open_shutter::
	ld hl, Camera_xPos;	set camera to $01 00 00, $01 00 00
	ld a, $01
	ld [hl+],a
	ld a, $00
	ld [hl+],a
	ld [hl],a
	
	ld hl, Camera_yPos
	ld a, $01
	ld [hl+],a
	ld a, $00
	ld [hl+],a
	ld [hl],a

	
	ld hl,$0000;		get map pointer
	push hl

	ld bc, Maps_l
	add hl, bc
	ld e, [hl]
	
	pop hl

	ld bc, Maps_h
	add hl, bc
	ld d, [hl];		de is map pointer

	
	ld hl,Camera_xPos+1
	ld a,[hl-]
	sub a,128
	ld c,a
	ld a,[hl]
	sbc a,0
	ld b,a
	

	ld c,[hl]
	
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

