/// obj_shop : Draw GUI
/// Text-only trade panel, in the same style as the battle and dialogue panels: the final UI replaces this
/// file without touching scr_shop.
var _party = scr_party_ensure_global();
/// Tall enough for supplies and gear on one screen: six rows at 19px, then the description, the message
/// and the key hints. A second page would cost a key press for no reason.
var _panel_w = 460;
var _panel_h = 238;
var _left = (display_get_gui_width() - _panel_w) * 0.5;
var _top = display_get_gui_height() - _panel_h - 16;

draw_set_alpha(0.9);
draw_set_colour(c_black);
draw_rectangle(_left, _top, _left + _panel_w, _top + _panel_h, false);
draw_set_alpha(1);
draw_set_halign(fa_left);
draw_set_colour(c_white);

draw_text(_left + 12, _top + 10, "Merchant");
draw_text(_left + _panel_w - 150, _top + 10, "Gold " + string(_party.gold));

/// Stock rows, in scr_shop_stock() order
var _count = array_length(stock);
for (var _i = 0; _i < _count; _i++) {
    var _affordable = scr_shop_can_afford(_party, stock[_i]);
    if (_i == shop.cursor) draw_set_colour(c_aqua);
    else draw_set_colour(_affordable ? c_white : c_gray);
    draw_text(_left + 20, _top + 38 + _i * 19, ((_i == shop.cursor) ? "> " : "  ") + scr_shop_row(stock[_i], _party));
}
draw_set_colour(c_white);

/// The chosen ware's description, so a price is never the only thing on screen
if (_count > 0) {
    var _chosen = scr_item_data(stock[clamp(shop.cursor, 0, _count - 1)]);
    if (!is_undefined(_chosen)) draw_text(_left + 12, _top + 152, _chosen.description);
}

draw_set_colour(c_yellow);
draw_text(_left + 12, _top + 176, shop.message);
draw_set_colour(c_white);
draw_text(_left + 12, _top + _panel_h - 26, "[UP/DOWN] choose   [ENTER] buy one   [ESC] leave");
