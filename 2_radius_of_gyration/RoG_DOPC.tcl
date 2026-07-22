#package require pbctools
#pbc wrap -all

## Remove intial pdb and pqr files from loaded trajectory
animate delete beg 0 end 0

puts -nonewline "\n \t \t Selection: "


## Selections that don't update every frame
set cutoff 4.0
set n [molinfo top get numframes]

#create output files 
set output [open "RoG.dat" w]

## RoG calculation loop
for {set i 0} {$i < $n} {incr i} {
molinfo top set frame $i

## selections that need to update every frame
set loop [atomselect top "(same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM)) or resname AUM"]

#RoG Calculations
set R_o_G [measure rgyr $loop weight mass]
puts "\t \t progress: $i/$n"
puts $output "$R_o_G"
}

puts "\t \t progress: $n/$n"
puts "Done."
puts "output file: RoG.dat"
close $output
#exit 0

