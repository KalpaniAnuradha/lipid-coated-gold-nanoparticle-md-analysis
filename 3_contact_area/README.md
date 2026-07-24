# Contact Area Between Lipids and the AuNP

## Description

This folder contains a representative DOPC example of the analysis used
to calculate the contact area between lipid molecules and the surface of
a 5 nm gold nanoparticle.

The analysis was performed using solvent-accessible surface area (SASA)
calculations in VMD. For each trajectory frame, DOPC molecules located
within 4 Å of the AuNP surface were selected, and the contact area
between those lipids and the AuNP was calculated.

The same analysis workflow was applied to the other lipid systems
reported in the associated publication.

## What is contact area?

The contact area describes the amount of surface shared between the
lipids and the gold nanoparticle.

When lipids bind to the AuNP, part of the solvent-accessible surface of
both components becomes buried. The buried surface area can therefore be
used to estimate the lipid–AuNP contact area.

The contact area is calculated as:

```math
A_{\mathrm{contact}} =
\frac{
\mathrm{SASA}_{\mathrm{AuNP}}
+
\mathrm{SASA}_{\mathrm{lipids}}
-
\mathrm{SASA}_{\mathrm{AuNP+lipids}}
}{2}
```

where:

- **SASA of the AuNP** is the solvent-accessible surface area of the gold nanoparticle alone.
- **SASA of the lipids** is the solvent-accessible surface area of the selected DOPC molecules alone.
- **SASA of the AuNP–lipid complex** is the solvent-accessible surface area of the combined AuNP and DOPC selection.

The result is divided by two because the buried interface is counted
once on the AuNP surface and once on the lipid surface.

A larger contact area indicates that more lipid surface is in contact
with the AuNP. A smaller contact area indicates less extensive contact
between the lipids and the nanoparticle.

## Files

- `AuNP_DOPC.pdb` – Representative structure of the DOPC-coated AuNP
- `sasa_DOPC.tcl` – VMD Tcl script used for the SASA and contact-area calculations
- `sasa_contact_area.dat` – Calculated lipid–AuNP contact area for each trajectory frame
- `sasa_AUM.dat` – SASA of the AuNP for each frame
- `sasa_DOPC.dat` – SASA of the selected DOPC molecules for each frame
- `sasa_AUM+DOPC.dat` – SASA of the combined AuNP–DOPC selection for each frame
- `README.md` – Description and instructions for the analysis

## Atom selection

For every trajectory frame, the script selects:

```tcl
resname AUM or (same residue as (noh resname DOPC and pbwithin 4.0 of resname AUM))
```

This selection means that:

1. The AuNP atoms are identified using the residue name `AUM`.
2. DOPC hydrogen atoms are excluded when applying the distance test.
3. A DOPC molecule satisfies the selection when at least one of its
   non-hydrogen atoms is within 4 Å of an AUM atom.
4. The complete DOPC residue is then included in the SASA calculation.
5. The lipid selection is updated for every trajectory frame.

## Analysis parameters

The following parameters are defined in `sasa_DOPC.tcl`:

```tcl
set cutoff 4.0
set P 1.4
set s 500
```

These correspond to:

- Lipid–AuNP distance cutoff: 4.0 Å
- SASA probe radius: 1.4 Å
- Number of SASA sampling points: 500
- Analysis software: VMD
- Example lipid: DOPC
- AuNP residue name: `AUM`

With the standard coordinate units used by VMD, the calculated SASA and
contact-area values are reported in Å².

## SASA calculations

For each frame, the script calculates:

```tcl
set sasaA [measure sasa $P $A -samples $s]
set sasaB [measure sasa $P $B -samples $s]
set sasaS [measure sasa $P $sel -samples $s]
```

The contact area is then calculated using:

```tcl
set sasaCA [expr {
    ([measure sasa $P $A -samples $s] +
     [measure sasa $P $B -samples $s] -
     [measure sasa $P $sel -samples $s]) * 0.5
}]
```

One value is written for each trajectory frame.

## Analysis period

The associated study calculated the contact area over the final 10 ns
of the production simulations.

The script analyses every frame of every trajectory loaded into VMD. Therefore,
The loaded trajectory should contain the final 10 ns of the simulation,
The required final 10 ns should be extracted before running the analysis.

## How to run the analysis

All input files should be placed in the same folder as the Tcl script.

### Step 1: Load the PDB structure

1. Open VMD.
2. Select **File → New Molecule**.
3. Click **Browse**.
4. Select `AuNP_DOPC.pdb`.
5. Click **Load**.

### Step 2: Load the trajectory

Load the corresponding trajectory into the same VMD molecule:

1. Keep the molecule containing `AuNP_DOPC.pdb` selected.
2. Click **Browse**.
3. Select the corresponding trajectory file.
4. Click **Load**.

The PDB structure and trajectory must be loaded into the same molecule,
not as separate molecules.

### Step 3: Open the Tk Console

In VMD, select:

**Extensions → Tk Console**

Change to the directory containing the files, for example:

```tcl
cd "path/to/03_lipid_AuNP_contact_area"
```

Run the script using:

```tcl
source sasa_DOPC.tcl
```

The progress of the calculation will be displayed in the Tk Console.

## Output files

The script creates four output files:

```text
sasa_contact_area.dat
sasa_AUM.dat
sasa_DOPC.dat
sasa_AUM+DOPC.dat
```

Each line represents the value calculated for one trajectory frame. The
values are written in the same order as the loaded trajectory frames.

The principal output used for the lipid–AuNP contact-area analysis is:

```text
sasa_contact_area.dat
```

## Important note about the initial frame

The script contains:

```tcl
animate delete beg 0 end 0
```

This removes the initial PDB frame after the trajectory has been loaded.
Therefore, the PDB structure should be loaded first, followed by the
trajectory in the same VMD molecule.

## Periodic boundary conditions

The script uses the `pbwithin` atom-selection keyword. The molecular
system should therefore be correctly wrapped before running the
analysis.

The script contains the following commented commands:

```tcl
#package require pbctools
#pbc wrap -centersel "resname AUM" -center com -compound residue -all
```

These commands can be enabled when wrapping is required. Check the
trajectory visually before analysis to ensure that the lipid-coated
AuNP is not split across the periodic boundaries.

## Trajectory availability

The trajectory file is not included in this GitHub repository because
of GitHub file-size limitations.

The uploaded DOPC files provide a representative example of the analysis
workflow. Researchers who require the trajectory files should contact
the corresponding authors of the publication associated with this
repository. Their contact details are provided in the publication.

## Adapting the script for another lipid

To analyse another lipid system, replace `DOPC` in the atom selections
with the appropriate lipid residue name:

```tcl
set B [atomselect top "(same residue as (noh resname DOPC and pbwithin $cutoff of resname AUM))" frame $i]
```

The input structure, trajectory, script name and output filenames should
also be changed to match the system being analysed.

## Associated publication

K. A. Mirihana et al., *Structural and dynamic properties of
lipid-coated gold nanoparticles*.

Publication DOI: To be added after publication.
