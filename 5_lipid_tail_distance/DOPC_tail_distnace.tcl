# DOPC_tail_distances.tcl
# Calculate distance between terminal tail carbons (C218 and C318)
# of DOPC lipids that are within 4 Å of AuNP

## Remove intial pdb and pqr files from loaded trajectory
animate delete beg 0 end 0

# ---------------- Parameters ----------------
set cutoff 4.0                   ;# Å cutoff to AuNP
set ps_per_frame 10.0            ;# Simulation timestep in ps
set nframes [molinfo top get numframes]
set outfile "DOPC_tail_distances.dat"
# --------------------------------------------

set out [open $outfile w]
puts $out "# Time_ps\tResid\tDistance_A"

# Loop over all frames
for {set i 0} {$i < $nframes} {incr i} {
    molinfo top set frame $i
    set time_ps [expr {$i * $ps_per_frame}]

    # --- Step 1: select DOPCs in contact with AuNP ---
    set contact [atomselect top "(resname DOPC and pbwithin $cutoff of resname AUM)" frame $i]
    set residList [lsort -unique [$contact get resid]]
    
    $contact delete

    # Make unique lipid IDs (resid:segname)
    #set lipidIDs {}
    #foreach r $residList s $segList {
     #   lappend lipidIDs "$r:$s"
    #}
    #set lipidIDs [lsort -unique $lipidIDs]

    # --- Step 2: For each lipid, compute distance between C218 and C318 ---
   foreach resid $residList {
        set sel1 [atomselect top "resname DOPC and resid $resid and name C218" frame $i]
        set sel2 [atomselect top "resname DOPC and resid $resid and name C318" frame $i]

        if {[$sel1 num] == 1 && [$sel2 num] == 1} {
            set pos1 [lindex [$sel1 get {x y z}] 0]
            set pos2 [lindex [$sel2 get {x y z}] 0]
            set d [vecdist $pos1 $pos2]
            puts $out "$time_ps\t$resid\t$d"
        }

        $sel1 delete
        $sel2 delete
    }
    flush $out
}

close $out
puts "Done. Output written to $outfile"

