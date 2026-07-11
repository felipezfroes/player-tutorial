vel = 2;
velh = 0;
velv = 0;

direita     = noone;
esquerda    = noone;
cima        = noone;
baixo       = noone;

dir         = 0;

enum PlayerEstados
{
    parado,
    andando
}

estado = PlayerEstados.parado;

controles = function()
{
    direita     = keyboard_check(vk_right) or keyboard_check(ord("D"));
    esquerda    = keyboard_check(vk_left) or keyboard_check(ord("A"));
    cima        = keyboard_check(vk_up) or keyboard_check(ord("W"));
    baixo       = keyboard_check(vk_down) or keyboard_check(ord("S"));
    
    //velh = (direita - esquerda) * vel;
    //velv = (baixo - cima) * vel;
    var dir = point_direction(0,0, direita - esquerda, baixo - cima);
    
    if (direita xor esquerda or baixo xor cima)
    {
        velh = lengthdir_x(vel, dir);
        velv = lengthdir_y(vel, dir);
    }
    else {
        velh = 0;
        velv = 0;
    }
}

maquina_estados = function() 
{
    switch (estado) 
    {
    	case PlayerEstados.parado: 
        {
            controles();
            muda_sprite();
            if (direita xor esquerda or cima xor baixo)
            {
                estado = PlayerEstados.andando;
            }
            break;
        }
            
        case PlayerEstados.andando: 
        {
            controles();
            muda_sprite();
            if (velh == 0 and velv == 0)
            {
                estado = PlayerEstados.parado
            }
            
            break;
        }    
    }
}

muda_sprite = function()
{
    if (direita xor esquerda or cima xor baixo)
    {
        dir = point_direction(0,0, direita - esquerda, baixo - cima);   
    }
    
    switch (dir) 
    {
    	case 0: 
            sprite_index = spr_player_idle_side;
            image_xscale = 1;
            break;
        case 90: 
            sprite_index = spr_player_idle_up;
            image_xscale = 1;
            break;
        case 180: 
            sprite_index = spr_player_idle_side;
            image_xscale = -1;
            break;
        case 270: 
            sprite_index = spr_player_idle_down;
            image_xscale = 1;
            break;    
    }
}