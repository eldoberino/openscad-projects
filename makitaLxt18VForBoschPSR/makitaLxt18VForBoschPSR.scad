dim = [131, 76];

module boschBatteryGroundPlate() {

    module groundPlate() {
        intersection() {
            square(dim);
            hull() {
                // round front
                translate([dim[1]/2,dim[1]/2])circle(d=dim[1], $fn=90);
                // back corners
                translate([dim[0]-16, dim[1]-10/2])circle(d=10);
                translate([dim[0]-16, 10/2])circle(d=10);
                // rounded back
                translate([dim[0]-58, dim[1]/2])circle(r=58, $fn=90);
            }
        }
    }

    module screwHole() {
        circle(d=3.5, $fn=90);
    }

    difference() {
        groundPlate();

        #translate([5.5, dim[1]/2])screwHole();

        #translate([50, 5])screwHole();
        #translate([50, dim[1]-5])screwHole();

        #translate([dim[0]-9, 18])screwHole();
        #translate([dim[0]-9, dim[1]-18])screwHole();
    }
}

makitaLXTHolder_length = 30 + 18;
makitaLXTHolder_outside_width = 61;
makitaLXTHolder_thickness = 3.5;
// from [Makita LXT 18v Li-ion Battery Clip](https://www.thingiverse.com/thing:74136)
module makitaLXTHolder() {
    inside_width=54;
    outside_width=makitaLXTHolder_outside_width;
    outside_height=10;
    inside_height=4;
    thickness=makitaLXTHolder_thickness;
    length=makitaLXTHolder_length;
    difference(){
        union(){
            linear_extrude(height=thickness){
                square([outside_width+2*thickness,length]);
            }
            
            translate([0,0]){	
                linear_extrude(height=thickness+outside_height){
                    square([thickness,length]);
                }
                
                translate([0,0,thickness+outside_height]){
                    linear_extrude(height=inside_height){
                        square([thickness+(outside_width-inside_width)/2,length]);
                    }
                }
            }

            translate([outside_width+thickness,0]){	
                linear_extrude(height=thickness+outside_height){
                    square([thickness,length]);
                }
                
                translate([-(outside_width-inside_width)/2,0,thickness+outside_height]){
                    linear_extrude(height=inside_height){
                        square([thickness+(outside_width-inside_width)/2,length]);
                    }
                }
            }		
        }
        
        #union(){
            translate([10.25+thickness,0]){
                linear_extrude(height=thickness+outside_height+inside_height){
                    square([1.5,25+18]);
                    translate([-3,0])square([10,10]);  // space to attach cable to 'fin'
                }
            }
            
            translate([thickness + outside_width - 10.75 - 1,0]){
                linear_extrude(height=thickness+outside_height+inside_height){
                    square([1.5,25+18]);
                    translate([-5.5,0])square([10,10]);  // space to attach cable to 'fin'
                }
            }
        }
    }

    difference(){
        translate([(outside_width+thickness*2-inside_width) /2,length]){
            linear_extrude(height=thickness){
                square([inside_width,20]);
            }
        }
        union(){
            translate([(outside_width+thickness*2-36) /2,length+5]){
                linear_extrude(height=thickness){
                    square([36,12]);
                }
            }
            
            translate([0,length+12, thickness-1]){
                linear_extrude(height=1){
                    square([outside_width+thickness*2,8]);
                }
            }
        }
    }
}

dGroundplate = 4;
offsetMakitaBattery = 9;
difference() {
    translate([0,0,-dGroundplate])
    linear_extrude(dGroundplate)boschBatteryGroundPlate();

    translate([0,0,-(6.5-makitaLXTHolder_thickness)])
    linear_extrude(6.5-makitaLXTHolder_thickness)
    hull()
    projection()
    translate([offsetMakitaBattery + makitaLXTHolder_length + 20 + 23, (dim[1]-(makitaLXTHolder_outside_width+2*makitaLXTHolder_thickness))/2,0])
    rotate([0,0,90])makitaLXTHolder();    
}
// we have to make the Makita battery groundplate thicker so that it's deep enough for the battery 'snap-in'
translate([0,0,-(6.5-makitaLXTHolder_thickness-1)])
linear_extrude(6.5-makitaLXTHolder_thickness-1)
projection()
translate([offsetMakitaBattery + makitaLXTHolder_length + 20 + 23, (dim[1]-(makitaLXTHolder_outside_width+2*makitaLXTHolder_thickness))/2,0])
rotate([0,0,90])makitaLXTHolder();    

translate([offsetMakitaBattery+makitaLXTHolder_length + 20 + 23, (dim[1]-(makitaLXTHolder_outside_width+2*makitaLXTHolder_thickness))/2, -(6.5-makitaLXTHolder_thickness)])
rotate([0,0,90])makitaLXTHolder();


// protection & stabilization at the back

linear_extrude(13.5 /*thickness+outside_height*/ + 1)
intersection() {
    difference() {
        hull()boschBatteryGroundPlate();
        
        translate([2, 5])
        resize([dim[0]-2*2, dim[1]-2*5])hull()boschBatteryGroundPlate();
    }
    translate([52,0])square(dim);
}
