// ==================================================
// MOVIMENTO
// ==================================================

velh = 0;
velv = 0;

vel_vagar = 0.5;


// ==================================================
// ÁREA DA SLIME
// ==================================================

// Posição onde a slime começou
origem_x = x;
origem_y = y;

// Até onde ela pode passear quando estiver tranquila
raio_vagar = 48;

destino_x = x;
destino_y = y;


// ==================================================
// DETECÇÃO DO PLAYER
// ==================================================

alcance_deteccao = 96;

player = noone;
player_detectado = false;

distancia_player = 0;


// ==================================================
// SALTO
// ==================================================

// Onde a slime acredita que o player estará
alvo_x = x;
alvo_y = y;

// Posição onde o salto começou
salto_inicio_x = x;
salto_inicio_y = y;

// Movimento horizontal do salto
salto_velh = 0;
salto_velv = 0;

// Quantos frames à frente tentamos prever o player
previsao_player = 10;

// Impede saltos absurdamente longos
alcance_salto = 120;


// ==================================================
// TEMPOS
// ==================================================

// Aproximadamente 0,4 s em 60 FPS
tempo_preparando = 24;

// Salto mais longo e pesado de sub-chefe
tempo_saltando = 30;

// Tempo vulnerável depois de aterrissar
tempo_recuperando = 36;

// Tempo parado entre caminhadas
tempo_parado_min = 30;
tempo_parado_max = 75;

timer_estado = irandom_range(
    tempo_parado_min,
    tempo_parado_max
);


// ==================================================
// DEBUG
// ==================================================

debug_ia = true;


// ==================================================
// ESTADOS
// ==================================================

enum InimigoEstados
{
    parado,
    vagando,
    preparando,
    saltando,
    recuperando
}

estado = InimigoEstados.parado;


// ==================================================
// DETECTAR PLAYER
// ==================================================

detectar_player = function()
{
    // Procura o player caso ainda não exista
    // uma referência válida
    if (!instance_exists(player))
    {
        player = instance_find(obj_player, 0);
    }

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


// ==================================================
// ESCOLHER DESTINO PARA VAGAR
// ==================================================

escolher_destino = function()
{
    var direcao = irandom(359);

    var distancia = random_range(
        16,
        raio_vagar
    );

    // O ponto sempre é escolhido ao redor
    // da posição ORIGINAL da slime
    destino_x =
        origem_x
        + lengthdir_x(distancia, direcao);

    destino_y =
        origem_y
        + lengthdir_y(distancia, direcao);
}


// ==================================================
// PREPARAR SALTO
// ==================================================

preparar_salto = function()
{
    // Guarda onde o salto começou
    salto_inicio_x = x;
    salto_inicio_y = y;


    // ----------------------------------------------
    // PREVISÃO DO PLAYER
    // ----------------------------------------------

    // Não miramos somente onde o player está.
    // Tentamos prever onde ele estará daqui
    // alguns frames.

    alvo_x =
        player.x
        + player.velh * previsao_player;

    alvo_y =
        player.y
        + player.velv * previsao_player;


    // ----------------------------------------------
    // LIMITAR DISTÂNCIA DO SALTO
    // ----------------------------------------------

    var distancia_alvo = point_distance(
        x,
        y,
        alvo_x,
        alvo_y
    );

    if (distancia_alvo > alcance_salto)
    {
        var direcao_alvo = point_direction(
            x,
            y,
            alvo_x,
            alvo_y
        );

        alvo_x =
            x
            + lengthdir_x(
                alcance_salto,
                direcao_alvo
            );

        alvo_y =
            y
            + lengthdir_y(
                alcance_salto,
                direcao_alvo
            );
    }


    // ----------------------------------------------
    // CALCULAR MOVIMENTO DO SALTO
    // ----------------------------------------------

    // Queremos chegar no alvo exatamente ao final
    // de tempo_saltando frames.
    
    salto_velh =
        (alvo_x - x)
        / tempo_saltando;

    salto_velv =
        (alvo_y - y)
        / tempo_saltando;


    // Faz a slime olhar para o lado correto
    if (salto_velh != 0)
    {
        image_xscale = sign(salto_velh);
    }


    timer_estado = tempo_preparando;

    estado = InimigoEstados.preparando;
}


// ==================================================
// MÁQUINA DE ESTADOS
// ==================================================

maquina_estados = function()
{
    switch (estado)
    {
        // ==========================================
        // PARADO
        // ==========================================

        case InimigoEstados.parado:
        {
            velh = 0;
            velv = 0;


            // Player apareceu?
            if (player_detectado)
            {
                preparar_salto();

                break;
            }


            // Caso contrário, apenas esperamos
            timer_estado--;


            // Depois de um tempo,
            // escolhemos algum lugar para andar
            if (timer_estado <= 0)
            {
                escolher_destino();

                estado = InimigoEstados.vagando;
            }

            break;
        }


        // ==========================================
        // VAGANDO
        // ==========================================

        case InimigoEstados.vagando:
        {
            // O player interrompe imediatamente
            // o passeio da slime
            if (player_detectado)
            {
                velh = 0;
                velv = 0;

                preparar_salto();

                break;
            }


            var distancia_destino = point_distance(
                x,
                y,
                destino_x,
                destino_y
            );


            // Chegamos ao destino
            if (distancia_destino <= 2)
            {
                velh = 0;
                velv = 0;

                timer_estado = irandom_range(
                    tempo_parado_min,
                    tempo_parado_max
                );

                estado = InimigoEstados.parado;

                break;
            }


            // Continuamos andando
            var direcao_destino = point_direction(
                x,
                y,
                destino_x,
                destino_y
            );

            velh = lengthdir_x(
                vel_vagar,
                direcao_destino
            );

            velv = lengthdir_y(
                vel_vagar,
                direcao_destino
            );


            // Olha para onde está andando
            if (velh != 0)
            {
                image_xscale = sign(velh);
            }

            break;
        }


        // ==========================================
        // PREPARANDO
        // ==========================================

        case InimigoEstados.preparando:
        {
            velh = 0;
            velv = 0;

            timer_estado--;


            if (timer_estado <= 0)
            {
                timer_estado = tempo_saltando;

                estado = InimigoEstados.saltando;
            }

            break;
        }


        // ==========================================
        // SALTANDO
        // ==========================================

        case InimigoEstados.saltando:
        {
            // Aqui NÃO recalculamos a posição
            // do jogador.
            //
            // A slime está comprometida com
            // a decisão feita anteriormente.

            velh = salto_velh;
            velv = salto_velv;

            timer_estado--;


            if (timer_estado <= 0)
            {
                velh = 0;
                velv = 0;

                timer_estado = tempo_recuperando;

                estado = InimigoEstados.recuperando;
            }

            break;
        }


        // ==========================================
        // RECUPERANDO
        // ==========================================

        case InimigoEstados.recuperando:
        {
            velh = 0;
            velv = 0;

            timer_estado--;


            if (timer_estado <= 0)
            {
                timer_estado = irandom_range(
                    tempo_parado_min,
                    tempo_parado_max
                );

                estado = InimigoEstados.parado;
            }

            break;
        }
    }
}