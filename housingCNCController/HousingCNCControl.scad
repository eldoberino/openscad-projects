include <../dopOpenScadHelpers.scad>

d=2;

showTopNotBottom = true;


$fn=40;

holeOffset=3;
xPCB=144+2*holeOffset;
yPCB=48+2*holeOffset;
heightScreenFromPCB=14;

xFront=2*d+xPCB;
yFront=2*d+yPCB+9;
alpha=45;

module board() {
    xScreen=76;
    yScreen=26;
    dPCB=2;
    
    // pcb
    translate([0,0,-dPCB])cube([xPCB,yPCB,dPCB]);
    // screen
    translate([25,yPCB-20-yScreen])cube([xScreen,yScreen,heightScreenFromPCB+d]);
    // poti: 
    translate([xPCB-13.5,yPCB-30])cylinder(d=8,h=heightScreenFromPCB+d);
    // emergencyStop
    translate([xPCB-13.5,7.5])cylinder(d=4,h=heightScreenFromPCB+d);
    // SD slot
    translate([-5,9,-dPCB-3])cube([32,25,3]);
}

function angleComp() = (1-cos(alpha))/sin(alpha);   // if non-overlapping
function angleComp2() = (1-sin(alpha))/cos(alpha);  // if overlapping



depthRoof=20;

sideAsVectors = [[10,90],[yFront,alpha],[depthRoof-d,0],[sin(alpha)*yFront+10,-90] ];

module housing() {
    translate([0,0,d])rotate([90,0,90])   
    difference() {
        linear_extrude(height=xFront)displayPolygon(sideAsVectors, true);
        translate([d,0,d])
        linear_extrude(height=xFront-2*d)
        displayPolygon([[10-d*angleComp2(),90],[yFront-2*d*angleComp2(),alpha],[depthRoof-d*angleComp2()-2*d,0],[sin(alpha)*yFront+10-d,-90] ], true);
    }
    rotate([alpha,0,0])
    translate([0,10*cos(alpha),10*cos(alpha)-heightScreenFromPCB]){
        // Befestigung fuer PCB
        for (x=[d,d+144]) {
            for (y=[yFront-d-6,yFront-d-6-48]) {
                translate([x,y,0])cube([6,6,heightScreenFromPCB]);
            }
        }
        // Fuehrung fuer Emergency Stop
        translate([xPCB-13.5+d,yFront-d-6-48+7.5,5])cylinder(d=10,h=heightScreenFromPCB-5);
    }
}

module bottom() {
    sidePolygon=relativeStepsToAbsoluteCoordinates([[0,0]], sideAsVectors);
    yBottom=sidePolygon[len(sidePolygon)-1][0];
    difference() {
        cube([xFront-2*d-1,yBottom-2*d-1,10]);
        translate([d,d,d])cube([xFront-2*d-1 - 2*d,yBottom-2*d-1 - 2*d,10-d]);
        translate([62,22,0])cube([40,10,d]);
    }
    for (x=[d,xFront-2*d-1 - d-10]) {
        translate([x,yBottom/2-d-10/2,0])cube([10,10,10]);
    }
}

if (showTopNotBottom)
    rotate([0,0,180])
    difference() {
        rotate([180-alpha,0,0])    
        difference() {
            housing();
            #translate([0,0,10])rotate([alpha,0,0])translate([d,d+9,-heightScreenFromPCB])board();
        }
    }
else {
    translate([d,d,0])bottom();
}
