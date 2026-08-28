draw_self();


// CÍRCULO DE DETECÇÃO
if (player_detectado)
{
    draw_set_color(c_lime);
}
else
{
    draw_set_color(c_red);
}

draw_set_alpha(0.75);

draw_circle(
    x,
    y,
    alcance_deteccao,
    true
);

draw_set_alpha(1);


// TEXTO DE DEBUG
if (player_detectado)
{
    draw_set_halign(fa_center);
    draw_set_color(c_lime);

    draw_text(
        x,
        y - 32,
        "PLAYER DETECTADO"
    );

    draw_set_halign(fa_left);
}


// VOLTA A COR AO NORMAL
draw_set_color(c_white);