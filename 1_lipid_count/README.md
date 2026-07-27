# Lipid Count Within 4 Å of the AuNP Surface

## Description

This folder contains a representative DOPC example of the analysis used
to calculate the number of lipid molecules located within 4 Å of the
surface of a 5 nm gold nanoparticle.

The calculation is performed separately for every frame of the loaded
molecular dynamics trajectory.

The DOPC system is provided as a representative example. The same
analysis workflow was applied to the other lipid systems reported in
the associated publication.

## What does this analysis measure?

This analysis measures the number of individual DOPC molecules located
within 4 Å of the AuNP surface.

A DOPC molecule is counted when at least one of its non-hydrogen atoms
is located within 4 Å of an atom belonging to the gold nanoparticle.

The script counts lipid molecules rather than individual lipid atoms.
Therefore, each DOPC molecule is counted only once in each trajectory
frame, even when several atoms from the same molecule are located within
4 Å of the AuNP.

A higher lipid count indicates that more DOPC molecules are associated
with the AuNP surface. A lower lipid count indicates that fewer DOPC
molecules satisfy the 4 Å distance criterion.

## Analysis method

The analysis is performed separately for every trajectory frame.

For each frame, the script:

1. Selects the AuNP using the residue name `AUM`.
2. Identifies DOPC molecules with at least one non-hydrogen atom within
   4 Å of the AuNP.
3. Selects the complete residue of each DOPC molecule satisfying the
   distance criterion.
4. identifies individual lipid molecules using their residue number and
   segment name.
5. Removes duplicate molecule identifiers.
6. Counts the number of unique DOPC molecules.
7. Writes the simulation time and lipid count to the output file.

## Atom selection used in the script

The main VMD atom selection is:

```tcl
same residue as (noh resname DOPC and pbwithin 4.0 of resname AUM)
```

The different parts of this selection have the following meanings:

- `resname DOPC` selects atoms belonging to DOPC molecules.
- `noh` excludes hydrogen atoms when applying the distance criterion.
- `resname AUM` identifies the gold nanoparticle.
- `pbwithin 4.0 of resname AUM` selects DOPC non-hydrogen atoms located
  within 4 Å of an AUM atom while considering periodic boundaries.
- `same residue as` expands the selection to include the complete DOPC
  molecule when at least one of its non-hydrogen atoms satisfies the
  4 Å criterion.

The selection is recalculated for every trajectory frame because the
positions of the DOPC molecules can change during the simulation.

## Identification of individual lipid molecules

The script obtains the residue number and segment name of every atom in
the selected DOPC molecules:

```tcl
set resids [$nearDOPC_atoms get resid]
set segn [$nearDOPC_atoms get segname]
```

The residue number and segment name are combined to identify each
individual DOPC molecule:

```tcl
lappend molecule_ids "$r:$s"
```

For example, a molecule may be identified as:

```text
25:LIP1
```

Duplicate identifiers are removed using:

```tcl
set unique_molecules [lsort -unique $molecule_ids]
```

The number of unique lipid molecules is then calculated using:

```tcl
set count [llength $unique_molecules]
```

Using both the residue number and segment name helps distinguish lipid
molecules that may have the same residue number but belong to different
segments.

## Files

- `AuNP_DOPC.pdb` – Representative structure of the DOPC-coated AuNP
- `DOPC_count.tcl` – VMD Tcl script used to calculate the lipid count
- `DOPC_count.dat` – Lipid count calculated for every trajectory frame
- `README.md` – Description and instructions for the analysis

## Analysis parameters

The main parameters defined in `DOPC_count.tcl` are:

```tcl
set cutoff 4.0
set ps_per_frame 10.0
```

These correspond to:

- Example lipid: DOPC
- Lipid residue name: `DOPC`
- AuNP residue name: `AUM`
- Distance cutoff: 4.0 Å
- Time between consecutive trajectory frames: 10 ps
- Analysis software: VMD
- Script language: Tcl
- Output filename: `DOPC_count.dat`

## Analysis period

The associated study performed this analysis over the final 10 ns of
the production simulations.

The script analyses every trajectory frame loaded into VMD. Therefore,
the loaded trajectory should contain the final 10 ns of the simulation,
or the required final 10 ns should be extracted from the complete
trajectory before running the analysis.

## Periodic boundary conditions

The script uses the following commands before performing the lipid-count
calculation:

```tcl
pbc join connected -all
pbc wrap -centersel "resname AUM" -center com -compound residue -all
```

The first command:

```tcl
pbc join connected -all
```

joins connected molecular components that may have been separated
across the periodic boundaries.

The second command:

```tcl
pbc wrap -centersel "resname AUM" -center com -compound residue -all
```

centres the system using the centre of mass of the AuNP and wraps the
trajectory while keeping complete residues together.

The trajectory should be inspected visually after wrapping to confirm
that the lipid-coated AuNP is not split across the periodic boundaries.

## Required VMD package

The `pbc` commands are provided by the VMD PBCTools package.

The uploaded script currently contains:

```tcl
#package require pbctools
```

The `#` symbol means that this line is commented out. Before running the
script, change it to:

```tcl
package require pbctools
```

This ensures that the PBCTools package is loaded before the `pbc`
commands are used.

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
cd "path/to/1_lipid_count"
```

Run the analysis script using:

```tcl
source DOPC_count.tcl
```

The progress of the analysis will be displayed in the Tk Console.

An example progress message is:

```text
Frame 0 (Time: 0.0 ps): 84 DOPC molecules
```

After the calculation is complete, the output file will be written to
the same working folder.

## Output file

The script creates:

```text
DOPC_count.dat
```

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
2. Load the corresponding structure and trajectory files.
3. Update the script and output filenames.
4. Confirm that the AuNP residue name is correct.
5. Confirm the time interval between consecutive trajectory frames.
6. Confirm that the 4 Å distance cutoff is appropriate for the analysis.

Before running the modified script, check the residue names in the
relevant structure or topology file.

The script should continue to identify unique lipid molecules rather
than counting individual lipid atoms.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
