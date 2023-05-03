INCLUDE "hardware.inc"

SECTION "Header", ROM0[$100]

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a

	; Do not turn the LCD off outside of VBlank
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

	; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	; Copy the tile data
	ld de, Tiles
	ld hl, $9000
	ld bc, TilesEnd - Tiles
CopyTiles:
	ld a, [de]
	ld [hli], a
	inc de
	dec bc
	ld a, b
	or a, c
	jp nz, CopyTiles

	; Copy the tilemap
	ld de, Tilemap
	ld hl, $9800
	ld bc, 1024
CopyTilemap:
	ld a, [de];		get a tile
	ld [hl+], a;		put it in vram
	inc de
	dec bc
	ld a, c
	and %11111
	jp nz, :+
		ld a,e
		add a, 32
		ld e,a
		ld a,d
		adc 0
		ld d,a
:
	ld a, b
	or a, c
	jp nz, CopyTilemap

	; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

	; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

Done:
	jp Done


SECTION "Tile data", ROM0


Tiles:
	INCBIN "tiles.bin"
TilesEnd:

SECTION "Tilemap", ROM0

Tilemap:
	INCBIN "map.bin"
TilemapEnd:
