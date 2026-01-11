/*
makes use of the following models:
- "2051_servo_tower-pro-sg90.pk2.stl" from https://www.thingiverse.com/thing:787942/files
- "SG90_Disc_20220121_2_v4.stl" from https://www.thingiverse.com/thing:5209841/files
*/

model = "carousel";  // ["carousel", "disc"]


rCarousel = 12.7;
dimServo = [22.5, 12, 8.5];

module servoModel() {
    translate([-4.1,-12/2,16])
    translate([0,-45,0])
    import("2051_servo_tower-pro-sg90.pk2.stl");
}

module servoHolderFromTop() {
    d = 2;
    translate([0, -dimServo[1]/2, 18.5])
    difference() {
        translate([-d, -d, 0])
        cube([dimServo[0]+2*d, dimServo[1]+2*d, dimServo[2]]);
        cube(dimServo);
    }
}

module adapterServoToMicroSwitchesHolder() {
    d = 2;
    difference() {
        translate([5.8,0,33.7-2.4-1.5-2.8-d])
        linear_extrude(d)
        projection(cut=true)
        hull()microSwitches();
        
        translate([0, -dimServo[1]/2, 18.5])
        cube(dimServo);
    }
}

module microSwitchHolder() {
    distHole = 9.6;
    d = 2;
    dimMicroSwitch = [20+0.5, 10+0.5, 6];
    
    module microSwitch() {
        cube(dimMicroSwitch);
        translate([5,dimMicroSwitch[1],0])
        cube([4,1,dimMicroSwitch[2]]);
        translate([6,dimMicroSwitch[1]+1,0])
        cube([2,1,dimMicroSwitch[2]]);
    }
    %microSwitch();

    // side left
    translate([-d,0,0])
    cube([d, dimMicroSwitch[1], dimMicroSwitch[2]]);
    // side right
    translate([dimMicroSwitch[0],0,0])
    cube([d, dimMicroSwitch[1], dimMicroSwitch[2]]);
    // side bottom
    translate([4,-d,0])
    cube([4,d,dimMicroSwitch[2]]);
    // side top left
    translate([-d,dimMicroSwitch[1],0])
    cube([d+1,d,dimMicroSwitch[2]]);
    // side top right
    translate([dimMicroSwitch[0]-4,dimMicroSwitch[1],0])
    cube([4+d,d,dimMicroSwitch[2]]);
}

module microSwitches() {
    nrOfAkkus = 3;
    for (i = [1:nrOfAkkus]) {
        rotate([0,0,(i-1)/nrOfAkkus*360+30+180])
        translate([0,-rCarousel,0])
        translate([-6-2/2, -10, 0])
        microSwitchHolder();
    }
//    %difference() {
//        cylinder(r=rCarousel-1, h=6, $fn=60);
//        cylinder(d=2, h=6, $fn=60);
//    }
}

module servoDisc() {
    // inner part
    scale([1.03, 1.03, 1])
    intersection() {
        rotate([180,0,0])
        translate([3-6.5, -6.5, 0])
        rotate([180,0,0])
        import("SG90_Disc_20220121_2_v4.stl");

        cylinder(d=6.9, h=20, $fn=60);
    }
    // actual disk
    translate([0,0,-0])
    linear_extrude(3.0)difference() {
        disk();
        circle(d=6.9, $fn=60);
    }
}


module disk() {
    r = rCarousel-1;    // base radius
    drop = 2;         // amount to decrease
    rampAngle = 20;

    polygon(points = [
        for (a = [0 : 360])
            let (
                rad =
                    a <= 120 ? r :
                    a <= (120+rampAngle) ? r - (a - 120) / rampAngle * drop :
                    a <= (360-rampAngle) ? r - drop :
                               r - drop + (a - (360-rampAngle)) / rampAngle * drop
            )
            [ rad*cos(a), rad*sin(a) ]
    ]);
}


%servoModel();

if (model == "carousel") {
    translate([5.8,0,33.7-2.4-1.5-2.8])microSwitches();
    adapterServoToMicroSwitchesHolder();
    servoHolderFromTop();
    %translate([-0.7+6.5, 0, 33.7-2.4])rotate([180,0,0])servoDisc();
} else {
    translate([-0.7+6.5, 0, 33.7-2.4])
    rotate([180,0,0])
    servoDisc();
}
