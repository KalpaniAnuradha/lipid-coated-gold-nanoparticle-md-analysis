# Load PBC tools and wrap trajectory
#package require pbctools


pbc join connected -all
pbc wrap -centersel "resname AUM" -center com -compound residue -all

# Remove first frame if needed
animate delete beg 0 end 0

# Parameters
set cutoff 4.0
set ps_per_frame 10.0   ;# <-- Change this to your simulation time step in ps
set n [molinfo top get numframes]
set output [open "DOPC_count.dat" w]

# Loop over all frames
for {set i 0} {$i < $n} {incr i} {
    molinfo top set frame $i

    # Get selection of AUM atomsi
    set selAUM [atomselect top "resname AUM" frame $i]

    # Get all DOPC atoms within 4 Å of AUM
    set nearDOPC_atoms [atomselect top "(same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM))" frame $i]

    # Get unique resid–segname pairs to represent individual DOPC molecules
    set resids [$nearDOPC_atoms get resid]
    set segn [$nearDOPC_atoms get segname]

    set molecule_ids {}
    foreach r $resids s $segn {
        lappend molecule_ids "$r:$s"
    }
    set unique_molecules [lsort -unique $molecule_ids]
    set count [llength $unique_molecules]

    # Time in ps
    set time_ps [expr {$i * $ps_per_frame}]
    puts "Frame $i (Time: $time_ps ps): $count DOPC molecules"
    puts $output "$time_ps $count"

    # Cleanup
    $selAUM delete
    $nearDOPC_atoms delete
}

close $output
puts "Done. Output written to DOPC_count.dat"
exit 0

