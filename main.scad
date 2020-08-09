include <lib/Round-Anything/polyround.scad>

radiusExtrudefn=5;
$fn=30;

poleBraceHeight = 70;
poleBraceIR = 18;
braceThickness = 10;

armLength = 180;
armThickness=15;
boltD=3.5;
boltHeadD=6.3;
captureNutDepth=2.5;

cameraMountHoleD=6.5;
cameraMountClearance=36;
cameraMountThickness=8;
cameraMountPlatformSize=46;

wingGap=6;
wingThickness=8;
wingExtension=8;

function braceProfile(extension=0,edgeRadius=2)=translateRadiiPoints(
  mirrorPoints(
    [
      [poleBraceIR + 0,                                   poleBraceHeight/2,                                2],
      [poleBraceIR + braceThickness + extension,          poleBraceHeight/2,                                edgeRadius],
      [poleBraceIR + braceThickness + extension,          poleBraceHeight/2-braceThickness,                 10],
      [poleBraceIR + 0,                                   0,                                          (poleBraceHeight-braceThickness*2)],
    ], 0, [0,1]),
  [0,poleBraceHeight/2]
);


main();

module fasteningWings() {
  difference(){
    translate([-(wingThickness*2+wingGap)/2,0,0])
      rotate([90,0,90])
        linear_extrude(wingThickness*2+wingGap)
          polygon(polyRound(braceProfile(wingExtension,6),$fn));
  for(verticalholdDisplace = [wingExtension/1.5, poleBraceHeight-wingExtension/1.5])translate([
      0,
      poleBraceIR + braceThickness + wingExtension/3,
      verticalholdDisplace
    ]){
      translate([-100,0,0])rotate([30,0,0])rotate([0,90,0])
        cylinder(h=200, d=boltD,$fn=30);
      translate([-50-wingGap/2-wingThickness+captureNutDepth,0,0])rotate([30,0,0])rotate([0,90,0])
        cylinder(h=50, d=boltHeadD,$fn=6);
    }

  }
}

module truss() {
  translate([armThickness/2,0,0])rotate([90,0,0])
    rotate([0,-90,0])
      extrudeWithRadius(armThickness,2,2,radiusExtrudefn)shell2d(-8,minIR=3){
        polygon(polyRound([
          [0,0,0],
          [armLength-cameraMountClearance*0.4, 0, 0],
          [0, poleBraceHeight,0]
        ], $fn));
        scale([1,1.5,1])translate([armLength/3, poleBraceHeight/3])gridpattern();
      }
}

module cameraMount(){
  translate([0,-armLength,0])rotate([0,0,90])
    extrudeWithRadius(cameraMountThickness,2,0,radiusExtrudefn)difference(){      
    translate([-cameraMountClearance/2,0])polygon(polyRound(
      mirrorPoints(
        [
          [cameraMountClearance*3,     armThickness/2,              0],
          [cameraMountClearance*2,     armThickness/2,              50],
          [cameraMountPlatformSize/2,  cameraMountPlatformSize/2,   40],
          [-5,                          cameraMountPlatformSize/2,   15],
      ]
    ), $fn));
    circle(d=6.5);
  }
}

module poleBrace() {
  rotate_extrude(angle = 360, convexity = 2)
    polygon(polyRound(braceProfile(), $fn));
}

module main() {
  difference(){
    union(){
      fasteningWings();
      translate([0,-poleBraceIR-braceThickness/3,0]){
        truss();
        cameraMount();
      }
      poleBrace();
    }
    translate([0,250,0])cube([wingGap,500,500],center=true);
  }
}

module gridpattern(memberW = 3, sqW = 20, iter = 12, r = 3){
    round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}