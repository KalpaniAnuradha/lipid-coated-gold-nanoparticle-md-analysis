# Root Mean Square Fluctuation of DOPC Headgroup Nitrogen Atoms

## Description

This folder contains a representative DOPC example of the root mean
square fluctuation analysis used to examine the mobility of selected
lipid atoms associated with a 5 nm gold nanoparticle.

The uploaded Tcl script calculates the RMSF of the nitrogen atom in the
DOPC headgroup. One RMSF value is calculated for each selected nitrogen
atom over the specified trajectory frames.

The DOPC headgroup-nitrogen analysis is provided as a representative
example. In the associated publication, RMSF was calculated for three
different atomic selections:

- All lipid heavy atoms
- Selected lipid headgroup atoms
- Terminal carbon atoms of the lipid tails

The same general workflow can be adapted for the other lipid systems
and atomic selections by changing the VMD atom selection.

## What is RMSF?

Root mean square fluctuation, commonly written as RMSF, measures how
much the position of an individual atom fluctuates around its average
position during a selected period of a molecular dynamics trajectory.

For atom \(i\), RMSF is calculated as:

```math
\mathrm{RMSF}_i =
\sqrt{
\frac{1}{N}
\sum_{t=1}^{N}
\left|
\mathbf{r}_i(t)
-
\left\langle \mathbf{r}_i \right\rangle
\right|^2
}
```

where:

- \(\mathbf{r}_i(t)\) is the position of atom \(i\) at trajectory frame
  \(t\).
- \(\left\langle \mathbf{r}_i \right\rangle\) is the average position
  of atom \(i\) over all analysed frames.
- \(N\) is the total number of analysed trajectory frames.
- \(\sum\) means that the squared displacement is calculated for every
  analysed frame and the values are added together.
- \(\mathrm{RMSF}_i\) is the fluctuation of atom \(i\) around its
  average position.

For each selected atom, the calculation follows these steps:

1. Calculate the average position of the atom over the analysed
   trajectory frames.
2. Calculate the distance between the atom's position in each frame and
   its average position.
3. Square each distance.
4. Calculate the average of the squared distances.
5. Take the square root.

VMD uses coordinates in angstroms, so the RMSF values are reported in
angstroms (Å).

## Interpretation of RMSF

A lower RMSF value indicates that the selected atom remains relatively
close to its average position. This represents a more restricted or less
mobile atomic environment.

A higher RMSF value indicates that the selected atom moves farther from
its average position during the analysed trajectory. This represents
greater configurational mobility or flexibility.

In this example, the RMSF values describe the mobility of the nitrogen
atoms in the DOPC headgroups.

RMSF should not be confused with RMSD:

- RMSF describes the fluctuation of each selected atom over time.
- RMSD describes the overall structural deviation of a group of atoms
  relative to a reference structure.

## What does the uploaded script calculate?

The uploaded script uses the following VMD atom selection:

```tcl
resname DOPC and name N
```

The different parts of this selection have the following meanings:

- `resname DOPC` selects atoms belonging to DOPC molecules.
- `name N` selects the atom with the atom name `N`.

Therefore, the script calculates one RMSF value for every atom named `N`
in all DOPC residues present in the loaded molecular system.

For DOPC, each lipid molecule normally contains one selected headgroup
nitrogen atom. Therefore, each output value generally corresponds to the
headgroup nitrogen atom of one DOPC molecule.

Before running the analysis, check the PDB or topology file to confirm
that the required nitrogen atom is named `N`.

## Important note about the 4 Å lipid selection

The associated publication reports RMSF values for lipids within 4 Å of
the AuNP surface.

However, the uploaded script currently uses:

```tcl
resname DOPC and name N
```

This selection includes every DOPC nitrogen atom in the loaded molecular
system. It does not apply a 4 Å distance criterion.

This script is appropriate when the loaded structure and trajectory
already contain only the DOPC molecules selected for the AuNP coating.

If additional DOPC molecules are present in the loaded system, confirm
that the selection matches the analysis method intended for the study
before running or modifying the script.

A distance-based atom selection should be designed carefully because
`measure rmsf` requires a consistent set of atoms across the analysed
trajectory frames.

## Analysis method

The analysis is performed using VMD's `measure rmsf` command.

The script performs the following steps:

1. Loads the PBCTools package.
2. Removes the initial PDB frame.
3. Selects every DOPC atom named `N`.
4. Determines the number of atoms in the selection.
5. Calculates the RMSF of every selected atom over frames 1–1000.
6. Writes one RMSF value per selected atom to `RMSF_DOPC_N.dat`.
7. Closes the output file.
8. Exits VMD after the calculation is complete.

The RMSF calculation is performed using:

```tcl
measure rmsf $selection1 first 1 last 1000 step 1
```

The command means:

- `first 1` – begin the RMSF calculation at frame 1.
- `last 1000` – end the calculation at frame 1000.
- `step 1` – analyse every frame within that range.

## Files

- `AuNP_DOPC.pdb` – Representative structure of the DOPC-coated
  AuNP
- `rmsf_DOPC_N.tcl` – VMD Tcl script used to calculate the RMSF of DOPC
  headgroup nitrogen atoms
- `RMSF_DOPC_N.dat` – RMSF values calculated for the selected nitrogen
  atoms
- `README.md` – Description and instructions for the analysis

## Analysis parameters

The main analysis settings in `rmsf_DOPC_N.tcl` are:

```tcl
set selection1 [atomselect top "resname DOPC and name N"]
```

and:

```tcl
measure rmsf $selection1 first 1 last 1000 step 1
```

These correspond to:

- Example lipid: DOPC
- Lipid residue name: `DOPC`
- Selected headgroup atom name: `N`
- First analysed frame: 1
- Last analysed frame: 1000
- Frame increment: 1
- Analysis software: VMD
- Script language: Tcl
- Output filename: `RMSF_DOPC_N.dat`

## Analysis period

The associated study performed this analysis over the final 10 ns of
the production simulations.

The uploaded script analyses frames 1–1000. This corresponds to 10 ns
only when consecutive trajectory frames are separated by 10 ps.

The loaded trajectory and selected frame range must therefore be checked
before running the analysis.

After the initial PDB frame has been removed, the trajectory should
contain frames numbered from 0 to at least 1000.

If the trajectory contains a different number of frames or uses a
different time interval, update the following values:

```tcl
first 1 last 1000 step 1
```

## Preparing the trajectory

RMSF measures atomic motion around an average position. Therefore,
overall translation or rotation of the AuNP–lipid system can artificially
increase the calculated RMSF values.

Before calculating RMSF, the trajectory should be:

1. Correctly reconstructed across periodic boundaries.
2. Centred using the AuNP.
3. Aligned to a reference structure using the AuNP atoms.

The uploaded script includes the comment:

```tcl
## Make sure you wrap and align to the AuNP
```

However, the script does not perform the alignment.

The wrapping command is also commented out:

```tcl
#pbc wrap -centersel "resname AUM" -center com -compound residue -all
```

Therefore, the uploaded script assumes that the trajectory has already
been correctly wrapped and aligned before the RMSF calculation is run.

Inspect the trajectory visually in VMD before running the script.
Confirm that:

- The AuNP remains centred.
- The AuNP does not rotate or translate significantly between frames.
- The lipid molecules are not split across periodic boundaries.
- Complete lipid molecules remain close to the AuNP.

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

### Step 3: Allign all the frames

Before running the RMSF calculation:

1. Align all the frames in the trajectory using the RMSD trajectory tool.
2. Select **Extensions**.
3. Select **RMSD Trajectory Tool**.
4. In the selection box type "resname AUM".
5. Click **ALIGN**. 

### Step 4: Open the Tk Console

In VMD, select:

**Extensions → Tk Console**

Run the analysis script using:

```tcl
source rmsf_DOPC_N.tcl
```

After the calculation is complete, the output file will be written to
the same working folder.

## Output file

The script creates:

```text
RMSF_DOPC_N.dat
```

The output file contains one RMSF value per line.

A simplified example is:

```text
5.842
6.104
5.693
6.287
```

Each value corresponds to one selected DOPC nitrogen atom.

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

After the PDB frame has been removed, the remaining trajectory frames
are renumbered beginning from frame 0.

The RMSF command then begins at frame 1:

```tcl
first 1
```

This means that the first remaining trajectory frame, frame 0, is also
excluded from the RMSF calculation.

This may be intentional when frames 1–1000 represent the required final
10 ns. Confirm that this frame range matches the analysis used in the
study.

## Important note about closing VMD

The final line of the script is:

```tcl
exit 0
```

This command closes VMD after the analysis is complete.

When the script is run through the VMD Tk Console, VMD may close
immediately after writing the output file.

To keep VMD open after the analysis, remove or comment out this line:

```tcl
#exit 0
```

## Trajectory availability

The trajectory file is not included in this GitHub repository because
of GitHub file-size limitations.

The uploaded DOPC files provide a representative example of the analysis
workflow. Researchers who require the trajectory files should contact
the corresponding authors of the publication associated with this
repository. Their contact details are provided in the publication.

## Adapting the script for all heavy atoms

To calculate RMSF for all DOPC heavy atoms, change:

```tcl
set selection1 [atomselect top "resname DOPC and name N"]
```

to:

```tcl
set selection1 [atomselect top "resname DOPC and noh"]
```

The `noh` keyword excludes hydrogen atoms.

Update the output filename so that it clearly identifies the selection:

```tcl
set output [open "RMSF_DOPC_heavy_atoms.dat" w]
```

This calculation will produce one RMSF value for every selected heavy
atom, not one value per lipid molecule.

## Adapting the script for terminal carbon atoms

To calculate RMSF for selected terminal carbon atoms, replace the
nitrogen selection with the exact terminal-carbon atom names.

For example:

```tcl
set selection1 [atomselect top "resname DOPC and name C218 C318"]
```

The atom names must be confirmed using the corresponding PDB or topology
file.

Different lipid types may use different terminal-carbon atom names. For
lipids with two tails of different lengths, the two terminal carbon
atoms may need to be analysed separately.

Update the output filename, for example:

```tcl
set output [open "RMSF_DOPC_terminal_C.dat" w]
```

## Adapting the script for another lipid system

The uploaded script demonstrates the analysis using the DOPC headgroup
nitrogen atom as a representative example.

To analyse another lipid system:

1. Replace `DOPC` with the appropriate lipid residue name.
2. Select the required headgroup, terminal-carbon, or heavy atoms.
3. Confirm the selected atom names in the PDB or topology file.
4. Load the corresponding structure and trajectory files.
5. Update the output filename.
6. Confirm the trajectory frame range.
7. Confirm the time interval between consecutive trajectory frames.
8. Ensure that the trajectory has been wrapped and aligned to the AuNP.
9. Confirm that the selected lipid set matches the intended 4 Å
   criterion used in the study.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
