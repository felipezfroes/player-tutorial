// ==================================================
// IA
// ==================================================

detectar_player();

maquina_estados();


// ==================================================
// MOVIMENTO + KNOCKBACK
// ==================================================

move_and_collide(
    velh + knockback_h,
    velv + knockback_v,
    obj_colisor
);


// ==================================================
// DANO NO PLAYER
// ==================================================

if (
    estado == InimigoEstados.saltando
    and
    !player_atingido_salto
)
{
    if (instance_exists(player))
    {
        if (
            place_meeting(
                x,
                y,
                player
            )
        )
        {
            player.receber_dano(
                dano_salto
            );

            player_atingido_salto =
                true;
        }
    }
}


// ==================================================
// HIT FLASH
// ==================================================

if (timer_hit_flash > 0)
{
    timer_hit_flash--;
}


// ==================================================
// REDUZIR KNOCKBACK
// ==================================================

knockback_h =
    lerp(
        knockback_h,
        0,
        knockback_friccao
    );

knockback_v =
    lerp(
        knockback_v,
        0,
        knockback_friccao
    );


// Evita valores minúsculos infinitos

if (abs(knockback_h) < 0.05)
{
    knockback_h = 0;
}

if (abs(knockback_v) < 0.05)
{
    knockback_v = 0;
}