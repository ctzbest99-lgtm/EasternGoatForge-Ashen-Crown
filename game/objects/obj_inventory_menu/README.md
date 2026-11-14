# obj_inventory_menu

Field menu (I or Tab). Tabs: Items, Equip, Key (Q/E, or left/right on Items/Key). Close with I, Tab, X, or Backspace.

- Items: consumables and unequipped gear. Z on a potion opens the target picker; Z on gear jumps to the Equip tab.
- Key: key items with the key icon; they cannot be used or sold.
- Equip: left/right changes member, up/down picks a slot (Weapon, Armor, Helm, Accessory), Z lists candidates. Helm and Accessory stay empty until such items exist (Iron Helm uses the Helm slot).

Layout constants and sprite fallbacks live in `scr_menu_layout.gml`. Dedicated art is in `game/sprites/ui/menus/`.
