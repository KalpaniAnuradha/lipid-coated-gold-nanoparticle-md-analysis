#package require pbctools
#pbc wrap -centersel "resname AUM" -center com -compound residue -all

## Remove intial pdb and pqr files from loaded trajectory
animate delete beg 0 end 0

## sasa_complex
puts -nonewline "\n \t \t Selection: "

## Selections that don't update every frame
set cutoff 4.0
set P 1.4
set s 500
set n [molinfo top get numframes]
set A [atomselect top "resname AUM"]

## Create output files
set outputCA [open "sasa_contact_area.dat" w]
set outputA [open "sasa_AUM.dat" w]
set outputB [open "sasa_DOPC.dat" w]
set outputS [open "sasa_AUM+DOPC.dat" w]

## SASA calculation loop
for {set i 0} {$i < $n} {incr i} {
molinfo top set frame $i

## Selections that need to update every frame
set sel [atomselect top "resname AUM or (same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM))" frame $i]
set B [atomselect top "(same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM))" frame $i"]

## SASA calculations
set sasaCA [expr {([measure sasa $P $A -samples $s] + [measure sasa $P $B -samples $s] - [measure sasa $P $sel -samples $s]) * 0.5}]
set sasaA [measure sasa $P $A -samples $s]
set sasaB [measure sasa $P $B -samples $s]
set sasaS [measure sasa $P $sel -samples $s]
puts "\t \t progress: $i/$n"
puts $outputCA "$sasaCA"
puts $outputA "$sasaA"
puts $outputB "$sasaB"
puts $outputS "$sasaS"
}

## Final steps
puts "\t \t progress: $n/$n"
puts "Done."
puts "outputCA file: sasa_contact_area.dat"
puts "outputA file: sasa_AUM.dat"
puts "outputB file: sasa_DOPC.dat"
puts "outputS file: sasa_AUM+DOPC.dat"
close $outputCA
close $outputA
close $outputB
close $outputS
#exit 0

