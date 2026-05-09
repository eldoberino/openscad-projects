Battery Carousel

This is a simple electro-mechanical mechanism to switch between
multiple batteries (a.k.a a battery of batteries :-)).
With some external electronics & sw it switches from one battery to
a neighbouring one without interruption.

Note: during the handover from one battery to the next, the 2 batteries
are connected for ca. 0.5secs, so there's current flowing from the full
battery to the almost empty battery. Don't use this approach if you
don't feel comfortable about this and use a proper power electronics board
instead.


The design is made for the following components:
- servo motor with dimensions 22.5mm x 12mm x 8.5mm, e.g. "Micro Servo 99 SG90".
  A standard servo's rotation range is limited to 90..180°.
  In order for the servo to rotate 360° I modified it as follows:
  replace its 5kOhm potentiometer with fixed resistors (2.7kOhm & 2.2kOhm).
  See online for instructions how to do this.
- 3 micro switches with dimensions 20mm x 10mm x 6mm

See here for results: https://www.thingiverse.com/thing:7268332

See here for instructions regarding electronics & software: https://github.com/eldoberino/battery_carousel
