include <lib/Round-Anything/polyround.scad>

radiusExtrudefn=1;

poleBrace = 100;
poleBraceIR = 30;
braceThiccness = 15;

armLength = 200;
armThickness=15;
boltD=3.5;
boltHeadD=5;
captureNutDepth=2.5;

cameraMountHoleD=6.5;
cameraMountClearance=36;
cameraMountThickness=8;

wingGap=5;
wingThickness=8;
wingExtension=15;

function braceProfile(extension=0,edgeRadius=2)=[
    [poleBraceIR + 0,                                   0,                  2],
    [poleBraceIR + 0,                                   poleBrace,          2],
    [poleBraceIR + braceThiccness + extension,          poleBrace,          edgeRadius],
    [poleBraceIR + braceThiccness + extension,          poleBrace-braceThiccness,                 10],
    [poleBraceIR + 0,                                   poleBrace/2,                 (poleBrace-braceThiccness*2)*0.8],
    [poleBraceIR + braceThiccness + extension,          braceThiccness,     10],
    [poleBraceIR + braceThiccness + extension,          0,                  edgeRadius]];


main();

module fasteningWings() {
  difference(){
    translate([-(wingThickness*2+wingGap)/2,0,0])
      rotate([90,0,90])
        linear_extrude(wingThickness*2+wingGap)
          polygon(polyRound(braceProfile(wingExtension,6),20));
  for(verticalholdDisplace = [wingExtension/2, poleBrace-wingExtension/2])translate([
      0,
      poleBraceIR + braceThiccness + wingExtension/2,
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
          [0, poleBrace,0]
        ], 20));
        scale([1,1.5,1])translate([armLength/3, poleBrace/3])gridpattern();
      }
}

module cameraMount(){
  translate([0,-armLength,0])rotate([0,0,90])
    extrudeWithRadius(cameraMountThickness,2,0,radiusExtrudefn)difference(){
    translate([-cameraMountClearance/2,-cameraMountClearance/2])polygon(polyRound([
      [0,0,10],
      [cameraMountClearance, 0, 50],
      [cameraMountClearance*2, cameraMountClearance/2 - 15/2, 50],
      [cameraMountClearance*3, cameraMountClearance/2 - 15/2, 0],
      [cameraMountClearance*3, cameraMountClearance/2 + 15/2, 0],
      [cameraMountClearance*2, cameraMountClearance/2 + 15/2, 50],
      [cameraMountClearance, cameraMountClearance, 50],
      [0, cameraMountClearance, 10],
    ], 20));
    circle(d=6.5);
  }
}

module poleBrace() {
  rotate_extrude(angle = 360, convexity = 2)
    polygon(polyRound(braceProfile(), 20));
}

module main() {
  difference(){
    union(){
      fasteningWings();
      translate([0,-poleBraceIR-braceThiccness/3,0]){
        truss();
        cameraMount();
      }
      poleBrace();
    }
    translate([0,250,0])cube([wingGap,500,500],center=true);
  }
}

module gridpattern(memberW = 4, sqW = 20, iter = 6, r = 3){
    round2d(0, r)rotate([0, 0, 45])translate([-(iter * (sqW + memberW) + memberW) / 2, -(iter * (sqW + memberW) + memberW) / 2])difference(){
		square([(iter) * (sqW + memberW) + memberW, (iter) * (sqW + memberW) + memberW]);
		for (i = [0:iter - 1], j = [0:iter - 1]){
			translate([i * (sqW + memberW) + memberW, j * (sqW + memberW) + memberW])square([sqW, sqW]);
		}
	}
}