alcance_deteccao = 96;

player = noone;
player_detectado = false;

distancia_player = 0;


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

        player_detectado = distancia_player <= alcance_deteccao;
    }
    else
    {
        player_detectado = false;
        distancia_player = 0;
    }
}