include <../dopOpenScadHelpers.scad>

f=24.5/34;


dTube = 2;
dInner = 9;
dOutside = 25;
rInnerTube = 30;
echo(dTube=dTube, dInner=dInner, dOutside=dOutside, rInnerTube=rInnerTube);


alpha = asin((rInnerTube-dOutside/2) / rInnerTube);
lStraight = cos(alpha) * rInnerTube+dOutside/2 + 4;

$fn = 60;

union() {
    rotate([0,-90,0])Gardena();
    difference() {
        tubeSystem(dOutside);
        tubeSystem(dInner);
    }
    translate([lStraight, 0, 0])
        rotate([0,90,0])Gardena();
    translate([rInnerTube, -rInnerTube, 0])
        rotate([0,90,-90])Gardena();
}



module tubeSystem(dTube)
{
    translate([0, -rInnerTube])
    rotate_extrude(convexity = 10, angle = 90)
        translate([rInnerTube, 0, 0])
            circle(d = dTube);
    rotate([0,90,0])
        cylinder(d=dTube, h=lStraight /*rInnerTube+dOutside/2*/);
}


module Gardena() {
    rotate_extrude()
    translate([-20/2,0])rotate([0,0,90])Gardena2D();
}

module Gardena2D()
{
    rSeg2 = 3;
    displayPolygon([
        [5,0],
        [rSeg2,-90], [8, 0],
        [rSeg2-1.5,90], [3,0],
        [0.5, -90], [2.4,0],
        [2.2,-90], [3.2,0], [2.2,90],
        [2.1,0],
        [sqrt(2)/2,-45],
        /*way back*/
        [3,-90],
        [24,-180]], true);
    // -> results in figure to check against:
    // figure = [[0, 0], [5, 0], [5, -3], [13, -3], [13, -1.5], [16, -1.5], [16, -2], [18.4, -2], [18.4, -4.4], [21.6, -4.4], [21.6, -2], [23.7, -2], [24.2, -2.5], [24.2, -5.5], [0.2, -5.5]]
    translate([5+rSeg2,0])intersection() {
        difference(){
            square(2*rSeg2, true);
            circle(r=rSeg2);
        }
        translate([-rSeg2,-rSeg2])square(rSeg2);
    }
}
