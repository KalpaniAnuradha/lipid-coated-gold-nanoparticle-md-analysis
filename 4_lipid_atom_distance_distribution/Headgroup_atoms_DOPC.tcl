# Remove first frame if needed
animate delete beg 0 end 0

# Parameters
set cutoffs {4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0 20.5 21.0 21.5 22.0 22.5 23.0 23.5 24.0 24.5 25.0 25.5 26.0 26.5 27.0 27.5 28.0 28.5 29.0 29.5 30.0}  
set ps_per_frame 10.0       ;# Simulation timestep in ps
set n [molinfo top get numframes]

# Open output files
set outN [open "Headgroup_N.dat" w]
set outP [open "Headgroup_P.dat" w]

# Write headers
puts $outN "# Time_ps [join $cutoffs "\t"]"
puts $outP "# Time_ps [join $cutoffs "\t"]"

# Loop over all frames
for {set i 0} {$i < $n} {incr i} {
    molinfo top set frame $i
    set time_ps [expr {$i * $ps_per_frame}]

    set rowN "$time_ps"
    set rowP "$time_ps"

    # --- Step 1: Select only lipids within 4 Å of Au ---
    set contact [atomselect top "(resname DOPC and pbwithin 4.0 of resname AUM)" frame $i]
    set residList [$contact get resid]
    set segList   [$contact get segname]
    $contact delete

    # Make a list of unique lipid identifiers
    set lipidIDs {}
    foreach r $residList s $segList {
        lappend lipidIDs "$r:$s"
    }
    set lipidIDs [lsort -unique $lipidIDs]

    # --- Step 2: Count headgroup atoms of only these lipids ---
    foreach c $cutoffs {
        # Build selection string for the "contact lipids only"
        set selN [atomselect top "(resname DOPC and element N and pbwithin $c of resname AUM)" frame $i]
        set selP [atomselect top "(resname DOPC and name P and pbwithin $c of resname AUM)" frame $i]

        # Filter only atoms from the identified lipids
        set keepN {}
        foreach rid [$selN get resid] seg [$selN get segname] {
            if {"$rid:$seg" in $lipidIDs} {
                lappend keepN 1
            }
        }
        set countN [llength $keepN]

        set keepP {}
        foreach rid [$selP get resid] seg [$selP get segname] {
            if {"$rid:$seg" in $lipidIDs} {
                lappend keepP 1
            }
        }
        set countP [llength $keepP]

        # Append counts to rows
        append rowN "\t$countN"
        append rowP "\t$countP"

        # Cleanup
        $selN delete
        $selP delete
    }

    # Write to files
    puts $outN $rowN
    puts $outP $rowP
}

# Close files
close $outN
close $outP

puts "Done. Outputs written to Headgroup_N.dat, Headgroup_P.dat"
exit 0

