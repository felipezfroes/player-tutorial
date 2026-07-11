vel = 2;
velh = 0;
velv = 0;

direita     = noone;
esquerda    = noone;
cima        = noone;
baixo       = noone;
dash        = noone;

dir         = 0;

//DASH
dash_dir    = -1;
dash_veloc  = 6;

enum PlayerEstados
{
    parado,
    andando,
    dash
}

estado = PlayerEstados.parado;

controles = function()
{
    direita     = keyboard_check(vk_right) or keyboard_check(ord("D"));
    esquerda    = keyboard_check(vk_left) or keyboard_check(ord("A"));
    cima        = keyboard_check(vk_up) or keyboard_check(ord("W"));
    baixo       = keyboard_check(vk_down) or keyboard_check(ord("S"));
    
    dash        = mouse_check_button_pressed(mb_right);
    
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
    
    if (dash)
    {
        alarm[0] = 8;
        dash_dir = point_direction(x,y, mouse_x, mouse_y);
        estado = PlayerEstados.dash;
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
            
        case PlayerEstados.dash:
        {
            velh = lengthdir_x(dash_veloc, dash_dir);
            velv = lengthdir_y(dash_veloc, dash_dir);
            
            var inst = instance_create_layer(x,y, "Instances", obj_rastro);
            inst.sprite_index = sprite_index;
            inst.image_index = image_index;
            inst.image_speed = 0;
            
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