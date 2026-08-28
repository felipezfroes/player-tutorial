// MOVIMENTO
vel = 1;

velh = 0;
velv = 0;


// DETECÇÃO
alcance_deteccao = 96;

player = noone;
player_detectado = false;

distancia_player = 0;


// ESTADOS
enum InimigoEstados
{
    parado,
    seguindo
}

estado = InimigoEstados.parado;


// DETECTAR PLAYER
detectar_player = function()
{
    // Procura o player caso ainda não tenha uma referência
    if (!instance_exists(player))
    {
        player = instance_find(obj_player, 0);
    }

    // Só calcula a distância se o player existir
    if (instance_exists(player))
    {
        distancia_player = point_distance(
            x,
            y,
            player.x,
            player.y
        );

        player_detectado =
            distancia_player <= alcance_deteccao;
    }
    else
    {
        player_detectado = false;
        distancia_player = 0;
    }
}


// MÁQUINA DE ESTADOS
maquina_estados = function()
{
    switch (estado)
    {
        case InimigoEstados.parado:
        {
            velh = 0;
            velv = 0;

            if (player_detectado)
            {
                estado = InimigoEstados.seguindo;
            }

            break;
        }


        case InimigoEstados.seguindo:
        {
            if (!player_detectado)
            {
                velh = 0;
                velv = 0;
        
                estado = InimigoEstados.parado;
        
                break;
            }
        
        
            var dir_player = point_direction(
                x,
                y,
                player.x,
                player.y
            );
        
            velh = lengthdir_x(vel, dir_player);
            velv = lengthdir_y(vel, dir_player);
        
        
            if (velh != 0)
            {
                image_xscale = sign(velh);
            }
        
            break;
        }
    }
}