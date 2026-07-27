# Lipid Headgroup Atom Distance-Count Distribution from the AuNP Surface

## Description

This folder contains a representative DOPC example of the analysis used
to examine the distribution of lipid headgroup atoms relative to the
surface of a 5 nm gold nanoparticle.

The analysis counts DOPC headgroup nitrogen and phosphorus atoms within
a series of increasing distance cutoffs from the AuNP surface. The
calculation is performed separately for every frame of the loaded
molecular dynamics trajectory.

The DOPC system is provided as a representative example. The same
analysis workflow was applied to the other lipid systems reported in
the associated publication.

## What does this analysis measure?

This analysis examines how far selected lipid headgroup atoms extend
from the AuNP surface.

For every trajectory frame, the script first identifies DOPC molecules
that are in contact with the AuNP. A DOPC molecule is classified as a
contact lipid when at least one of its atoms is located within 4 Å of
an AuNP atom.

The script then counts the selected headgroup atoms from those contact
lipids within a series of distance cutoffs ranging from 4.5 to 30.0 Å.

The analysed headgroup atoms are:

- Nitrogen, selected using `element N`
- Phosphorus, selected using `name P`

A larger count at a particular distance cutoff means that more selected
headgroup atoms are located within that distance from the AuNP surface.

Because DOPC contains one nitrogen atom and one phosphorus atom in each
headgroup, the nitrogen and phosphorus counts also indicate how many
selected DOPC headgroups have those atoms within each distance cutoff.

## Important interpretation of the output

The output files do not contain the individual distance of every atom
from the AuNP.

Instead, they contain cumulative atom counts.

For example:

- The value at 5.0 Å is the number of selected atoms within 5.0 Å.
- The value at 10.0 Å is the number of selected atoms within 10.0 Å.
- The value at 15.0 Å is the number of selected atoms within 15.0 Å.

Therefore, an atom counted within 5.0 Å is also included in the values
reported for 5.5 Å, 6.0 Å and all larger distance cutoffs.

The number of atoms in an individual distance interval can be calculated
by subtracting two consecutive cumulative counts.

For example:

```text
Atoms between 5.0 and 5.5 Å
= count within 5.5 Å − count within 5.0 Å
```

This subtraction can be used to construct a non-cumulative distance
distribution or histogram.

## Analysis method

The analysis is performed separately for every trajectory frame.

For each frame, the script:

1. Identifies DOPC molecules with at least one atom within 4 Å of the
   AuNP.
2. Records the residue number and segment name of each selected DOPC
   molecule.
3. Creates a list of unique contact-lipid identifiers.
4. Selects nitrogen and phosphorus atoms at increasing distances from
   the AuNP.
5. Retains only atoms belonging to the contact lipids identified in
   Step 1.
6. Counts the selected atoms within every distance cutoff.
7. Writes the simulation time and cumulative atom counts to separate
   output files.

## Step 1: Identification of contact lipids

The following selection is used to identify DOPC molecules in contact
with the AuNP:

```tcl
resname DOPC and pbwithin 4.0 of resname AUM
```

The different parts of this selection have the following meanings:

- `resname DOPC` selects atoms belonging to DOPC molecules.
- `resname AUM` identifies the gold nanoparticle.
- `pbwithin 4.0 of resname AUM` selects DOPC atoms within 4 Å of an
  AUM atom while considering periodic boundaries.

The script retrieves the residue number and segment name of these atoms:

```tcl
set residList [$contact get resid]
set segList   [$contact get segname]
```

The residue number and segment name are combined to identify each lipid:

```tcl
lappend lipidIDs "$r:$s"
```

Duplicate lipid identifiers are removed using:

```tcl
set lipidIDs [lsort -unique $lipidIDs]
```

This produces a unique list of DOPC molecules classified as contact
lipids in that trajectory frame.

### Note about hydrogen atoms

The current contact-lipid selection includes all DOPC atoms, including
hydrogen atoms, when applying the 4 Å criterion.

To classify contact lipids using only non-hydrogen atoms, change:

```tcl
resname DOPC and pbwithin 4.0 of resname AUM
```

to:

```tcl
noh resname DOPC and pbwithin 4.0 of resname AUM
```

Use the version that matches the method applied in the associated study.

## Step 2: Nitrogen atom selection

For each distance cutoff, nitrogen atoms are selected using:

```tcl
resname DOPC and element N and pbwithin $c of resname AUM
```

Here, `$c` is the current distance cutoff.

Only nitrogen atoms belonging to the contact lipids identified in
Step 1 are retained and counted.

The resulting cumulative counts are written to:

```text
Headgroup_N.dat
```

## Step 3: Phosphorus atom selection

For each distance cutoff, phosphorus atoms are selected using:

```tcl
resname DOPC and name P and pbwithin $c of resname AUM
```

Only phosphorus atoms belonging to the contact lipids identified in
Step 1 are retained and counted.

The resulting cumulative counts are written to:

```text
Headgroup_P.dat
```

The script uses `name P` rather than `element P`. Therefore, the
phosphorus atom in the structure must have the atom name `P`.

Check the PDB or topology file before running the analysis to confirm
that this atom name is correct.

## Distance cutoffs

The script uses the following cumulative distance cutoffs:

```text
4.5, 5.0, 5.5, 6.0, 6.5, ..., 29.5 and 30.0 Å
```

The minimum cutoff is 4.5 Å, the maximum cutoff is 30.0 Å and the
increment is 0.5 Å.

These values are defined in the Tcl script using:

```tcl
set cutoffs {4.5 5.0 5.5 6.0 6.5 7.0 7.5 8.0 8.5 9.0 9.5 10.0 10.5 11.0 11.5 12.0 12.5 13.0 13.5 14.0 14.5 15.0 15.5 16.0 16.5 17.0 17.5 18.0 18.5 19.0 19.5 20.0 20.5 21.0 21.5 22.0 22.5 23.0 23.5 24.0 24.5 25.0 25.5 26.0 26.5 27.0 27.5 28.0 28.5 29.0 29.5 30.0}
```

The cutoffs may be changed if a different distance range or interval is
required.

## Files

- `AuNP_DOPC.pdb` – Representative structure of the DOPC-coated AuNP
- `Headgroup_atoms_DOPC.tcl` – VMD Tcl script used to perform the
  headgroup atom distance-count analysis
- `Headgroup_N.dat` – Cumulative nitrogen atom counts at each distance
  cutoff
- `Headgroup_P.dat` – Cumulative phosphorus atom counts at each distance
  cutoff
- `README.md` – Description and instructions for the analysis

The trajectory file is not included because of GitHub file-size
limitations.

Researchers who require the trajectory files should contact
the corresponding authors of the publication associated with this
repository. Their contact details are provided in the publication.

## Analysis parameters

The main analysis parameters are:

- Example lipid: DOPC
- Lipid residue name: `DOPC`
- AuNP residue name: `AUM`
- Contact-lipid cutoff: 4.0 Å
- Minimum atom-distance cutoff: 4.5 Å
- Maximum atom-distance cutoff: 30.0 Å
- Distance increment: 0.5 Å
- Time between consecutive frames: 10 ps
- Analysis software: VMD
- Script language: Tcl

The trajectory-frame interval is defined as:

```tcl
set ps_per_frame 10.0
```

This value must match the time interval between consecutive frames in
the loaded trajectory.

If one frame is saved every 10 ps, use:

```tcl
set ps_per_frame 10.0
```

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
4. Select `AuNP_DOPC.pdb`.
5. Click **Load**.

### Step 2: Load the trajectory

Load the corresponding trajectory into the same VMD molecule:

1. Keep the molecule containing `AuNP_DOPC.pdb` selected.
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
cd "path/to/4_lipid_atom_distance_distribution"
```

Run the analysis script using:

```tcl
source Headgroup_atoms_DOPC.tcl
```

The script will process every loaded trajectory frame.

After the calculation is complete, the output files will be written to
the same working folder.

## Output-file format

Both output files contain:

- Simulation time in the first column
- Cumulative atom counts in the remaining columns

The header contains the corresponding distance cutoffs.

A simplified example is:

```text
# Time_ps    4.5    5.0    5.5    6.0    6.5    ...
0.0          0      1      2      4      6      ...
10.0         0      1      3      5      7      ...
20.0         0      2      3      5      8      ...
```

Each row represents one trajectory frame.

For example, in `Headgroup_N.dat`, the value under the `10.0` column is
the cumulative number of selected nitrogen atoms within 10.0 Å of the
AuNP in that trajectory frame.

The time is calculated using:

```tcl
set time_ps [expr {$i * $ps_per_frame}]
```

where `$i` is the trajectory-frame number.

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

The script uses the VMD `pbwithin` selection keyword, which considers
periodic boundaries when performing the distance selections.

The trajectory must contain valid periodic box information for
`pbwithin` to behave correctly.

The lipid-coated AuNP should also be inspected visually before running
the analysis. Confirm that the nanoparticle and lipid coating are
represented correctly and are not improperly split across the periodic
boundaries.

If necessary, the trajectory should be joined, centred and wrapped
before running the distance-count analysis.

## Trajectory availability

The trajectory file is not included in this GitHub repository because
of GitHub file-size limitations.

The uploaded DOPC files provide a representative example of the analysis
workflow. Researchers who require the trajectory files should contact
the corresponding authors of the publication associated with this
repository. Their contact details are provided in the publication.

## Adapting the analysis for selected lipid tail atoms

The uploaded script demonstrates the distance-count analysis using
DOPC headgroup nitrogen and phosphorus atoms.

The same method can be used to analyse selected atoms in the lipid
tails by changing the atom selection.

For example, a selected terminal carbon atom can be analysed using:

```tcl
set selC [atomselect top "(resname DOPC and name ATOM_NAME and pbwithin $c of resname AUM)" frame $i]
```

Replace `ATOM_NAME` with the exact atom name of the required tail atom.

Do not use only:

```tcl
element C
```

unless the intention is to count every carbon atom in the lipid.
Selecting `element C` would include headgroup, glycerol and tail carbon
atoms.

For a terminal-tail analysis, use the exact terminal carbon atom name
defined in the lipid topology.

Different lipid tails may have different terminal atom names. For a
lipid with two chemically different tails, each terminal carbon may need
to be analysed separately.

For example:

```tcl
set selC1 [atomselect top "(resname DOPC and name TERMINAL_C1 and pbwithin $c of resname AUM)" frame $i]

set selC2 [atomselect top "(resname DOPC and name TERMINAL_C2 and pbwithin $c of resname AUM)" frame $i]
```

Replace `TERMINAL_C1` and `TERMINAL_C2` with the correct atom names from
the relevant topology.

Separate output files can then be created, for example:

```tcl
set outC1 [open "Terminal_C1.dat" w]
set outC2 [open "Terminal_C2.dat" w]
```

The filtering step should continue to retain only atoms belonging to the
contact lipids identified within 4 Å of the AuNP.

## Adapting the script for another lipid system

The uploaded script demonstrates the analysis using DOPC as a
representative example.

To analyse another lipid system:

1. Replace `DOPC` with the appropriate lipid residue name.
2. Confirm the required headgroup or tail atom names.
3. Load the corresponding structure and trajectory files.
4. Update the script and output filenames.
5. Confirm that the AuNP residue name is correct.
6. Confirm the time interval between consecutive trajectory frames.
7. Confirm that the distance range and cutoff increment are appropriate.

Before running the modified script, check all residue and atom names in
the corresponding PDB or topology file.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
