// ==================================================
// ALTURA VISUAL DA SLIME
// ==================================================

var altura = 0;

var escala_x_visual = 1;
var escala_y_visual = 1;


// ==================================================
// PREPARAÇÃO
// ==================================================

if (estado == InimigoEstados.preparando)
{
    // Fica mais achatada antes de saltar
    escala_x_visual = 1.20;
    escala_y_visual = 0.80;
}


// ==================================================
// SALTO
// ==================================================

if (estado == InimigoEstados.saltando)
{
    // Vai de 0 até 1 durante todo o salto
    var progresso =
        1
        - (timer_estado / tempo_saltando);

    // Cria um arco:
    //
    // começa em 0
    // sobe
    // chega ao máximo no meio
    // volta para 0
    
    altura =
        sin(progresso * pi)
        * 14;

    escala_x_visual = 0.90;
    escala_y_visual = 1.10;
}


// ==================================================
// RECUPERAÇÃO
// ==================================================

if (estado == InimigoEstados.recuperando)
{
    // Impacto da aterrissagem
    escala_x_visual = 1.15;
    escala_y_visual = 0.85;
}


// ==================================================
// SOMBRA
// ==================================================

draw_sprite(
    spr_inimigo_shadow,
    0,
    x,
    y
);


// ==================================================
// SLIME
// ==================================================

draw_sprite_ext(
    sprite_index,
    image_index,

    x,
    y - altura,

    image_xscale * escala_x_visual,
    escala_y_visual,

    image_angle,
    image_blend,
    image_alpha
);


// ==================================================
// DEBUG
// ==================================================

if (debug_ia)
{
    // ----------------------------------------------
    // RAIO DE DETECÇÃO
    // ----------------------------------------------

    if (player_detectado)
    {
        draw_set_color(c_lime);
    }
    else
    {
        draw_set_color(c_red);
    }

    draw_set_alpha(0.65);

    draw_circle(
        x,
        y,
        alcance_deteccao,
        true
    );

    draw_set_alpha(1);


    // ----------------------------------------------
    // DESTINO DO PASSEIO
    // ----------------------------------------------

    if (estado == InimigoEstados.vagando)
    {
        draw_set_color(c_aqua);

        draw_line(
            x,
            y,
            destino_x,
            destino_y
        );

        draw_circle(
            destino_x,
            destino_y,
            3,
            false
        );
    }


    // ----------------------------------------------
    // ALVO DO SALTO
    // ----------------------------------------------

    if (
        estado == InimigoEstados.preparando
        or
        estado == InimigoEstados.saltando
    )
    {
        draw_set_color(c_yellow);

        draw_line(
            x,
            y,
            alvo_x,
            alvo_y
        );

        draw_circle(
            alvo_x,
            alvo_y,
            4,
            false
        );

        draw_line(
            alvo_x - 4,
            alvo_y,
            alvo_x + 4,
            alvo_y
        );

        draw_line(
            alvo_x,
            alvo_y - 4,
            alvo_x,
            alvo_y + 4
        );
    }


    // ----------------------------------------------
    // ESTADO ATUAL
    // ----------------------------------------------

    var texto_estado = "";

    switch (estado)
    {
        case InimigoEstados.parado:
            texto_estado = "PARADO";
        break;

        case InimigoEstados.vagando:
            texto_estado = "VAGANDO";
        break;

        case InimigoEstados.preparando:
            texto_estado = "PREPARANDO";
        break;

        case InimigoEstados.saltando:
            texto_estado = "SALTANDO";
        break;

        case InimigoEstados.recuperando:
            texto_estado = "RECUPERANDO";
        break;
    }


    draw_set_halign(fa_center);
    draw_set_color(c_white);

    draw_text(
        x,
        y - altura - 28,
        texto_estado
    );

    draw_set_halign(fa_left);
    draw_set_color(c_white);
}