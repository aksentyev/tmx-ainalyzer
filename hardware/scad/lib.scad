// Общие модули. Подключать через use <lib.scad>; параметры берутся из params.scad.
include <params.scad>

// Ёлочка под силиконовый шланг 4×6, вдоль +Z, основание в z=0, кончик в z=len.
// Конусы сужаются к кончику — шланг надевается с кончика и упирается в ступеньки.
module barb(od = barb_od, id = barb_id, len = barb_len) {
    neck = od - 0.8;
    difference() {
        union() {
            cylinder(d = neck, h = len);
            for (i = [0 : 2])
                translate([0, 0, 1.5 + i * 2.8]) cylinder(d1 = od, d2 = neck, h = 2.2);
        }
        translate([0, 0, -1]) cylinder(d = id, h = len + 2);
    }
}

// Канавка под O-ring на цилиндре Ø d, центр на высоте z (вычитать).
// Дно — groove_bottom_d (от канала, не от пробки). На стенке со стороны +Z — фаска 45°:
// при печати фланцем на стол эта стенка нависает над канавкой.
module oring_groove(d, z, w = oring_groove_w, bottom = groove_bottom_d, ch = oring_chamfer) {
    translate([0, 0, z - w / 2])
        difference() {
            union() {
                cylinder(d = d + 2, h = w);
                translate([0, 0, w - 0.01]) cylinder(d1 = bottom, d2 = bottom + 2 * ch, h = ch);
            }
            translate([0, 0, -1]) cylinder(d = bottom, h = w + ch + 2);
        }
}

// Фаска на ведущей кромке цилиндра Ø d в z=0 (вычитать).
module lead_chamfer_cut(d, c = lead_chamfer) {
    translate([0, 0, -0.01])
        difference() {
            cylinder(d = d + 2, h = c + 0.01);
            cylinder(d1 = d - 2 * c, d2 = d + 0.02, h = c + 0.02);
        }
}

// Тело вставной пробки: вставная часть Ø d (z 0..plug_depth, z=0 — внутренний торец),
// фланец Ø flange_d (z plug_depth..plug_depth+flange_t), лаг шириной lug_w
// в сторону −Y, выступающий на lug_len за край фланца. Канавка и фаска уже вычтены.
module plug_body(d, lug_w, lug_len) {
    difference() {
        union() {
            cylinder(d = d, h = plug_depth);
            translate([0, 0, plug_depth]) cylinder(d = flange_d, h = flange_t);
            translate([-lug_w / 2, -(flange_d / 2 + lug_len), plug_depth])
                cube([lug_w, flange_d / 2 + lug_len, flange_t]);
        }
        oring_groove(d, oring_z);
        lead_chamfer_cut(d);
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
