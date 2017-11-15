d = 2;

zPcb = 47;

$fn=20;

module pcbController() {
    xPcb = 70 - 5;
    yPcb = 151;
    zCableOutlet = zPcb - 5;
    
    cube([xPcb, yPcb, zPcb]);
    dCable = 4;
    translate([0,-10,zCableOutlet-dCable/2])cube([xPcb,10,dCable]);
    echo("FIXME: correct positions of the pcb holes");
    for (x=[10,55]) {
        for (y=[10,141]) {
            translate([x,y,-d])cylinder(d=5,h=d);
        }
    }
}


xHousing = 70+141;
yHousing = 151;
zHousing = 85;

overlap=20;
dWood = 4;

module woodenPartsForCNC() {
    square([xHousing,yHousing+2*dWood]);
    translate([0,yHousing+20,0])difference() {
        square([xHousing,zHousing]);
        translate([0,zHousing-15,0])square([70,5]);
    }
    translate([xHousing+20,0,0]) {
        square([xHousing,yHousing+2*dWood]);
        translate([0,yHousing+20,0])square([xHousing,zHousing]);
    }
}


module generalHolder() {
    module woodenMiddlePart() {
        difference() {
            translate([0,-dWood,-dWood])cube([xHousing,yHousing+2*dWood,zHousing+2*dWood]);
            cube([xHousing,yHousing,zHousing]);
        }
    }
    difference() {
        translate([-d,-d-dWood,-d-dWood])cube([overlap+d,yHousing+2*(d+dWood),zHousing+2*(d+dWood)]);
        translate([0,d,d])cube([overlap,yHousing-2*d,zHousing-2*d]);
        woodenMiddlePart();
    }
}

module housingPcbSide() {
    
    module airHoles(nrOfHolesOnY, nrOfHolesOnZ) {
        border=8;
        for (y=[border:(yHousing-2*border)/nrOfHolesOnY:yHousing-border]) {
            for (z=[border:(zHousing-zPcb-2*border)/nrOfHolesOnZ:zHousing-zPcb-border]) {
                translate([-d,y,z])rotate([0,90,0])cylinder(d=5,h=d);
            }
        }
    }
    
    module pcbHolder() {
        translate([0,0,zHousing-zPcb-5])cube([70,yHousing,5]);
    }
    
    pcbHolder();
    difference() {
        generalHolder();
        airHoles(10, 3);
    }
}

module housingPowerSupplySide() {
    module powerSupply() {
        cube([141,yHousing,zHousing]);
    mirror([1,0,0])rotate([90,0,90])linear_extrude(d*1.1) {
            // screw holes
            translate([6,80])circle(d=4);
            translate([yHousing-6,80])circle(d=4);
            translate([yHousing-6,16])circle(d=4);
            translate([30,6])circle(d=4);
            // fan
            translate([(104+91)/2,(36.5+49)/2])circle(d=77);
            // power plug
            translate([5,52.5])square([51,23]);
            // switch
            translate([19,22])square([21,15]);
        }
    }
    difference() {
        generalHolder();
        powerSupply();
    }
}

//rotate([0,-90,90])housingPcbSide();
//woodenPartsForCNC();
rotate([0,-90,90])housingPowerSupplySide();
