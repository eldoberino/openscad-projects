// use this file using the following statement:
// include <../dopOpenScadHelpers.scad>

runTests = false;

function tail(vector) =
    1 >= len(vector) ? [] : [ for (i = [1 : len(vector)-1]) vector[i] ];

function _splitRestOfStringBySpace(resultArraySoFar, currentString, string) = 
    0 == len(string) ?
    concat(resultArraySoFar,[currentString]) :
    " " == string[0] ?
        _splitRestOfStringBySpace(concat(resultArraySoFar, [currentString]), "", tail(string)) :
        _splitRestOfStringBySpace(resultArraySoFar, str(currentString,string[0]), tail(string)) ;

function splitStringBySpace(string) = _splitRestOfStringBySpace([],"",string);

if (runTests) {
    echo(tailTest1=[]==tail([[0,0]]));
    echo(tailTest2=[[1,1]]==tail([[0,0],[1,1]]));
    echo(testSpaceSplitsStringIntoArray=["on","three", "lines"]==splitStringBySpace("on three lines"));
}

function relativeStepsToAbsoluteCoordinates(positionsSoFar, remainingSteps) = 
    0 == len(remainingSteps) ?
    positionsSoFar :
    relativeStepsToAbsoluteCoordinates(
        concat(positionsSoFar,
            [ [positionsSoFar[len(positionsSoFar)-1][0] + remainingSteps[0][0]*cos(remainingSteps[0][1]),
              positionsSoFar[len(positionsSoFar)-1][1] + remainingSteps[0][0]*sin(remainingSteps[0][1])] ]),
        tail(remainingSteps) );

if (runTests) {
    echo(relativeStepsToAbsoluteCoordinatesTest1=[[0, 0], [10, 0]]==relativeStepsToAbsoluteCoordinates([[0,0]], [[10,0]]));
    echo(relativeStepsToAbsoluteCoordinatesTest2=relativeStepsToAbsoluteCoordinates([[0,0]], [[10,0],[10,60]]));
    echo(relativeStepsToAbsoluteCoordinatesTest3=relativeStepsToAbsoluteCoordinates([[0,0]], [[10, 0], [10, 60], [10, 120], [10, 180], [10, 240], [10, 300]]));
}


function _angleNormalized(angle) = ((angle % 360)+360)%360;

/// helper function to avoid problem when rotating figures that
// e.g. union() {rotate([0,0,30])square([9,9,9]); rotate([0,0,-30])square([9,9,9]);} is not symmetrical across the expected axes
// -> mirror() plus adapted angle helps: union() {rotate([0,0,30])square([9,9,9]); mirror([1,0,0])rotate([0,0,30])square([9,9,9]);}
// angle [0..180[ -> returns [angle, 0] (i.e. no mirroring)
// angle ]180..360[ -> returns [360-angle, 1) (i.e. mirroring)
function newAngleMirrorFromAngle(angle) =
    [_angleNormalized(angle) > 180 ? 360 - _angleNormalized(angle) : angle, _angleNormalized(angle)>180 ? 1 : 0];

if (runTests) {
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(30)==[30,0]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(360+30)==[390,0]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(150)==[150,0]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(360+150)==[510,0]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(190)==[360-190,1]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(720+190)==[360-190,1]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(-60)==[60,1]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(360-60)==[60,1]);
    echo(newAngleMirrorFromAngleTest=newAngleMirrorFromAngle(-330)==[-330,0]);
}

module displayPolygon(directions, debug=false) {
    figure = relativeStepsToAbsoluteCoordinates([[0,0]], directions);
    // echo(directions=directions);
    if (debug) echo(figure=figure);
    polygon(figure);
}

module extractProfileWithThickness(directions, thickness) {
    echo("IMPLEMENT ME: see example in HolderPowerSupply.scad");
    echo("- example with simple form: HolderPowerSupply.scad, module form()");
    echo("- difficult with angles not factor of 90degrees -> see HousingCNCControl.scad, module housing()");
}

module extract2DFromModelAtHeight(stlFile, heightOfSlice) {
    projection()
    intersection() {
        translate([0,0,-heightOfSlice])import(stlFile);
        cube([1000,1000,1], center=true);
    }
}

module extract2DFromImageAtIntensityValue(imageFile, heightOfSlice, center=false) {
    projection()
    intersection() {
        translate([0,0,heightOfSlice])surface(imageFile, invert=true, center=center);
        cube([1000,1000,1], center=center);
    }
}

// according https://www.reddit.com/r/openscad/comments/3jwobs/line_feed_in_openscad_text/
module multiLine(lines, startPos, size){
  union(){
    for (i = [0 : len(lines)-1])
      translate([startPos[0] , startPos[1] + ((len(lines)-1)/2-i) * 1.5*size, 0 ]) text(lines[i], size=size, halign="center", valign="center");
  }
}

// ----------

function _max_nrOfColumns(wColumn, spaceBetweenColumns, wTotal) =
    ceil(wTotal/(wColumn+spaceBetweenColumns));

function _nrOfColumns(wColumn, spaceBetweenColumns, wTotal) =
    wTotal-0.19 < _max_nrOfColumns(wColumn, spaceBetweenColumns, wTotal)*wColumn+(_max_nrOfColumns(wColumn, spaceBetweenColumns, wTotal)-1)*spaceBetweenColumns ?
    _max_nrOfColumns(wColumn, spaceBetweenColumns, wTotal)-1 :
    _max_nrOfColumns(wColumn, spaceBetweenColumns, wTotal);

if (runTests) {
    echo(nrOfColumnsTest1=0==_nrOfColumns(2,1,2.0));
    echo(nrOfColumnsTest2=1==_nrOfColumns(2,1,2.2));
    echo(nrOfColumnsTest3=1==_nrOfColumns(2,1,5.1));
    echo(nrOfColumnsTest4=2==_nrOfColumns(2,1,5.2));
    echo(nrOfColumnsTest5=2==_nrOfColumns(2,1,8.1));
    echo(nrOfColumnsTest6=3==_nrOfColumns(2,1,8.2));
    echo(nrOfColumnsTest7=4==_nrOfColumns(2,1,13));
}

module supportColumns(dimensions, debug=false) {
    wColumn=2;
    spaceBetweenColumns=wColumn;
    dColumn=0.1;

    nrOfColumns=_nrOfColumns(wColumn, spaceBetweenColumns, dimensions[0]);
    initialOffset=(dimensions[0]-nrOfColumns*wColumn-(nrOfColumns-1)*spaceBetweenColumns)/2;
    if (debug) {
        echo(nrOfColumns=nrOfColumns);
        echo(initialOffset=initialOffset);
    }
    for (x=[initialOffset:wColumn+spaceBetweenColumns:dimensions[0]-initialOffset]) {
        translate([x,spaceBetweenColumns,0])difference() {
            cube([wColumn, dimensions[1]-2*spaceBetweenColumns, dimensions[2]]);
            translate([dColumn,0,0])cube([wColumn-2*dColumn, dimensions[1]-2*spaceBetweenColumns-dColumn,dimensions[2]]);
        }
    }
}
