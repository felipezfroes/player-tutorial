vel = 2;
velh = 0;
velv = 0;

direita     = noone;
esquerda    = noone;
cima        = noone;
baixo       = noone;
dash        = noone;

movendo = false;

dir         = 270;

//DASH
dash_dir    = -1;
dash_veloc  = 6;

//ATAQUE
ataque = false;
dir_ataque = 270;
distancia_hitbox = 18;
hitbox_ataque = noone;
hitbox_criada = false;

enum PlayerEstados
{
    parado,
    andando,
    dash,
    ataque
}

estado = PlayerEstados.parado;

controles = function()
{
    direita     = keyboard_check(vk_right) or keyboard_check(ord("D"));
    esquerda    = keyboard_check(vk_left) or keyboard_check(ord("A"));
    cima        = keyboard_check(vk_up) or keyboard_check(ord("W"));
    baixo       = keyboard_check(vk_down) or keyboard_check(ord("S"));
    
    dash        = mouse_check_button_pressed(mb_right);
    ataque      = mouse_check_button_pressed(mb_left);
    
    movendo = (direita xor esquerda) or (cima xor baixo);
    
    //velh = (direita - esquerda) * vel;
    //velv = (baixo - cima) * vel;
    var dir = point_direction(0,0, direita - esquerda, baixo - cima);
    
    if (movendo)
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

iniciar_ataque = function ()
{
    velh = 0;
    velv = 0;
    
    dir_ataque = (floor((dir+45)/90) * 90) mod 360;
    
    switch (dir_ataque) {
        case 0 : sprite_index = spr_player_attack_side;
            image_xscale = 1; break;
    	case 90 : sprite_index = spr_player_attack_up;
            image_xscale = 1; break;
        case 180 : sprite_index = spr_player_attack_side;
            image_xscale = -1; break;
        case 270 : sprite_index = spr_player_attack_down;
            image_xscale = 1; break;
    }
    
    image_index = 0;
    image_speed = 1;
    
    hitbox_criada = false;
    hitbox_ataque = noone;
    
    estado = PlayerEstados.ataque;
}

criar_hitbox_ataque = function ()
{
    var hitbox_x = x + lengthdir_x(distancia_hitbox, dir_ataque);
    var hitbox_y = y + lengthdir_y(distancia_hitbox, dir_ataque);
    
    hitbox_ataque = instance_create_layer(hitbox_x, hitbox_y, layer, obj_player_hitbox);
    
    hitbox_ataque.dono = id;
}

maquina_estados = function() 
{
    switch (estado) 
    {
    	case PlayerEstados.parado: 
        {
            controles();
            muda_sprite();
            
            if (ataque)
            {
                iniciar_ataque();
                break;
            }
            
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
            
            if (ataque)
            {
                iniciar_ataque();
                break;
            }
            
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
            
        case PlayerEstados.ataque:
        {
            velh = 0;
            velv = 0;
            
            if (image_index >= 1 and !hitbox_criada)
            {
                criar_hitbox_ataque();
                hitbox_criada = true;
            }
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