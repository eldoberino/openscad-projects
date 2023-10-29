dimNokia = [52.3, 118.7, 14.5];

module outline() {
    hull()
    resize([dimNokia[0], dimNokia[1]])
    translate([-2,-1])
    import("nokia-3310-outline.dxf");
}


dClip = 6.5;
hExtraAtBottom = 3;
dFrameClip = 1.0;
slideDepth = 34;
rStopperHole = dClip/2 - 1;

module frameClip(stopperOnly=false) {
    if (!stopperOnly) {
        linear_extrude(dClip)
        difference() {
            union() {
                resize([dimNokia[0]+2*dFrameClip, dimNokia[1]+2*dFrameClip])outline();
                translate([0,-hExtraAtBottom])square([dimNokia[0]+2*dFrameClip, 2*slideDepth+dFrameClip]);
            }
            translate([dFrameClip,dFrameClip])outline();
        }

        // thorn into 3.5mm audio jack
        translate([dFrameClip+dimNokia[0]/2+8, dimNokia[1]+2*dFrameClip, 3.5/2])
        rotate([90,0,0])cylinder(d=3.2, h=6, $fn=60);
    }

    hStopper = 2.0;
    for (x=[10, dimNokia[0]+2*dFrameClip+hStopper]) {
        translate([x, rStopperHole-hExtraAtBottom+3, dClip/2])
        rotate([0,-90,0])cylinder(r=rStopperHole, h=hStopper+10, $fn=60);
    }
}


dCase = 2.0;

module buttonsCutout() {
    dRounding = 2/3*dimNokia[0];
    translate([0,dRounding/2, -5])
    linear_extrude(10)
    hull(){
        translate([2, 0])square([dimNokia[0]-2*2,dRounding/2]);
        translate([2+dRounding/2, 0])circle(d=dRounding, $fn=120);
        translate([dimNokia[0]-(2+dRounding/2), 0])circle(d=dRounding, $fn=120);
    }
}


module protectionCase() {
    xExtra = 1;

    module housingShape(outer=true) {
        outerExtra = outer ? 2*dCase : 0;
        innerDiscount = outerExtra - 2*dCase;
        extraXForEllipsis = 10;
        rCorner = 3;

        intersection() {
            // rounded square
            hull()
            linear_extrude(dimNokia[2]+outerExtra) {
                #translate([rCorner, rCorner])circle(r=rCorner, $fn=60);
                #translate([dimNokia[0]+xExtra+outerExtra-rCorner, rCorner])circle(r=rCorner, $fn=60);
                translate([0,rCorner])
                square([dimNokia[0]+xExtra+outerExtra, 2*slideDepth+outerExtra/2 - 3/2]);
            }

            // ellipsis
            translate([(dimNokia[0]+5+innerDiscount)/2, 0, (dimNokia[2]+(outerExtra-2*dCase))/2+dCase])
            rotate([-90,0,0])
            linear_extrude(2*slideDepth+outerExtra/2)
            resize([dimNokia[0]+(outerExtra-2*dCase)+2*extraXForEllipsis, dimNokia[2]+(outerExtra-2*dCase)+2*dCase])
            circle(d=dimNokia[0]+(outerExtra-2*dCase)+2*extraXForEllipsis, $fn=120);
        }
    }

    module softHousing() {
        difference() {
            housingShape(true);
            translate([dCase,dCase,dCase])housingShape(false);
        }
    }

    module keyDistanceProtection() {
        dProtectionRail = 3;
        for (x=[-7.5, 7.5]) {
            translate([(dimNokia[0]+xExtra+2*dCase)/2 + x, hExtraAtBottom+dProtectionRail/2, dimNokia[2]+dCase])
            hull() {
                sphere(d=dProtectionRail, $fn=60);
                translate([0, slideDepth-dProtectionRail, 0])sphere(d=dProtectionRail, $fn=60);
            }
            // rotate([-90,0,0])cylinder(d=2, h=slideDepth, $fn=60);
        }
    }

    difference() {
        union() {
            softHousing();
            #keyDistanceProtection();
        }

        // movement of slide stopper
        translate([dCase-dFrameClip+xExtra/2-0.01*(dimNokia[0]),hExtraAtBottom+dCase-dFrameClip,(dimNokia[2]+2*dCase-dClip)/2])
        scale([1.02,1.0,1.1])
        {
            hull() {
                frameClip(true);
                translate([0,slideDepth, 0])frameClip(true);
            }
            // instead of cutting away frameClip which is uneven -> use simple square model
//            #hull()frameClip();
            translate([0,-hExtraAtBottom])cube([dimNokia[0]+2*dFrameClip, dimNokia[1]+hExtraAtBottom+2*dFrameClip, dClip]);
        }

        // cutout for navigation buttons
        translate([dCase, 2*slideDepth+hExtraAtBottom-32, dimNokia[2]+dCase])buttonsCutout();
    }
}

// part 1: nokia_protection_case.stl
protectionCase();
%translate([dCase-dFrameClip,hExtraAtBottom+dCase-dFrameClip,(dimNokia[2]+2*dCase-dClip)/2])frameClip();

// part 2: nokia_frame_clip.stl
//difference() { frameClip(); #frameClip(true); }

// part 3: nokia_sliding_stift.stl
//cylinder(r=rStopperHole-0.1, h=10+dFrameClip, $fn=60);
