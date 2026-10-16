// ==================================================
// PROCURAR INIMIGO
// ==================================================

if (!ja_acertou)
{
    var alvo =
        instance_place(
            x,
            y,
            obj_inimigo
        );


    if (alvo != noone)
    {
        // ------------------------------------------
        // ORIGEM DO GOLPE
        // ------------------------------------------

        var origem_x = x;
        var origem_y = y;


        if (instance_exists(dono))
        {
            origem_x = dono.x;
            origem_y = dono.y;
        }


        // ------------------------------------------
        // CAUSAR DANO
        // ------------------------------------------

        alvo.receber_dano(
            dano,
            origem_x,
            origem_y,
            forca_knockback
        );


        // Impede dano repetido durante
        // os vários frames da hitbox.

        ja_acertou = true;
    }
}


// ==================================================
// DESTRUIR HITBOX
// ==================================================

tempo--;


if (tempo <= 0)
{
    instance_destroy();
}