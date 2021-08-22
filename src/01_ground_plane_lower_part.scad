//------------------------------------------------
// 1 - Ground Plane Antenna - lower part
//
// author: Alessandro Paganelli 
// e-mail: alessandro.paganelli@gmail.com
// github: https://github.com/allep
// license: GPL-3.0-or-later
// 
// Description
// This is the lower part of the ground plane antenna head.
//
// All sizes are expressed in mm.
//------------------------------------------------

// Set face number to a sufficiently high number.
$fn = 50;

//------------------------------------------------
// Debug mode
// Set DEBUG_MODE to 1 to simulate the actual 
// screw positions, to validate the design.
DEBUG_MODE = 0;

//------------------------------------------------
// Variables

// Screws
// M3 screws - 1.5 + 5% tolerance
SCREW_RADIUS = 1.575;
SCREW_DEPTH = 20.0;

// Cables holes
// RG58 radius is approx 5 mm, so keep some safe margin here
CABLE_HOLE_RADIUS = 3.1;

// Boom connector
BOOM_CONNECTOR_HEIGHT = 30.0;
BOOM_CONNECTOR_RADIUS = 10.90;
BOOM_CONNECTOR_SCREW_HEIGHT = 20.0;

BASE_SIDE_MM = 65.0;
BASE_THICKNESS_MM = 15.0;

// Reflectors
REFLECTOR_SIDE_MM = 14.0;
REFLECTOR_LENGTH_MM = 60.0;
REFLECTOR_THICKNESS_MM = 1.4;
REFLECTOR_HOLE_DIAM_MM = 5.0;
REFLECTOR_INCLINATION_ANGLE_DEGREES = 45.0;

//------------------------------------------------
// Modules

// Boom connector
module boom_connector(radius, height, screw_radius) {
    difference() {
        cylinder(h = height, r = radius, center = true);
        
        // reinforcement central screw
        cylinder(h = height, r = screw_radius, center = true);
        
        // side screw
        rotate([0, 90, 0])
        cylinder(h = 2*radius, r = screw_radius, center = true);
    }
}

// Reflector part
// To be subtracted from the assembly
module reflector(reflector_side_mm, reflector_length_mm, reflector_tickness_mm, inclination_angle_degrees) {
    rotate([inclination_angle_degrees, 0, 0])
    cube(size = [reflector_side_mm, reflector_length_mm, reflector_tickness_mm], center = true);
}

// Square base
module square_base(base_side_mm, 
                   base_thickness_mm,
                   reflector_side_mm,
                   reflector_length_mm,
                   reflector_tickness_mm,
                   reflector_inclination_angle_degrees,
                   screw_radius_mm,
                   cable_radius_mm)
{
    reflector_hole_displacement_mm = base_side_mm / 3;
    screw_hole_displacement_mm = base_side_mm / 2 - 3 * screw_radius_mm;
    cable_hole_displacement_mm = base_side_mm / 2 - 3 * cable_radius_mm;
                       
    difference() {
        // The actual base
        cube(size = [base_side_mm, base_side_mm, base_thickness_mm], center = true);
        
        // The reflectors holes
        translate([0, -reflector_hole_displacement_mm, 0])
        reflector(reflector_side_mm, reflector_length_mm, reflector_tickness_mm, reflector_inclination_angle_degrees);
        rotate([0, 0, 90])
        translate([0, -reflector_hole_displacement_mm, 0])
        reflector(reflector_side_mm, reflector_length_mm, reflector_tickness_mm, reflector_inclination_angle_degrees);
        rotate([0, 0, 180])
        translate([0, -reflector_hole_displacement_mm, 0])
        reflector(reflector_side_mm, reflector_length_mm, reflector_tickness_mm, reflector_inclination_angle_degrees);
        rotate([0, 0, 270])
        translate([0, -reflector_hole_displacement_mm, 0])
        reflector(reflector_side_mm, reflector_length_mm, reflector_tickness_mm, reflector_inclination_angle_degrees);
        
        // cable holes (only one is needed, but this way we have simmetry)
        translate([cable_hole_displacement_mm, - cable_hole_displacement_mm, 0])
        cylinder(h = base_thickness_mm, r = cable_radius_mm, center = true);
        translate([- cable_hole_displacement_mm, cable_hole_displacement_mm, 0])
        cylinder(h = base_thickness_mm, r = cable_radius_mm, center = true);
        
        // screw holes
        translate([screw_hole_displacement_mm, screw_hole_displacement_mm, 0])
        cylinder(h = base_thickness_mm, r = screw_radius_mm, center = true);
        translate([- screw_hole_displacement_mm, - screw_hole_displacement_mm, 0])
        cylinder(h = base_thickness_mm, r = screw_radius_mm, center = true); 
        
        // central screw hole
        cylinder(h = base_thickness_mm, r = screw_radius_mm, center = true);
    }
}

//------------------------------------------------
// Actual script

if (DEBUG_MODE == 0) {
    // release mode

    union() {
        translate([0, 0, BASE_THICKNESS_MM / 2])
        square_base(BASE_SIDE_MM, BASE_THICKNESS_MM, REFLECTOR_SIDE_MM, REFLECTOR_LENGTH_MM, REFLECTOR_THICKNESS_MM, REFLECTOR_INCLINATION_ANGLE_DEGREES, SCREW_RADIUS, CABLE_HOLE_RADIUS);
        
        translate([0, 0, - BOOM_CONNECTOR_HEIGHT / 2])
        boom_connector(BOOM_CONNECTOR_RADIUS, BOOM_CONNECTOR_HEIGHT, SCREW_RADIUS);
    }
}
else {
    // debug mode
    // TODO
}
