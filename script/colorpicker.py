#!/usr/bin/python

import sys
from gi.repository import Gtk
from gi.repository import Gdk

picker = Gtk.ColorSelectionDialog("Color Picker")

if len(sys.argv) >= 2:
    color = Gdk.color_parse(sys.argv[1])
    if color:
        picker.get_color_selection().set_current_color(color)

if picker.run() == getattr(Gtk, 'RESPONSE_OK', Gtk.ResponseType.OK):
    color = picker.get_color_selection().get_current_color()
    r, g, b = [int(c / 256) for c in [color.red, color.green, color.blue]]
    print("#{:02x}{:02x}{:02x}".format(r, g, b).upper())

picker.destroy()
