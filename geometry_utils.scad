include <list_utils.scad>

include <round_anything/polyround.scad>

/// allowed formats for segment:
// [h, r],
// [h, r1, r2],
// [h, r1, r2, $fn]
module tube(segments) {

     function prepend_segment_start_height(remaining_segments, accumulated = 0) = let(l = len(remaining_segments))
        l == 1 ? 
            prepend(remaining_segments[0], accumulated) : 
            [ prepend(remaining_segments[0], accumulated), 
                prepend_segment_start_height(subrange_i(remaining_segments, 1, l-1), accumulated + remaining_segments[0][0])
            ];
    //echo(segments);
    height_offset = 0.01;
    s = prepend_segment_start_height(segments);
    //echo(s);
    for(segment = s) {
     l = len(segment) - 1;
     assert(l >=2 && l <= 6, "Segment is of invalid length");
     start_height = segment[0] - height_offset;
     
     translate([0,0, start_height]) {
         if(l == 2)      cylinder(h=segment[1]+height_offset, r=segment[2]);
         else if(l == 3) cylinder(h=segment[1]+height_offset, r1=segment[3], r2=segment[2]);
         else if(l == 4) cylinder(h=segment[1]+height_offset, r1=segment[3], r2=segment[2], $fn=segment[4]);
     }
    } 
}

/// allowed formats for segment:
// [h, r],
// [h, r, $fn],
// [h, [r1, r2]],
// [h, [r1, r2], $fn]
module tube2(segments) {

     function prepend_segment_start_height(remaining_segments, accumulated = 0) = let(l = len(remaining_segments))
        l == 1 ? 
            prepend(remaining_segments[0], accumulated) : 
            [ prepend(remaining_segments[0], accumulated), 
                prepend_segment_start_height(subrange_i(remaining_segments, 1, l-1), accumulated + remaining_segments[0][0])
            ];
    //echo(segments);
    height_offset = 0.01;
    s = prepend_segment_start_height(segments);
    echo(s);
    for(segment = s) {
     l = len(segment) - 1;
     assert(l >=2 && l <= 6, "Segment is of invalid length");
     start_height = segment[0] - height_offset;
     
     translate([0,0, start_height]) {
         if(l == 2)      cylinder(h=segment[1]+height_offset, r=segment[2]);
         else if(l == 3) cylinder(h=segment[1]+height_offset, r1=segment[3], r2=segment[2]);
         else if(l == 4) cylinder(h=segment[1]+height_offset, r1=segment[3], r2=segment[2], $fn=segment[4]);
     }
    } 
}

//tube2([[10,10], [10,10]]);


// diameter should not contain any tolerance. If your screw is M3, put 3 in there
module screw_cutout(screw_diameter, length, tolerance=0.15) {
       
    difference() {
        cylinder(length, d=screw_diameter+tolerance, $fn=12);
        
        
        
        translate([screw_diameter-1.5*tolerance,0,-0.1]) tube(
            [    
                [length-1, (screw_diameter+tolerance)/2, (screw_diameter+tolerance)/2, 12],
                [1.2, (screw_diameter-4*tolerance)/2, (screw_diameter+tolerance)/2, 12]
            ]
        );
        rotate([0,0,120]) translate([screw_diameter-1.5*tolerance,0,-0.1]) tube(
            [    
                [length-1, (screw_diameter+tolerance)/2, (screw_diameter+tolerance)/2, 12],
                [1.2, (screw_diameter-4*tolerance)/2, (screw_diameter+tolerance)/2, 12]
            ]
        );
        rotate([0,0,240]) translate([screw_diameter-1.5*tolerance,0,-0.1]) tube(
            [    
                [length-1, (screw_diameter+tolerance)/2, (screw_diameter+tolerance)/2, 12],
                [1.2, (screw_diameter-4*tolerance)/2, (screw_diameter+tolerance)/2, 12]
            ]
        );
    }
}

module rcube(dims, chamfer_xy = 0.0, chamfer_xz = 0.0) {
   
    polyRoundExtrude(
    [
        [0,0,chamfer_xy],
        [dims.x,0,chamfer_xy],
        [dims.x,dims.y,chamfer_xy],
        [0,dims.y,chamfer_xy],
    ],
    dims.z,
    chamfer_xz,
    chamfer_xz
    );
}
//difference() {
//    cube([10,10,10]);
//    translate([5,5,-0.05]) screw_cutout(3, 10.1);
//    
//}