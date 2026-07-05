vel = 2;
velh = 0;
velv = 0;

direita     = noone;
esquerda    = noone;
cima        = noone;
baixo       = noone;

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