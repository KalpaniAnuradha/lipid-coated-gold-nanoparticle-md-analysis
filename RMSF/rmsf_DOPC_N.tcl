package require pbctools

## Remove intial pdb and pqr files from loaded trajectory if necessary
animate delete beg 0 end 0

## Make sure you wrap and align to the AuNP
#pbc wrap -centersel "resname AUM" -center com -compound residue -all

## Selections
echo "Selections:"
set selection1 [atomselect top "resname DOPC and name N"]
echo [$selection1 list]
echo "Atoms in selection 1:"
set selection1num [$selection1 num]
## Create output file
set output [open "RMSF_DOPC_N.dat" w]

## Calculate RMSF
set rmsf [lindex [measure rmsf $selection1 first 1 last 1000 step 1]]

foreach i $rmsf { puts $output "$i" }

close $output
exit 0

