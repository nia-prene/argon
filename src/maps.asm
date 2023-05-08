INCLUDE "hardware.inc"

SECTION "Map Lookup", ROM0
Maps_l::
	db LOW(Map00)
Maps_h::
	db HIGH(Map00)
Maps_bank::
	db BANK(Map00)

	
SECTION "Maps", ROMX

Map00::
	INCBIN "map.bin"


