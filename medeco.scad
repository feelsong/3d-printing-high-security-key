
$fn=100;

// This converts inches to millimeters
function mm(i) = i*25.4;

// The handle of the key. Doesn't do much aside from help turn the key.
module bow(bow_length, bow_width, bow_thickness)
{
	// Creates the hole in the "box"
	difference() {
		// Creates the big "box"
		cube([bow_length, bow_width, bow_thickness]);
		// Cuts out the round hole in it
		translate([mm(0.2), mm(0.2), 0]) cylinder(mm(.5), mm(.1));
  }
}

// A single bit ( I think )
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

// Calculates most things for the blade
module blade(blade_length, blade_width, blade_thickness, key_cuts, key_cut_angle, key_cut_spacing, shoulder, cut_spacing, cut_depth)
{
	// The first item in this is the starting block. All subsequent items get subtracted from the first one.
	difference()
	{
		// Makes the blade, basically a squared off rectangle at this point.
		// Also has the groove for the (slider?).
		union() {
			translate([0, -0.4, 0]) cube([shoulder, mm(3/8) +0.4 , mm(.125)]);
			cube([blade_length + shoulder, blade_width, blade_thickness]);
		}
		
		// This cuts out part of the blade's tip top part to make it slanted.
		translate([blade_length + shoulder, mm(1/8), 0]) { rotate([0, 0, 43]) cube([10, 10, blade_thickness]); }
		// This cuts out part of the blade's tip bottom part to make it slanted.
		translate([blade_length + shoulder, mm(1/16), 0]) { rotate([0, 0, 220]) cube([10, 10, blade_thickness]); }
		
		//Side mill
		// - The eagle side
        // These control how deep the grooves go.
        // "Tip: The end of the key opposite of the bow. Some locks use the tip of the key to align cuts instead of the shoulder." http://www.lockwiki.com/index.php/Key
		tip = 0.8;
		tip2 = 0.3;
		tip3 = 0.4;
		
		// (left side is relative from looking at the key from the perspective of the lock)
		// These three cut out grooves on the side of the key on the left side
		translate([shoulder, 3.0988 , blade_thickness - tip]) cube([blade_length + 0.2, 0.7022, 1]);
		translate([shoulder, 5.0038 , blade_thickness - tip]) cube([blade_length + 0.2, 0.6604, 1]);
		// This one is for the top part.
		translate([shoulder, 6.1468 , blade_thickness - tip2]) cube([blade_length + 0.2, 1.65, 1]);
		
		
		// - The Non-eagle side
		// (right side is relative from looking at the key from the perspective of the lock)
		// These ones are for right side of the key.
		translate([shoulder, 0.7366, tip - 1]) cube([blade_length + 0.2, 1 , 1]);
		translate([shoulder, 2.9464, tip - 1]) cube([blade_length + 0.2, 1 , 1]);
		translate([shoulder, 4.8514, tip - 1]) cube([blade_length + 0.2, 0.9, 1]);
		translate([shoulder, 6.9342, tip3 - 1]) cube([blade_length + 0.2, 0.7366, 1]);

		// Cuts the bits in the blade. Also does the biaxial rotation.
		for (counter = [0:5])
		{
			translate([ shoulder + mm(0.244) + cut_spacing*counter + key_cut_spacing[counter] * mm(0.031), blade_width - (key_cuts[counter]) * cut_depth + 0.000125, blade_thickness/2])
			rotate ([0, key_cut_angle[counter] * 20, 0])
			bit();
		}
	}
}


module biaxial(key_cuts, key_cut_angle, key_cut_spacing)
{   
	blade_length = mm(1.3125);
	blade_width = mm(0.296875);
	blade_thickness = mm(0.09375);

	// The shoulder is the part of the key that connects to the bow of the blade.
	shoulder = mm(0.3125);
	cut_spacing = mm(.17);
	cut_depth = mm(.025);

	bow_length = mm(1.09375);
	bow_width = mm(1.09375);
	bow_thickness = mm(.125);
	
	//from origin to the bottom of the blade
	blade_starting = 11;
	
	//first difference on eagle side
	dip = 2.1336;

	difference()
	{
		union()
		{
			// Draw the bow
			bow(bow_length, bow_width, bow_thickness);
			translate([bow_length, bow_width - blade_width - blade_starting, 0])
			
			// Draw the blade
			blade(blade_length, blade_width, blade_thickness, key_cuts, key_cut_angle, key_cut_spacing, shoulder, cut_spacing, cut_depth);
			translate([mm(1.09375 + 0.3125), bow_width - blade_width - blade_starting, mm(0.09375)]) cube([mm(0.3125), mm(0.0625), mm(0.03125)]);
		}

		translate([mm(1.921875), bow_width - blade_width - blade_starting - 0.5 ,mm(0.0625)]) cube([mm(0.796875) + 0.5, dip + 0.5, mm(0.3125) + 0.5]);
		translate([mm(1.921875) +mm(0.02) , bow_width - blade_width - 11 + mm(0.08)  , mm(0.0625)]) cylinder(mm(0.5), mm(0.0234375));
	}
}

// See this page to understand all of the lingo about fore / aft
// http://www.lockwiki.com/index.php/Medeco_Biaxial

//Angles:
//     -1 = -20
//      0 = 0
//      1 = 20


//Cut spacing:
//      aft = -1
//      center = 0
//      fore = 1


// Current pin
// These are ordered by cuts closest to the bow first.
//           Key Cuts          Key Cut Angle       Key Cut Spacing
biaxial([3, 2, 4, 3, 4, 3], [0, 1, 1, 1, 1, 0], [1, -1, -1, 1, -1, 1]);



// The original function call that came with this scad model:
// biaxial([3, 2, 4, 3, 4, 3], [0, 1, 1, 1, 1, 0], [1, -1, -1, 1, -1, 1]);
