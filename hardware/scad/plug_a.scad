// Пробка A — динамик + вход газа.
// Динамик Ø20 стоит в канале трубки перед пробкой, приклеен задней стороной к трём бобышкам
// (клеить, вставив пробку в тест-кольцо как кондуктор — динамик ничем не центрируется).
// Газ: ёлочка на лаге → радиальный канал → осевой канал → задняя камера → зазор за динамиком →
// по ободу динамика → в трубку. Провода динамика — через осевое отверстие, залить эпоксидкой.
// Система координат: z=0 — внутренний торец (в трубу), фланец и лаг — сверху (z 15..25).
// Печатать перевёрнутой: фланцем на стол, внутренним торцом вверх (камера и бобышки открыты вверх).
include <params.scad>
use <lib.scad>

module plug_a(fit = plug_fit) {
    d      = bore_d - fit;
    lug_y0 = -(flange_d / 2 + lug_len_a);      // плоскость лага, из которой торчит ёлочка
    zc     = plug_depth + flange_t / 2;        // ось радиального канала — середина фланца

    difference() {
        union() {
            plug_body(d, lug_w_a, lug_len_a);
            barb_neg_y(lug_y0, zc);
            for (a = [90, 210, 330])
                rotate([0, 0, a]) translate([spk_boss_r, 0, -spk_boss_h])
                    cylinder(d = spk_boss_d, h = spk_boss_h + 0.01);
        }
        // задняя камера
        translate([0, 0, -1]) cylinder(d = rear_cav_d, h = rear_cav_h + 1);
        // осевой канал из камеры до уровня радиального
        translate([0, chan_y_a, rear_cav_h - 2]) cylinder(d = chan_d, h = zc - rear_cav_h + 2 + chan_d / 2);
        // радиальный канал до ёлочки (сквозь лаг и её бор)
        cyl_neg_y([0, chan_y_a, zc], barb_id, -lug_y0 + chan_y_a + barb_len + 2);
        // отверстие под провода: из камеры наружу через фланец
        translate([0, wire_y_a, rear_cav_h - 2]) cylinder(d = spk_wire_d, h = plug_depth + flange_t - rear_cav_h + 3);
    }
}

plug_a();
