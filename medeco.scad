
$fn=100;

function mm(i) = i*25.4;

module bow(bow_length, bow_width, bow_thickness)
{
  cube([bow_length, bow_width, bow_thickness]);
}

module bit()
{
	w = mm(.15);
	difference()
	{
		translate([-(mm(1/4))/2, 0, -(mm(1/4))/2]) cube([mm(1/4), mm(1), 2*w]);
		translate([-mm(4/512)+0.007, 0, -w]) rotate([0, 0, 133]) cube([w*2, w*2, 3*w]);
		translate([mm(4/512)-0.008, 0, -w]) rotate([0, 0, -43]) cube([w, w*2, 3*w]);
	}
}

module blade(blade_length, blade_width, blade_thickness, key_cuts, key_cut_angle, key_cut_spacing, shoulder, cut_spacing, cut_depth)
{


	difference()
	{
    union() {
        translate([0,-0.4,0]) cube([shoulder, mm(3/8) +0.4 , mm(.125)]);
        cube([blade_length + shoulder, blade_width, blade_thickness]);
    }


		//Contour

		translate([blade_length + shoulder, mm(1/8), 0]) {
			rotate([0, 0, 43]) cube([10, 10, blade_thickness]);
		}
    translate([blade_length + shoulder, mm(1/16), 0]) {
			rotate([0, 0, 220]) cube([10, 10, blade_thickness]);
		}

		//Cut the key channels
		//translate([0, mm(.035), 0]) rotate([0, 90, 0]) cylinder(h = blade_length + .01  + shoulder , r = mm(.03));
		//translate([0, mm(.1), 0]) rotate([0, 90, 0]) cylinder(h = blade_length+ .01, r = mm(.03));
		//translate([0, mm(.05), blade_thickness]) rotate([0, 90, 0]) cylinder(h = blade_length + .01, r = mm(.035));

		//translate([0, blade_width - (7 * cut_depth), 0]) cube([blade_length, 7 * cut_depth, blade_thickness/4]);
		//translate([0, blade_width - (7 * cut_depth), (3*blade_thickness)/4]) cube([blade_length, 7 * cut_depth, blade_thickness/4]);

		//Cut the blade
		for (counter = [0:5])
		{
      translate([ shoulder + mm(0.244) + cut_spacing*counter + key_cut_spacing[counter] * mm(0.031), blade_width - (key_cuts[counter]) * cut_depth + 0.000125, 0]) rotate ([0, key_cut_angle[counter] * 20, 0]) bit();
		}

	}

}

module biaxial(key_cuts, key_cut_angle, key_cut_spacing)
{
	blade_length = mm(1.3125);
	blade_width = mm(0.296875 );
	blade_thickness = mm(0.09375);

	shoulder = mm(0.3125);
	cut_spacing = mm(.17);
	cut_depth = mm(.025);

	bow_length = mm(1.09375);
	bow_width = mm(1.09375);
	bow_thickness = mm(.125);

	difference()
	{
		union()
		{
			bow(bow_length, bow_width, bow_thickness);
      translate([bow_length, bow_width - blade_width - 11, 0]) blade(blade_length, blade_width, blade_thickness, key_cuts, key_cut_angle, key_cut_spacing, shoulder, cut_spacing, cut_depth);
      translate([mm(1.09375 + 0.3125), bow_width - blade_width - 11, mm(0.09375)]) cube([mm(0.3125), mm(0.0625), mm(0.03125)]);
		}

      //translate([mm(1.921875), bow_width - blade_width - 11 ,mm(0.09375)]) cube([mm(0.796875), mm(0.09375),mm(0.3125)]);
      translate([mm(1.921875), bow_width - blade_width - 11 ,mm(0.0625)]) cube([mm(0.796875), mm(0.09375),mm(0.3125)]);
        
      //translate([mm(1.921875), bow_width - blade_width - 11 - mm(0.06) ,mm(0.0625)]) cube([mm(0.90), mm(0.09375) + mm(0.06),mm(0.5)]);
        
        
      // translate([mm(1.921875), bow_width - blade_width - 11 + mm(0.0625)  , mm(0.0625)]) cylinder(mm(0.15625/2), mm(0.0234375), true);
      //translate([mm(1.921875), bow_width - blade_width - 11 + mm(0.0625)  , mm(0.0625)]) cylinder(mm(0.15625/2), mm(0.0234375), true);
    }


}

//Angles -1 = -20 0 = 0 1 = 20
//Cut spacing -1 = aft 0 = center 1 = fore

//current pin 
biaxial([3, 2, 4, 3, 4, 3], [0, 1, 1, 1, 1, 0], [1, -1, -1, 1, -1, 1]);
