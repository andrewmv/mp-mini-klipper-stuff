// Runout sensor bracket for MP Mini Select V2 and BTT SVS v2

// Helpers
x=0; y=1; z=2;
include <bowden_grommet.scad>

// Parameters
$fn = 20;
thickness = 1.5;			// z-thickness of shelf
ydim = 59.5 + thickness;	// Total y size of part
bezel_r = 5;				// Radius of bezeled corners of bracket

// Chassis screw 49.13 head to head - 6.31/head = 42.82
chassis_screw_ydelta = 42.8;
chassis_screw_yorigin = 9;
chassis_screw_r = 3 / 2;	// Radius of chasssis mounting screw holes
chassis_screws = [			// Positions of chassis mounting screw holes
	[5,chassis_screw_yorigin],
	[5, chassis_screw_yorigin + chassis_screw_ydelta]
];
chassis_slot_thickness = 1.0;
chassis_screw_well_thickness = 0.5;
chassis_screw_well_r = 6.5 / 2;
chassis_bezel_r = 10.0;		// Radius of bend at corner of chassis
chassis_xdim = chassis_screws[0][x] + 14.7 - chassis_bezel_r;			// Width of straight run of chassis shelf

// Chassis filament port is -11.0 from chassis_screws[1] 
// Sensor filament port is +11.9 from sensor_screws[0]
filament_plane = chassis_screws[1][y] - 11.0;
filament_height_at_sensor = 20.0 - thickness;
filament_height_at_chassis = 11.0 - thickness;

sensor_screw_r = 4 / 2;		// Radius of sensor mounting screw holes
sensor_screw_ydelta = 24.7;
sensor_screw_xdelta = 12.4;
sensor_screw_yorigin = filament_plane - 11.9 - bezel_r;
sensor_screws = [			// Positions of sensor mounting screw holes
	// [0,15],
	// [0, 39],
	// [12, 39]
	[0, sensor_screw_yorigin],
	[0, sensor_screw_yorigin + sensor_screw_ydelta],
	[0 + sensor_screw_xdelta, sensor_screw_yorigin + sensor_screw_ydelta]
];
sensor_shelf_standoff = 12;
sensor_xdim = 23;
sensor_xdelta = 20; // Height of straight run before start of sensor shelf

gantry_hook_gap = 2.0; // Thickness of sheet-steel
gantry_hook_height = 8.0;
gantry_hook_depth = 5.0;

grommet_inner_r = 4.10 / 2;
grommet_thickness = 3;
grommet_bezel_r = 1.5;
grommet_depth = 5;
grommet_xoff = -grommet_depth - 3;

// Assembly

chassis_shelf();
chassis_bezel();
rotate([0,90,0])
	translate([chassis_bezel_r + sensor_xdelta, 0, chassis_bezel_r + chassis_xdim])
		sensor_shelf();

// Modules

module grommet_hole() {
    cylinder(r=part_r, h=10);
}

module filament_guide(height) {
    // grommet
    translate([part_h, 0, height])
        rotate([0,-90,0])
            bowden_grommet();
	// grommet brace
    difference() {
        translate([0, -part_r, 0])
            cube([part_h, part_r * 2, height]);
        translate([-1, 0, height])
            rotate([0,90,0])
                grommet_hole();
    }
}

module gantry_hook() {
    translate([0,0,-gantry_hook_gap])
        cube([gantry_hook_height, thickness, gantry_hook_gap]);
    translate([0,-gantry_hook_depth,-gantry_hook_gap - thickness])
        cube([gantry_hook_height, gantry_hook_depth + thickness, thickness]);
}

module sensor_shelf() {
    translate([-sensor_xdelta, 0, 0])
        cube([sensor_xdelta, ydim, thickness]);
	translate([0,0,sensor_shelf_standoff]) {
		difference() {
			cube([sensor_xdim, ydim, thickness]);
			for (i = [0 : 2]) {
				translate(sensor_screws[i])
					translate([bezel_r,bezel_r,-1])
						cylinder(h=thickness + 2, r=sensor_screw_r);
			}
		}
	}
	// standoff
	cube([thickness, ydim, sensor_shelf_standoff]);
    *cube([sensor_xdim, thickness, sensor_shelf_standoff]);
	translate([sensor_xdim - thickness, 0, 0])
		cube([thickness, ydim, sensor_shelf_standoff]);
	translate([0, ydim - thickness, 0])
		cube([sensor_xdim, thickness, sensor_shelf_standoff]);

    // hook
    translate([7.25, ydim - thickness, 0])
        color("red") gantry_hook();
}

module chassis_bezel() {
	translate([chassis_xdim,ydim,-chassis_bezel_r])
		rotate([90, 0, 0])
			rotate_extrude(angle=90, convexity=2, $fn=60) 
				translate([chassis_bezel_r, 0, 0])
					square([thickness, ydim]);
}

module chassis_shelf() {
	difference() {
		cube([chassis_xdim, ydim, thickness]);
		for (i = [0 : 1]) {
			translate(chassis_screws[i]) {
				screw_slot();
			}
		}
	}
    translate([0,filament_plane,0])
        filament_guide(11.5);
}	

module screw_slot() {
	// inner slot
	translate([0,0,-10])
		cylinder(h=20, r=chassis_screw_r);
	translate([-20, -chassis_screw_r, -10])
		cube([20, chassis_screw_r * 2, 20]);
	// outer slot
	translate([0,0,chassis_screw_well_thickness])
		cylinder(h=20, r=chassis_screw_well_r);
	translate([-20, -chassis_screw_well_r, chassis_slot_thickness])
		cube([20, chassis_screw_well_r * 2, 20]);
}