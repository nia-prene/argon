INCLUDE "hardware.inc"

SECTION "Vblank", ROM0[$40]
	jp VBlank

SECTION "Header", ROM0[$100]

	jp EntryPoint
	ds $150 - @, 0 ; Make room for the header


SECTION "Main", ROM0
EntryPoint:
	ei;			enable interrupts
	ld a, IEF_VBLANK;	turn on VBLANK interrupts
	ld [rIE], a

	ld a, 0; 		Shut down audio circuitry
	ld [rNR52], a

WaitVBlank:
	ld a, [rLY]; 		Do not turn the LCD off outside of VBlank
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data

	ld de, Tiles;		get the tile pointer
	ld hl, $9000;		aim it at tile vram
	ld bc, TilesEnd - Tiles;get the size of character data
CopyTiles:
	ld a, [de];		get byte of character data
	ld [hl+], a;		move to vram and increase byte
	inc de;			move to next byte of tile data
	dec bc;			count down bytes to write
	ld a, h
	cp $98;			if vram overflow
	jp c, :+
		ld h, $88;		write to tilespace -128
:
	ld a, b;		see if any bytes left to write
	or a, c
	jp nz, CopyTiles;	continute loop if bytes
	
	call Camera_open_shutter

	ld a, LCDCF_ON | LCDCF_BGON;	turn  LCD on
	ld [rLCDC], a

	
	ld a, %11100100;	write palette
	ld [rBGP], a

Done:
	halt
	jp Done





VBlank:
	reti
