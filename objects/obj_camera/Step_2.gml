var camX = camera_get_view_x(camera);
var camY = camera_get_view_y(camera);

var alvoX = obj_player.x - RES_L/2;
var alvoY = obj_player.y - RES_A/2;

alvoX = clamp(alvoX, 0, room_width - RES_L);
alvoY = clamp(alvoY, 0, room_height - RES_A);

camX = lerp(camX, alvoX, CAM_SUAVE);
camY = lerp(camY, alvoY, CAM_SUAVE);

camera_set_view_pos(camera, camX, camY);