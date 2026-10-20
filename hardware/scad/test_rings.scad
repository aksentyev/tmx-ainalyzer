// Тест-кольца посадки пробок в трубку. Варианты зазора из plug_fits,
// количество засечек на торце = номер варианта (1, 2, 3). Печатать первыми,
// в одном задании с пробками. Какое кольцо село с нужным усилием (с надетым O-ring 18×2) —
// тот fit и у пробок. Проверяют и гладкую посадку, и натяг/обжатие кольца.
include <params.scad>
use <lib.scad>

ring_h = 10;

module test_ring(fit, notches) {
    d = bore_d - fit;
    difference() {
        cylinder(d = d, h = ring_h);
        translate([0, 0, -1]) cylinder(d = 14, h = ring_h + 2);
        oring_groove(d, ring_h / 2);
        lead_chamfer_cut(d);
        for (k = [0 : notches - 1])
            rotate([0, 0, k * 30]) translate([d / 2 - 2, -0.75, ring_h - 1.5]) cube([3, 1.5, 2]);
    }
}

for (i = [0 : len(plug_fits) - 1])
    translate([i * (bore_d + 6), 0, 0]) test_ring(plug_fits[i], i + 1);
