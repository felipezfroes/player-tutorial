// ==================================================
// MOVIMENTO
// ==================================================

vel = 2;

velh = 0;
velv = 0;


// ==================================================
// CONTROLES
// ==================================================

direita  = false;
esquerda = false;
cima     = false;
baixo    = false;

dash   = false;
ataque = false;

movendo = false;


// ==================================================
// DIREÇÃO
// ==================================================

// 0   = direita
// 90  = cima
// 180 = esquerda
// 270 = baixo

dir = 270;


// ==================================================
// DASH
// ==================================================

dash_dir   = -1;
dash_veloc = 6;


// ==================================================
// ATAQUE
// ==================================================

dir_ataque = 270;

// Distância da hitbox em relação ao player
distancia_hitbox = 18;

// Guarda a hitbox criada
hitbox_ataque = noone;

// Impede criar várias hitboxes
// durante o mesmo ataque
hitbox_criada = false;


// ==================================================
// ESTADOS
// ==================================================

enum PlayerEstados
{
    parado,
    andando,
    dash,
    ataque
}

estado = PlayerEstados.parado;


// ==================================================
// CONTROLES
// ==================================================

controles = function()
{
    direita =
        keyboard_check(vk_right)
        or keyboard_check(ord("D"));

    esquerda =
        keyboard_check(vk_left)
        or keyboard_check(ord("A"));

    cima =
        keyboard_check(vk_up)
        or keyboard_check(ord("W"));

    baixo =
        keyboard_check(vk_down)
        or keyboard_check(ord("S"));


    // BOTÕES DE AÇÃO

    dash =
        mouse_check_button_pressed(mb_right);

    ataque =
        mouse_check_button_pressed(mb_left);


    // Existe alguma direção válida sendo pressionada?

    movendo =
        (direita xor esquerda)
        or
        (cima xor baixo);


    // MOVIMENTO

    if (movendo)
    {
        var direcao_movimento = point_direction(
            0,
            0,
            direita - esquerda,
            baixo - cima
        );

        velh = lengthdir_x(
            vel,
            direcao_movimento
        );

        velv = lengthdir_y(
            vel,
            direcao_movimento
        );
    }
    else
    {
        velh = 0;
        velv = 0;
    }
}


// ==================================================
// INICIAR DASH
// ==================================================

iniciar_dash = function()
{
    alarm[0] = 8;

    dash_dir = point_direction(
        x,
        y,
        mouse_x,
        mouse_y
    );

    estado = PlayerEstados.dash;
}


// ==================================================
// INICIAR ATAQUE
// ==================================================

iniciar_ataque = function()
{
    // Player não anda durante o golpe
    velh = 0;
    velv = 0;


    // A direção pode ficar diagonal durante
    // o movimento.
    //
    // Aqui transformamos em uma das
    // quatro direções principais.

    dir_ataque =
        (
            floor(
                (dir + 45) / 90
            )
            * 90
        )
        mod 360;


    // ----------------------------------------------
    // ESCOLHER SPRITE DO ATAQUE
    // ----------------------------------------------

    switch (dir_ataque)
    {
        // DIREITA
        case 0:
        {
            sprite_index =
                spr_player_attack_side;

            image_xscale = 1;

            break;
        }


        // CIMA
        case 90:
        {
            sprite_index =
                spr_player_attack_up;

            image_xscale = 1;

            break;
        }


        // ESQUERDA
        case 180:
        {
            sprite_index =
                spr_player_attack_side;

            image_xscale = -1;

            break;
        }


        // BAIXO
        case 270:
        {
            sprite_index =
                spr_player_attack_down;

            image_xscale = 1;

            break;
        }
    }


    // Reinicia a animação
    image_index = 0;
    image_speed = 1;


    // Ainda não criamos a hitbox
    hitbox_criada = false;

    hitbox_ataque = noone;


    estado = PlayerEstados.ataque;
}


// ==================================================
// CRIAR HITBOX DO ATAQUE
// ==================================================

criar_hitbox_ataque = function()
{
    // Coloca a hitbox na frente do player
    // dependendo da direção do ataque

    var hitbox_x =
        x
        + lengthdir_x(
            distancia_hitbox,
            dir_ataque
        );

    var hitbox_y =
        y
        + lengthdir_y(
            distancia_hitbox,
            dir_ataque
        );


    hitbox_ataque =
        instance_create_layer(
            hitbox_x,
            hitbox_y,
            layer,
            obj_player_hitbox
        );


    // Guarda quem criou a hitbox.
    //
    // Isso será muito útil no próximo episódio
    // quando adicionarmos dano.

    hitbox_ataque.dono = id;
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

        case PlayerEstados.parado:
        {
            controles();

            muda_sprite();


            // ATAQUE TEM PRIORIDADE

            if (ataque)
            {
                iniciar_ataque();

                break;
            }


            // DASH

            if (dash)
            {
                iniciar_dash();

                break;
            }


            // COMEÇOU A ANDAR

            if (movendo)
            {
                estado =
                    PlayerEstados.andando;
            }

            break;
        }


        // ==========================================
        // ANDANDO
        // ==========================================

        case PlayerEstados.andando:
        {
            controles();

            muda_sprite();


            // ATAQUE

            if (ataque)
            {
                iniciar_ataque();

                break;
            }


            // DASH

            if (dash)
            {
                iniciar_dash();

                break;
            }


            // PAROU

            if (!movendo)
            {
                estado =
                    PlayerEstados.parado;
            }

            break;
        }


        // ==========================================
        // DASH
        // ==========================================

        case PlayerEstados.dash:
        {
            velh =
                lengthdir_x(
                    dash_veloc,
                    dash_dir
                );

            velv =
                lengthdir_y(
                    dash_veloc,
                    dash_dir
                );


            // RASTRO

            var inst =
                instance_create_layer(
                    x,
                    y,
                    "Instances",
                    obj_rastro
                );

            inst.sprite_index =
                sprite_index;

            inst.image_index =
                image_index;

            inst.image_speed = 0;

            break;
        }


        // ==========================================
        // ATAQUE
        // ==========================================

        case PlayerEstados.ataque:
        {
            // Player fica travado durante
            // a animação do ataque

            velh = 0;
            velv = 0;


            // FRAME 0 = preparação
            //
            // FRAME 1 = golpe
            //
            // Criamos a hitbox somente
            // quando a espada realmente ataca.

            if (
                image_index >= 1
                and !hitbox_criada
            )
            {
                criar_hitbox_ataque();

                hitbox_criada = true;
            }


            break;
        }
    }
}


// ==================================================
// TROCAR SPRITE
// ==================================================

muda_sprite = function()
{
    if (movendo)
    {
        var direcao_movimento =
            point_direction(
                0,
                0,
                direita - esquerda,
                baixo - cima
            );


        // Converte diagonais para
        // uma das quatro direções.

        dir =
            (
                floor(
                    (direcao_movimento + 45)
                    / 90
                )
                * 90
            )
            mod 360;
    }


    switch (dir)
    {
        // DIREITA
        case 0:
        {
            sprite_index =
                spr_player_idle_side;

            image_xscale = 1;

            break;
        }


        // CIMA
        case 90:
        {
            sprite_index =
                spr_player_idle_up;

            image_xscale = 1;

            break;
        }


        // ESQUERDA
        case 180:
        {
            sprite_index =
                spr_player_idle_side;

            image_xscale = -1;

            break;
        }


        // BAIXO
        case 270:
        {
            sprite_index =
                spr_player_idle_down;

            image_xscale = 1;

            break;
        }
    }
}