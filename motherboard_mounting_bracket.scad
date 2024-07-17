x=0; y=1; z=2;

outer_frame_screw_pos = [
	[0,0],
	[93,0],
	[93,42],
	[0,42]
];

// inner_frame_screw_xdelta = 58.11;
// inner_frame_screw_ydelta = 49.31;
inner_frame_screw_pos = [
	[0,0],
	[59,0],
	[59,49.5],
	[0,49.5]
];

// 62.55 - 4.44 = 58.11
// 53.75 - 4.44 = 49.31

frame_width = 9;
depth= 1.5;
outer_screw_r = 4.5 / 2; // threads on chassis
inner_screw_r = 2.75 / 2; // threads on part
inner_standoff = 4; // riser height (above frame)
standoff_r = 6 / 2;
outer_standoff = 0; // riser height (below frame)
$fn = 20;

color("red") {
    translate([-18,-19,depth])
        linear_extrude(0.5)
            text("v2.6 2024-05-24", size=6);
}

// Inner Frame
difference() {
    union() {
        frame(inner_frame_screw_pos);
        // Inner Screws
        for (i = [0 : 3]) {
            translate(inner_frame_screw_pos[i]) {
                inner_screw();
            }
        }
    }
    punch_holes(inner_frame_screw_pos, inner_screw_r);
}



// Outer Frame
translate([-17-8.5,-15,0]) {
    difference() {
        union() {
            frame(outer_frame_screw_pos);

            // Outer Screws
            for (i = [0 : 3]) {
                translate(outer_frame_screw_pos[i]) {
                    outer_screw();
                }
            }
        }
        punch_holes(outer_frame_screw_pos, outer_screw_r);
    }

    // Messy cram some extra support in
    translate([outer_frame_screw_pos[1][x] / 2 - frame_width / 2,-frame_width/2,0]) {
        cube([frame_width,inner_frame_screw_pos[2][y]+15,depth]);
    }
}


module punch_holes(screws, screw_r) {
    for (i = [0 : 3]) {
        translate(screws[i]) {
            translate([0,0,-20]) {
                cylinder(h=40, r=screw_r);
            }
        }
    }
}

module frame(screws) {
    // Frame around perimeter
    //south
    translate(screws[0] - [0,frame_width/2,0])
        cube([screws[1][x], frame_width, depth]);
    //east
    translate(screws[1] - [frame_width/2,0,0])
        cube([frame_width, screws[2][y], depth]);
    //north
    translate(screws[3] - [0,frame_width/2,0])
        cube([screws[2][x], frame_width, depth]);
    //west
    translate(screws[0] - [frame_width/2,0,0])
        cube([frame_width, screws[3][y], depth]);
}

module inner_screw() {
    cylinder(h=depth + inner_standoff, r=standoff_r);
    cylinder(h=depth, r=frame_width/2);

}

module outer_screw() {
    translate([0,0,-outer_standoff]) {
        cylinder(h=outer_standoff + depth, r=frame_width/2);
    }
}
        
