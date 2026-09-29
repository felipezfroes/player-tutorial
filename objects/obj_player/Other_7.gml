if (estado == PlayerEstados.ataque)
{
    velh = 0;
    velv = 0;
    
    if (instance_exists(hitbox_ataque))
    {
        instance_destroy(hitbox_ataque);
    }
    
    hitbox_ataque = noone;
    hitbox_criada = false;
    
    estado = PlayerEstados.parado;
    muda_sprite();
}