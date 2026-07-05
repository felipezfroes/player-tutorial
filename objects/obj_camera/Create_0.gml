#macro RES_L 320
#macro RES_A 180
#macro RES_SCALE 4 

#macro CAM_SUAVE 0.1

view_enabled = true;
view_visible[0] = true;

//criar a camera
camera = camera_create_view(0, 0, RES_L, RES_A);

view_set_camera(0,camera);

//redimensionar a janela e aplicar
window_set_size(RES_L * RES_SCALE, RES_A * RES_SCALE);
surface_resize(application_surface, RES_L * RES_SCALE, RES_A * RES_SCALE);

display_set_gui_size(RES_L, RES_A);

//CENTRALIZAR A JANELA
var display_largura = display_get_width();
var display_altura = display_get_height();

var window_largura = RES_L * RES_SCALE;
var window_altura = RES_A * RES_SCALE;

window_set_position(display_largura/2 - window_largura/2, display_altura/2 - window_altura/2);