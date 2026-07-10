#!/bin/fish

set title (xtitle $eval(bspc query -N -n))
set count (echo $title | wc -m)

if "$count" -lt 50
	echo true
else
	echo false
end
