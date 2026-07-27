# Distance Between the Terminal Carbon Atoms of the Two Lipid Tails

## Description

This folder contains a representative DOPC example of the analysis used
to calculate the distance between the terminal carbon atoms of the two
acyl tails of lipids associated with a 5 nm gold nanoparticle.

For each trajectory frame, the script first identifies DOPC molecules
located within 4 Å of the AuNP surface. It then calculates the distance
between the terminal carbon atoms of the two acyl tails within each
selected DOPC molecule.

The calculation is performed separately for every selected lipid in
every frame of the loaded molecular dynamics trajectory.

The DOPC system is provided as a representative example. The same
analysis workflow was applied to the other lipid systems reported in
the associated publication.

## What does this analysis measure?

A phospholipid contains two hydrocarbon tails. The terminal carbon is
the final carbon atom at the end of each tail.

For DOPC, the terminal carbon atoms selected in this analysis are:

- `C218` – terminal carbon of one DOPC acyl tail
- `C318` – terminal carbon of the other DOPC acyl tail

The analysis measures the three-dimensional distance between these two
terminal carbon atoms within the same DOPC molecule.

The distance is calculated as:

```math
d =
\sqrt{
(x_{C218}-x_{C318})^2
+
(y_{C218}-y_{C318})^2
+
(z_{C218}-z_{C318})^2
}
```

where:

- \(x\), \(y\), and \(z\) are the coordinates of the selected terminal
  carbon atoms.
- \(d\) is the distance between `C218` and `C318`.
- The distance is reported in angstroms (Å).

A smaller distance indicates that the two tail ends are relatively
close together.

A larger distance indicates that the two tail ends are farther apart,
which may correspond to a more extended, separated, or disordered lipid
tail conformation.

The complete distribution of distances therefore describes the range
of conformations adopted by the lipid tails at the AuNP surface.

## Important distinction

This analysis does not calculate the distance between the terminal
carbon atoms and the AuNP.

The 4 Å cutoff is used only to identify lipid molecules associated with
the AuNP surface.

After those lipids have been identified, the script calculates the
distance between the two terminal carbon atoms within each selected
lipid molecule.

## Analysis method

The analysis is performed separately for every trajectory frame.

For each frame, the script:

1. Identifies DOPC molecules with at least one atom within 4 Å of the
   AuNP.
2. Creates a list of the residue numbers of the selected DOPC molecules.
3. Selects atoms `C218` and `C318` from each selected DOPC molecule.
4. Confirms that exactly one `C218` atom and one `C318` atom are present.
5. Retrieves the three-dimensional coordinates of both atoms.
6. Calculates the distance between the two atoms using VMD `vecdist`.
7. Writes the simulation time, lipid residue number, and calculated
   distance to the output file.

## Step 1: Identification of lipids associated with the AuNP

The following selection is used:

```tcl
resname DOPC and pbwithin 4.0 of resname AUM
```

The different parts of this selection have the following meanings:

- `resname DOPC` selects atoms belonging to DOPC molecules.
- `resname AUM` identifies the gold nanoparticle.
- `pbwithin 4.0 of resname AUM` selects DOPC atoms located within 4 Å
  of an AUM atom while considering periodic boundaries.

The script obtains the unique residue numbers of these DOPC molecules:

```tcl
set residList [lsort -unique [$contact get resid]]
```

Only the DOPC molecules identified by this selection are included in
the tail-distance calculation.

### Note about hydrogen atoms

The current selection includes all DOPC atoms, including hydrogen atoms,
when applying the 4 Å contact criterion.

To identify contacting lipids using only non-hydrogen atoms, change:

```tcl
resname DOPC and pbwithin $cutoff of resname AUM
```

to:

```tcl
noh and resname DOPC and pbwithin $cutoff of resname AUM
```

Use the selection that matches the method applied in the associated
study.

## Step 2: Selection of the terminal carbon atoms

For every selected DOPC residue, the first terminal carbon is selected
using:

```tcl
resname DOPC and resid $resid and name C218
```

The second terminal carbon is selected using:

```tcl
resname DOPC and resid $resid and name C318
```

The script checks that each selection contains exactly one atom:

```tcl
if {[$sel1 num] == 1 && [$sel2 num] == 1}
```

If either atom is missing or selected more than once, no distance is
written for that lipid in that frame.

## Step 3: Calculation of the tail-to-tail distance

The coordinates of `C218` and `C318` are obtained using:

```tcl
set pos1 [lindex [$sel1 get {x y z}] 0]
set pos2 [lindex [$sel2 get {x y z}] 0]
```

The distance is then calculated using:

```tcl
set d [vecdist $pos1 $pos2]
```

`vecdist` calculates the straight-line distance between the two
three-dimensional coordinate vectors.

The result is written to the output file using:

```tcl
puts $out "$time_ps\t$resid\t$d"
```

## Files

- `AuNP_DOPC_min_01.pdb` – Representative structure of the DOPC-coated
  AuNP
- `DOPC_tail_distances.tcl` – VMD Tcl script used to calculate the
  distance between the two terminal carbon atoms
- `DOPC_tail_distances.dat` – Raw terminal-carbon distance values
  calculated for the selected lipids and trajectory frames
- `README.md` – Description and instructions for the analysis

The trajectory and Excel post-processing files are not included in this
repository.

## Analysis parameters

The main parameters defined in the Tcl script are:

```tcl
set cutoff 4.0
set ps_per_frame 10.0
set outfile "DOPC_tail_distances.dat"
```

These correspond to:

- Example lipid: DOPC
- Lipid residue name: `DOPC`
- AuNP residue name: `AUM`
- Contact-lipid cutoff: 4.0 Å
- First terminal carbon atom: `C218`
- Second terminal carbon atom: `C318`
- Time between consecutive frames: 10 ps
- Analysis software: VMD
- Script language: Tcl
- Output file: `DOPC_tail_distances.dat`

The value assigned to `ps_per_frame` must match the time interval
between consecutive frames in the trajectory.

If the trajectory was saved at a different interval, change this value
before running the analysis.

## Analysis period

The associated study performed this analysis over the final 10 ns of
the production simulations.

The script analyses every trajectory frame loaded into VMD. Therefore,
the loaded trajectory should contain the final 10 ns of the simulation,
or the required final 10 ns should be extracted from the complete
trajectory before running the analysis.

## How to run the analysis

All required input files should be placed in the same folder as the
analysis script.

### Step 1: Load the PDB structure

1. Open VMD.
2. Select **File → New Molecule**.
3. Click **Browse**.
4. Select `AuNP_DOPC_min_01.pdb`.
5. Click **Load**.

### Step 2: Load the trajectory

Load the corresponding trajectory into the same VMD molecule:

1. Keep the molecule containing `AuNP_DOPC_min_01.pdb` selected.
2. Click **Browse** again.
3. Select the corresponding trajectory file.
4. Click **Load**.

The PDB structure and trajectory must be loaded into the same molecule,
not as separate molecules.

### Step 3: Open the Tk Console

In VMD, select:

**Extensions → Tk Console**

Change to the folder containing the files. For example:

```tcl
cd "path/to/5_lipid_tail_distance"
```

Run the analysis script using:

```tcl
source DOPC_tail_distances.tcl
```

After the calculation is complete, the output file will be written to
the same working folder.

## Output-file format

The script creates:

```text
DOPC_tail_distances.dat
```

The output file contains three columns:

```text
Time_ps    Resid    Distance_A
```

A simplified example is:

```text
0.0       4771     8.42
0.0       4776     12.18
0.0       4784     5.73
10.0      4771     9.01
10.0      4776     11.65
```

The columns contain:

- `Time_ps` – simulation time in picoseconds
- `Resid` – residue number of the selected DOPC molecule
- `Distance_A` – distance between `C218` and `C318` in angstroms

Each trajectory frame can produce multiple output rows because one
distance is written for every selected DOPC molecule.

The time is calculated using:

```tcl
set time_ps [expr {$i * $ps_per_frame}]
```

## Post-processing and figure preparation

The Tcl script produces the raw terminal-carbon distance values. It does
not directly generate the final distance-distribution graph.

For the associated study, the raw values in the `Distance_A` column were
processed in Microsoft Excel.

The distances were grouped into 2 Å-wide intervals and represented by
the midpoint of each interval. For example:

| Distance interval | Bin midpoint |
|---|---:|
| 3–5 Å | 4 Å |
| 5–7 Å | 6 Å |
| 7–9 Å | 8 Å |
| 9–11 Å | 10 Å |

The number of distance values in each interval was counted to obtain the
frequency distribution.

The bin midpoint was then plotted on the horizontal axis and the
corresponding count was plotted on the vertical axis.

The Excel workbook used for this post-processing and graph preparation
is not included in the GitHub repository. However, the uploaded raw
`.dat` file contains the values required to reproduce the binning and
plotting using Excel, Python, R, or another data-analysis program.

When reproducing the graph, clearly report:

- The selected bin width
- The lower and upper boundaries of each bin
- Whether the values from different replicates were processed
  separately or combined
- Any normalisation applied to the counts

## Important note about the initial frame

The script contains:

```tcl
animate delete beg 0 end 0
```

This command removes the initial PDB frame after the trajectory has been
loaded.

Therefore:

1. Load the PDB structure first.
2. Load the trajectory into the same VMD molecule.
3. Run the Tcl script only after both files have been loaded.

Do not use this command when the first loaded frame is a trajectory frame
that should be included in the analysis.

## Periodic boundary conditions

The script uses the VMD `pbwithin` selection keyword to identify DOPC
molecules close to the AuNP.

The trajectory must contain valid periodic box information for
`pbwithin` to behave correctly.

The lipid-coated AuNP should be inspected visually before running the
analysis. Confirm that the nanoparticle and lipid coating are represented
correctly and are not improperly split across periodic boundaries.

If necessary, join, centre, and wrap the trajectory before running the
analysis.

The `vecdist` calculation uses the displayed coordinates of `C218` and
`C318`. Therefore, each DOPC molecule must remain whole and must not be
split across opposite sides of the periodic box. Otherwise, an
artificially large terminal-carbon distance may be calculated.

## Important implementation note: residue identifiers

The current script identifies DOPC molecules using only their residue
number:

```tcl
set residList [lsort -unique [$contact get resid]]
```

This approach is suitable when every DOPC molecule has a unique residue
number.

If residue numbers are repeated in different segments, the script should
identify each lipid using both `resid` and `segname`. Otherwise, atoms
from different lipid molecules with the same residue number could be
selected together.

Check the structure file before running the analysis to confirm that
the DOPC residue numbers are unique.

## Trajectory availability

The trajectory file is not included in this GitHub repository because
of GitHub file-size limitations.

The uploaded DOPC files provide a representative example of the analysis
workflow. Researchers who require the trajectory files should contact
the corresponding authors of the publication associated with this
repository. Their contact details are provided in the publication.

## Adapting the script for another lipid system

The uploaded script demonstrates the analysis using DOPC as a
representative example.

To analyse another lipid system:

1. Replace `DOPC` with the appropriate lipid residue name.
2. Identify the terminal carbon atom at the end of each acyl tail.
3. Replace `C218` and `C318` with the correct atom names.
4. Load the corresponding structure and trajectory files.
5. Update the script and output filenames.
6. Confirm that the AuNP residue name is correct.
7. Confirm the time interval between consecutive trajectory frames.
8. Confirm that the contact cutoff is appropriate.
9. Confirm that each lipid is correctly reconstructed across periodic
   boundaries.

For example, replace:

```tcl
name C218
```

and:

```tcl
name C318
```

with the terminal-carbon atom names used in the topology of the lipid
being analysed.

Different lipid types can use different atom names for their two acyl
tails. Check the corresponding topology or PDB file before modifying
the selections.

For a lipid containing tails of different lengths, analyse the terminal
carbon of each tail separately using the correct atom name for each
chain.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
