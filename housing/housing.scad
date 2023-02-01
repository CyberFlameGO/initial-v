BOX_X = 81;
BOX_Y = 101;
BOX_Z = 95;
TOP_WALL = 2;
BOTTOM_WALL = 2;
WALL = 3;
JACK_X = 9.5;
JACK_Y = 8;
JACK_Z = 11;
JACK_FROM_RIGHT = 6;
TAB_LENGTH = 16;
TAB_Z = 14;

POST_DIAMETER = 6;
POST_OUTER_DIAMETER = 14;
FRONT_TAB_Y = POST_OUTER_DIAMETER;
FRONT_TAB_X = POST_OUTER_DIAMETER + 1;
REAR_TAB_X = POST_OUTER_DIAMETER;
FRONT_TAB_Z_SHIFT = 63.3;

REAR_TAB_Y = 16;

REAR_BOX_Y = TAB_LENGTH - (POST_OUTER_DIAMETER / 2) - WALL;

SUCTION_X = 14;
SUCTION_Y = SUCTION_X + 2;

// NEGATIVE SPACE

module ShifterRing() {
  translate([BOX_X / 2, BOX_Y / 2, BOX_Z])
  translate([-5, 6, -1])
    linear_extrude(5)
    rotate([0, 0, -16])
    rotate([0, 180, 0])
    //import("path413.svg", center=true, dpi=94.5);
    import("handle.svg", center=true, dpi=24.6);
}

module RearTab() {
  rear_tab_z = 6;
  rear_tab_y = 19;
  rear_tab_x = 14;
  rear_tab_top = 42;
  translate([(BOX_X / 2) - (rear_tab_x / 2), -rear_tab_y, rear_tab_top - rear_tab_z])
    cube([rear_tab_x, rear_tab_y, rear_tab_z]);
}

module FrontLeftBump() {
  x = 16.5;
  y = 2;
  z = 51;
  // Front left bar thing
  translate([0, BOX_Y - 0.1, 0])
    cube([x, y + 0.1, z]);
}

module MainBox() {
  cube([BOX_X, BOX_Y, BOX_Z]);
}

module FrontTopJunk() {
  x = 31;
  z = 21;
  y = WALL + 3;

  translate([28, BOX_Y - 0.1, BOX_Z - z - 8])
    cube([x, y + 0.1, z]);
}

module PowerJack() {
  x_shift = BOX_X - JACK_X - JACK_FROM_RIGHT;
  z_shift = 6;
  translate([x_shift, BOX_Y - 0.1, z_shift])
    cube([JACK_X, JACK_Y + 0.1, JACK_Z]);
}

module ProgAccess() {
  x = 11;
  y = 3;
  z = BOTTOM_WALL + 2;
  y_shift = BOX_Y - (FRONT_TAB_X / 2);
  translate([BOX_X - x - JACK_X - JACK_FROM_RIGHT, y_shift, -z + 1])
    cube([x, y, z]);
}

module LeftSideBump() {
  x = 1.6;
  y = 22;
  z = 21;
  z_shift = 48;
  y_shift = 3.6;
  translate([-x, y_shift, z_shift])
  cube([x, y, z]);
}

module FrontMounts() {
  x = FRONT_TAB_X;
  y = FRONT_TAB_Y;
  z = TAB_Z;
  z_shift = FRONT_TAB_Z_SHIFT;

  translate([BOX_X / 2, (BOX_Y / 2) - (x / 2), z_shift - z])
    for (i = [0, 1]) {
      mirror([i, 0, 0])
        translate([(y / 2) + (BOX_X / 2), BOX_Y / 2, 0])
        rotate([0, 0, 90])
        translate([0, 0, z / 2])
        // Adding 2 to make rendering work
        cube([x, y + 2, z], center=true);
    }
}

module RearMounts() {
  x = POST_OUTER_DIAMETER;
  y = TAB_LENGTH;
  z = TAB_Z;

  z_shift = 65.3;

  jitter = 4; // for fixing rendering on x/z plane

  for(i = [0, BOX_X - x]) {
    translate([i, -(y + (jitter / 2)), z_shift - z])
      cube([x, y + jitter, z]);
  }
}

module Shifter() {
  MainBox();
  FrontLeftBump();
  RearTab();
  FrontTopJunk();
  PowerJack();
  LeftSideBump();
  FrontMounts();
  RearMounts();
  ShifterRing();
  RearBox();
  ProgAccess();
}

module RearBox() {
  x = BOX_X - (POST_OUTER_DIAMETER * 2);
  y = REAR_BOX_Y;
  z = BOX_Z;

  translate([(BOX_X / 2) - (x / 2), -y, 0])
  cube([x, y + 0.1, z]);
}

// POSITIVE SPACE

module FrontPost(height) {
  $fn = 80;
  post_outer_radius = POST_OUTER_DIAMETER / 2;
  base_difference = (FRONT_TAB_X - POST_OUTER_DIAMETER) / 2;
  y_offset = FRONT_TAB_Y - POST_OUTER_DIAMETER;

  translate([0, -FRONT_TAB_Y / 2, 0])
  difference() {
    linear_extrude(height)
      union() {
        translate([0, y_offset + POST_OUTER_DIAMETER / 2, 0])
          circle(d = POST_OUTER_DIAMETER);

        translate([-(FRONT_TAB_X / 2), 0, 0])
          polygon([ [0, 0],
                     [FRONT_TAB_X, 0],
                     [POST_OUTER_DIAMETER + base_difference, post_outer_radius + y_offset],
                     [base_difference, post_outer_radius + y_offset]
                  ]);
      }

    translate([0, y_offset + (POST_OUTER_DIAMETER / 2), -1])
    linear_extrude(height + 2)
      circle(d = POST_DIAMETER);
  }

}

module InnerBox(height) {
  translate([-WALL, -WALL, 0])
  cube([BOX_X + (WALL * 2), BOX_Y + (WALL * 2), height]);
}

module RearBoxContainer(height) {
  x = BOX_X - (POST_OUTER_DIAMETER * 2);
  y = REAR_BOX_Y + WALL;
  z = height;

  translate([(BOX_X / 2) - (x / 2), -y, 0])
  cube([x, y + 0.1, z]);
}

module OuterBox(height) {
  translate([-WALL, -(REAR_BOX_Y + WALL), 0])
    cube([BOX_X + (WALL * 2), BOX_Y + REAR_BOX_Y + (WALL * 2), height]);
}

module FrontPosts(height) {
  translate([BOX_X / 2, BOX_Y - FRONT_TAB_X, 0])
  for (i = [0, 1]) {
    mirror([i, 0, 0])
      translate([-BOX_X / 2, 0, 0])
      rotate([0, 0, 90])
      translate([FRONT_TAB_X / 2, FRONT_TAB_Y / 2, 0])
      FrontPost(height);
  }
}

module RearPost(height) {
  $fn = 80;
  diameter = POST_DIAMETER;

  outer_diameter = POST_OUTER_DIAMETER;
  outer_radius = outer_diameter / 2;

  length = (outer_diameter / 2) + (REAR_TAB_Y - outer_diameter);

  translate([0, (-outer_radius) + (REAR_TAB_Y / 2), 0])
  difference() {
    linear_extrude(height)
      union() {
        circle(d = outer_diameter);
        translate([-(outer_diameter / 2), -length])
          square([outer_diameter, length]);
      }

    translate([0, 0, -1])
    linear_extrude(height + 2)
      circle(d = diameter);
  }
}

module RearPosts(height) {
  for (i = [0, BOX_X - REAR_TAB_X]) {
    translate([(REAR_TAB_X / 2) + i, -REAR_TAB_Y / 2, 0])
      rotate([0, 0, 180])
      RearPost(height);
  }
}

module Container() {
  height = BOX_Z + TOP_WALL + BOTTOM_WALL;
  translate([0, 0, -BOTTOM_WALL]) {
    InnerBox(height);
    RearPosts(height);
    RearBoxContainer(height);
    FrontPosts(height);
    SuctionMounts();
  }
}

module PCBMount() {
  mount_width = 3.5;
  mount_height = 11;
  pcb_thickness = 1.8;
  wall = 2;

  translate([BOX_X, BOX_Y - (FRONT_TAB_X / 2), 0])
  translate([-mount_width, -((wall * 2) + pcb_thickness) / 2, 0]) {
    translate([0, pcb_thickness + wall, 0])
      cube([mount_width, wall, mount_height]);
    cube([mount_width, wall, mount_height]);
  }
}

module SuctionMount() {
  nut_depth = 4;
  suction_z = nut_depth + BOTTOM_WALL;

  top_shift = (SUCTION_X / 2) + (SUCTION_Y - SUCTION_X);

  translate([0, -top_shift + (SUCTION_Y / 2), 0])

  difference() {
    post_outer_radius = SUCTION_X / 2;
    union() {
      cylinder(suction_z, d=SUCTION_X, $fn=80);
      translate([-post_outer_radius, 0, 0])
        cube([SUCTION_X, top_shift, suction_z]);
    }
    translate([0, 0, suction_z - nut_depth])
      cylinder(nut_depth + 0.5, d=9.3, $fn=6);
    translate([0, 0, -0.5])
      cylinder(suction_z + 2, d=5.3, $fn=80);
  }
}

module SuctionMounts() {
  translate([BOX_X / 2, BOX_Y / 2, 0]) {
    translate([0, -REAR_BOX_Y / 2, 0])
      for (i = [0, 1]) {
        mirror([0, i, 0])
          translate([0, -(BOX_Y + REAR_BOX_Y) / 2, 0])
          translate([0, -SUCTION_Y / 2, 0])
          SuctionMount();
      }

    for (i = [0, 1]) {
      mirror([i, 0, 0])
        translate([(BOX_X / 2) + (SUCTION_Y / 2), 0, 0])
        rotate([0, 0, 90])
        SuctionMount();
    }
  }
}

module FullContainer() {
  difference() {
    Container();
    Shifter();
  }
  PCBMount();
}

module Mask() {
  mask_x = BOX_X + (FRONT_TAB_Y * 2) + 4;
  mask_y = BOX_Y + (REAR_TAB_X + (WALL * 2)) + 4;
  mask_z = BOX_Z + TOP_WALL + BOTTOM_WALL + 4;
  translate([-FRONT_TAB_Y - 2, -REAR_TAB_X - WALL - 2, -BOTTOM_WALL - 2])
    cube([mask_x, mask_y, mask_z]);
}

module BottomMask() {
  translate([-FRONT_TAB_Y - 2, -REAR_TAB_X - WALL - 2, -BOTTOM_WALL - 2])
    cube([mask_x, mask_y, mask_z]);
}

module TopPart() {
  difference() {
    FullContainer();
    BottomMask();
  }
}

module BottomTray() {
  difference() {
    FullContainer();
    translate([0, 0, JACK_Z + 6 + BOTTOM_WALL + 1.9])
    Mask();
  }
}

FullContainer();
//BottomTray();
