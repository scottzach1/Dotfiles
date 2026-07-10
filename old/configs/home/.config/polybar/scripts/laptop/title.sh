#!/bin/fish

set title (xtitle $eval(bspc query -N -n))
set length (echo $xtitle | wc -m)

if echo $length -lt 50
	echo $title
else
	echo (echo $title | head -c50)..
end
