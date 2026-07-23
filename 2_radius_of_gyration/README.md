# Radius of Gyration (RoG) Analysis

## Description

This folder contains a representative DOPC example of the RoG analysis used in the associated molecular dynamics study.

The analysis calculates the RoG of the 5 nm gold
nanoparticle together with the DOPC molecules located within 4 Å of
the AuNP surface. The calculation is performed separately for every
frame of the loaded trajectory.

The same analysis workflow was applied to the other lipid systems
reported in the associated publication.

## What is the radius of gyration?

The radius of gyration, commonly written as $R_g$, describes how the
mass of a group of atoms is distributed around its centre of mass.

It is calculated as:

\[
R_g =
\sqrt{
\frac{
\sum_i m_i \left|\mathbf{r}_i-\mathbf{r}_{\mathrm{COM}}\right|^2
}{
\sum_i m_i
}
}
\]

where:

- \(m_i\) is the mass of atom \(i\)
- \(\mathbf{r}_i\) is the position of atom \(i\)
- \(\mathbf{r}_{\mathrm{COM}}\) is the centre-of-mass position of the selected atoms

A smaller radius of gyration generally indicates a more compact
lipid-coated nanoparticle structure. A larger radius of gyration
indicates that the selected lipid coating extends farther from the
centre of the nanoparticle.

In this analysis, the radius of gyration represents the overall size
and spatial extension of the AuNP–lipid complex, rather than the radius
of gyration of the lipids alone.

## Files

- `AuNP_DOPC.pdb` – Representative structure of the DOPC-coated AuNP
- `RoG_DOPC.tcl` – VMD Tcl script used to calculate the radius of gyration
- `RoG.dat` – Output containing one radius-of-gyration value for each
  trajectory frame
- `README.md` – Description and instructions for this analysis

## Atom selection used in the script

For each trajectory frame, the script performs the following selection:

```tcl
(same residue as (noh resname DOPC and pbwithin 4.0 of resname AUM)) or resname AUM
```

This means that:

1. DOPC hydrogen atoms are excluded when testing the 4 Å distance.
2. A DOPC molecule is selected when at least one of its non-hydrogen
   atoms is within 4 Å of an AUM atom.
3. Once a DOPC molecule satisfies this condition, the entire DOPC
   residue is included.
4. All AUM atoms are also included.
5. The radius of gyration is calculated for the combined AuNP and
   selected DOPC molecules.

The selection is updated for every trajectory frame because the number
and positions of the DOPC molecules near the AuNP can change over time.

## Analysis settings

- Lipid system: DOPC
- Nanoparticle residue name: `AUM`
- Lipid residue name: `DOPC`
- Distance cutoff: 4.0 Å
- Weighting method: Atomic mass
- Analysis software: VMD
- Output file: `RoG.dat`

The Tcl command used for the calculation is:

```tcl
measure rgyr $loop weight mass
```

Therefore, the reported radius of gyration is mass weighted.

## Analysis period

The associated study analysed the final 10 ns of the production
simulation.

The script processes every frame loaded into VMD. Therefore, the
trajectory loaded for this analysis should contain only the final
10 ns of the simulation. Alternatively, the final 10 ns should be
extracted from the complete trajectory before running the script.

## How to run the analysis

All required input files should be placed in the same folder as the
analysis script.

### Step 1: Load the structure

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

The PDB structure and trajectory must be loaded as the same molecule,
not as two separate molecules.

### Step 3: Run the Tcl script

Open the VMD Tk Console using:

**Extensions → Tk Console**

Change to the folder containing the input files and script, for example:

```tcl
cd "path/to/02_radius_of_gyration"
```

Run the analysis with:

```tcl
source RoG_DOPC.tcl
```

The script will show its progress in the Tk Console and create:

```text
RoG.dat
```

The output file contains one radius-of-gyration value for each analysed
trajectory frame. The values are written in the same order as the
trajectory frames.

## Important note about the first frame

The script contains the following command:

```tcl
animate delete beg 0 end 0
```

This removes the initial PDB frame after the trajectory has been loaded.
Therefore, the PDB structure must be loaded first and the trajectory
must then be loaded into the same molecule.

## Trajectory availability

The trajectory file is not included in this GitHub repository because
of GitHub file-size limitations.

The DOPC files are provided as a representative example of the analysis
workflow. Researchers who require the trajectory files should contact
the corresponding authors listed in the publication associated with
this repository.

## Adapting the script for another lipid

To analyse another lipid system, update the lipid residue name in this
line:

```tcl
set loop [atomselect top "(same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM)) or resname AUM"]
```

For example, replace `DOPC` with the appropriate residue name. The
structure and trajectory filenames must also correspond to the system
being analysed.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
