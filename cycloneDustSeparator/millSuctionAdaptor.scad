d = 2;      // thickness material

dB = 300-2*30;   // outer diameter inner ring in bucket (diameter for polycarbonate)
// dMOut: outer diameter tube from mill
// i.e. you put the tube coming from the mill into this tube
dMOut = 47;
h = 80;     // height plexy
extraSpace = 15;    // extra space on segment left & right of tube entry

echo(diameter_inner_ring=dB);
echo(outside_diameter_tube=dMOut);
echo(height_plexy=h);

dM = dMOut +2*d;

alpha = acos((dB/2-dM)/(dB/2));
PI = 3.142;
extraAngle = extraSpace / (PI*dB) * 360;

module segment(offset=0) {
    // rotate_extrude ignores angle parameter!
    // rotate_extrude(angle=alpha)square([dB/2,h]);
    difference() {
        cylinder(d=dB-2*offset, h=h, $fn=80);
        rotate([0,0,-extraAngle])translate([-dB/2,-dB/2,0])cube([dB/2,dB,h]);
        rotate([0,0,180+alpha+extraAngle])translate([-dB/2,-dB/2,0])cube([dB/2,dB,h]);
    }
}

module millTube(offset=0) {
    lTube = dB/2*sin(alpha) + 40;
    translate([0,-dB/2+dM/2, h/2])
    rotate([0,90,0])cylinder(d=dM-2*offset, h=lTube);
}

difference() {
    union() {
        segment();
        millTube();
    }
    segment(d);
    millTube(d);
}