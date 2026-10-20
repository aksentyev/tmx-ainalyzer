// Общие модули. Подключать через use <lib.scad>; параметры берутся из params.scad.
include <params.scad>

// Ёлочка под силиконовый шланг 4×6, вдоль +Z, основание в z=0, кончик в z=len.
module barb(od = barb_od, id = barb_id, len = barb_len) {
    difference() {
        union() {
            cylinder(d = od - 1.2, h = len);
            for (i = [0 : 2])
                translate([0, 0, 1.5 + i * 2.8]) cylinder(d1 = od, d2 = od - 1.6, h = 2.2);
        }
        translate([0, 0, -1]) cylinder(d = id, h = len + 2);
    }
}

// Канавка под O-ring на цилиндре Ø d, центр на высоте z (вычитать).
module oring_groove(d, z, w = oring_groove_w, depth = oring_groove_depth) {
    translate([0, 0, z - w / 2])
        difference() {
            cylinder(d = d + 2, h = w);
            cylinder(d = d - 2 * depth, h = w);
        }
}

// Тело вставной пробки: вставная часть Ø d (z 0..plug_depth, z=0 — внутренний торец),
// фланец Ø flange_d (z plug_depth..plug_depth+flange_t), лаг шириной lug_w
// в сторону −Y, выступающий на lug_len за край фланца. Канавка O-ring уже вычтена.
module plug_body(d, lug_w, lug_len) {
    difference() {
        union() {
            cylinder(d = d, h = plug_depth);
            translate([0, 0, plug_depth]) cylinder(d = flange_d, h = flange_t);
            translate([-lug_w / 2, -(flange_d / 2 + lug_len), plug_depth])
                cube([lug_w, flange_d / 2 + lug_len, flange_t]);
        }
        oring_groove(d, oring_z);
    }
}

// Цилиндр вдоль −Y от точки p длиной h (для радиальных каналов).
module cyl_neg_y(p, d, h) {
    translate(p) rotate([90, 0, 0]) cylinder(d = d, h = h);
}

// Ёлочка, торчащая из плоскости y = y0 в сторону −Y, на высоте z.
module barb_neg_y(y0, z) {
    translate([0, y0, z]) rotate([90, 0, 0]) barb();
}
