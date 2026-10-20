// Пробка B — микрофон в центре внутреннего торца, выход газа через карман с TMP117.
// Микрофон: плата лежит в углублении внутреннего торца портом в трубку (bottom-port, плоской
// стороной к газу), компонентами к пробке; провода — через осевое отверстие, залить эпоксидкой.
// Газ: трубка → осевой канал → радиальный канал → карман TMP117 (открыт с наружного торца,
// плата внутрь, после распайки залить) → ёлочка на лаге.
include <params.scad>
use <lib.scad>

module plug_b(fit = plug_fit) {
    d         = bore_d - fit;
    lug_y0    = -(flange_d / 2 + lug_len_b);
    zc        = plug_depth + flange_t / 2;
    top       = plug_depth + flange_t;
    out_y     = -6;                                    // осевой выходной канал
    pocket    = [tmp_pcb[0] + 2 * clr, tmp_pcb[1] + 2 * clr, 6];
    pocket_yc = -(flange_d / 2 + lug_len_b / 2);       // центр кармана по Y
    pocket_near = pocket_yc + pocket[1] / 2;           // ближняя к оси стенка кармана

    difference() {
        union() {
            plug_body(d, lug_w_b, lug_len_b);
            barb_neg_y(lug_y0, zc);
        }
        // углубление под плату микрофона на внутреннем торце
        translate([-(mic_pcb[0] + clr) / 2, -(mic_pcb[1] + clr) / 2, -1])
            cube([mic_pcb[0] + clr, mic_pcb[1] + clr, mic_recess_depth + 1]);
        // провода микрофона наружу
        translate([6, 0, mic_recess_depth - 0.5]) cylinder(d = 3, h = top);
        // осевой выходной канал
        translate([0, out_y, -1]) cylinder(d = chan_d, h = zc + 1);
        // радиальный канал до кармана
        cyl_neg_y([0, out_y, zc], chan_d, out_y - pocket_near + 1);
        // карман TMP117, открыт с наружного торца
        translate([-pocket[0] / 2, pocket_yc - pocket[1] / 2, top - pocket[2]])
            cube([pocket[0], pocket[1], pocket[2] + 1]);
        // канал из кармана в ёлочку
        cyl_neg_y([0, pocket_yc, zc], barb_id, pocket_yc - lug_y0 + barb_len + 2);
    }
}

plug_b();
