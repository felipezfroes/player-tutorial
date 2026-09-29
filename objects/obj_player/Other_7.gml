// ==================================================
// FIM DO ATAQUE
// ==================================================

if (estado == PlayerEstados.ataque)
{
    velh = 0;
    velv = 0;


    // Se a hitbox ainda existir,
    // removemos ela.

    if (instance_exists(hitbox_ataque))
    {
        instance_destroy(hitbox_ataque);
    }


    hitbox_ataque = noone;
    hitbox_criada = false;


    // Volta para o estado normal

    estado = PlayerEstados.parado;


    // Recupera o sprite de idle
    // da direção atual

    muda_sprite();
}