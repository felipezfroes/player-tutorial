// ==================================================
// SOMBRA
// ==================================================

draw_sprite(
    spr_player_shadow,
    0,
    x,
    y + 4
);


// ==================================================
// PLAYER
// ==================================================

var desenhar_player = true;


// Enquanto estiver no feedback de dano,
// alternamos entre desenhar e esconder.

if (timer_piscando > 0)
{
    desenhar_player =
        (
            floor(
                timer_piscando / 3
            )
            mod 2
        )
        == 0;
}


if (desenhar_player)
{
    draw_self();
}