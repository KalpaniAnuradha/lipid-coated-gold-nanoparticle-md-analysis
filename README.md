# Lipid-Coated Gold Nanoparticle MD Analysis

Representative VMD/Tcl analysis workflows, input structures, and example
outputs associated with atomistic molecular dynamics simulations of
lipid-coated 5 nm gold nanoparticles.

This repository accompanies the research article:

> **Structural and Dynamic Properties of Lipid-Coated Gold Nanoparticles**

The study examines how lipid headgroup chemistry, charge, acyl-chain
length, and tail saturation influence the structure, packing, spatial
distribution, and mobility of lipid coatings formed around gold
nanoparticles.

---

## Overview

Lipid-coated gold nanoparticles are promising platforms for
nanomedicine, drug delivery, antimicrobial applications, and other
biomedical technologies. However, their behaviour depends strongly on
the molecular organisation of the lipid coating at the nanoparticle
surface.

Atomistic molecular dynamics simulations were used to investigate the
interaction of a faceted 5 nm gold nanoparticle with lipids.

The analysis workflows in this repository were used to characterise the
number, organisation, spatial distribution, packing, and mobility of
lipids associated with the AuNP surface.

---

## Repository scope

This repository provides a **representative DOPC example** for each
analysis workflow.

The same general analysis procedures were applied to the other lipid
systems reported in the associated publication.

Each analysis folder contains some or all of the following:

- A representative DOPC–AuNP PDB structure
- A VMD Tcl analysis script
- Representative output data
- A detailed analysis-specific `README.md`
- Instructions for modifying the script for another lipid or atom
  selection

The repository is intended to document and demonstrate the analysis
methodology. It is not a complete archive of every simulation trajectory
or every intermediate output generated during the study.

---

## Repository contents

| Folder | Analysis | Description |
|---|---|---|
| [`1_lipid_count`](./1_lipid_count) | Lipid count | Counts unique lipid molecules with at least one selected atom within 4 Å of the AuNP surface |
| [`2_radius_of_gyration`](./2_radius_of_gyration) | Radius of gyration | Calculates the mass-weighted radius of gyration of the AuNP–lipid complex |
| [`3_contact_area`](./3_contact_area) | Lipid–AuNP contact area | Calculates the buried contact area between the selected lipids and AuNP using solvent-accessible surface area |
| [`4_lipid_atom_distance_distribution`](./4_lipid_atom_distance_distribution) | Lipid atom distance distribution | Calculates cumulative distance-count distributions for selected lipid headgroup or tail atoms relative to the AuNP surface |
| [`5_lipid_tail_distance`](./5_lipid_tail_distance) | Tail-to-tail distance | Calculates the distance between the terminal carbon atoms of the two acyl tails within each selected lipid |
| [`6_RMSF`](./6_RMSF) | Root mean square fluctuation | Calculates the RMSF of selected lipid atoms; the uploaded example uses the DOPC headgroup nitrogen atom |

Open the `README.md` inside each folder for a detailed explanation of
the analysis, atom selections, input requirements, output format, and
instructions for adapting the script.

---

## Analysis summary

### 1. Lipid count

Calculates the number of unique lipid molecules satisfying a 4 Å
distance criterion relative to the AuNP surface.

The representative script counts a DOPC molecule once per frame when at
least one selected non-hydrogen atom is located within 4 Å of an AuNP
atom.

### 2. Radius of gyration

Calculates the mass-weighted radius of gyration of the selected
AuNP–lipid complex.

A smaller radius of gyration generally indicates a more compact
complex, whereas a larger value indicates that the selected coating
extends farther from the centre of mass.

### 3. Lipid–AuNP contact area

Calculates the buried interfacial area between the selected lipid
molecules and the AuNP using solvent-accessible surface area.

The contact area is obtained from the SASA values of the AuNP, the
selected lipids, and the combined AuNP–lipid complex.

### 4. Lipid atom distance distribution

Counts selected lipid atoms within a series of increasing distance
cutoffs from the AuNP surface.

The representative workflow includes DOPC headgroup nitrogen and
phosphorus atoms. The atom selections can be changed to analyse selected
tail atoms or another lipid type.

### 5. Terminal-carbon distance

Calculates the three-dimensional distance between the terminal carbon
atoms of the two acyl tails within individual lipid molecules associated
with the AuNP.

The raw distances can be grouped into distance intervals to generate a
tail-to-tail distance distribution.

### 6. Root mean square fluctuation

Calculates the root mean square fluctuation of selected lipid atoms over
a specified trajectory period.

The representative script calculates the RMSF of the DOPC headgroup
nitrogen atom. The selection can be modified to calculate RMSF for all
heavy atoms, selected headgroup atoms, or terminal carbon atoms.

---

## Simulation context

The analysis workflows were developed for atomistic molecular dynamics
simulations containing:

- One faceted 5 nm gold nanoparticle
- A single lipid type per simulation system
- Explicit water
- 0.15 M NaCl
- Neutralising counterions where required

The simulations were performed using:

- **GROMACS 2023**
- **CHARMM36** for lipid, water, and ion atoms
- A modified **INTERFACE force field** for Au atoms
- **CHARMM TIP3P water**
- **CHARMM-GUI** for system component preparation
- **PACKMOL** for initial lipid packing

The primary trajectory analyses were performed using VMD and Tcl
scripts.

---

## Analysis period

The analyses reported in the associated study were performed over the
final 10 ns of the relevant production trajectories.

The example scripts generally process every trajectory frame loaded into
VMD or use a specified frame range. Users should confirm that:

- The loaded trajectory contains the intended analysis period
- The trajectory-frame interval is correct
- The script frame range matches the loaded trajectory
- The structure and trajectory contain matching atoms
- The required residue and atom names are correct

---

## Software requirements

The following software may be required, depending on the analysis:

| Software | Purpose |
|---|---|
| VMD (version 1.9.4a53)| Loading structures and trajectories and running the Tcl analysis scripts |
| Tcl | Scripting language used by VMD |
| PBCTools | Joining, centring, and wrapping trajectories and supporting periodic-boundary treatment |
| GROMACS | Simulation generation and optional trajectory preparation |
| Spreadsheet software, Python, or R | Optional post-processing, statistical analysis, binning, and plotting |

The scripts were prepared for the residue and atom names used in the
associated simulation systems. Users applying the scripts to a different
topology must check all residue and atom selections before running the
analysis.

---

## Quick start

### 1. Download the repository

Use the green **Code** button and select **Download ZIP**, or clone the
repository using Git.

### 2. Open an analysis folder

Select the folder corresponding to the required analysis and read its
`README.md`.

### 3. Prepare the input files

Place the required files in the same working folder as the Tcl script.

The typical inputs are:

- A PDB structure
- A corresponding trajectory
- The relevant Tcl analysis script

### 4. Load the files in VMD

1. Open VMD.
2. Select **File → New Molecule**.
3. Load the PDB structure.
4. Load the corresponding trajectory into the same VMD molecule.

The PDB and trajectory must not be loaded as two separate molecules.

### 5. Run the analysis

Open:

**Extensions → Tk Console**

Run the script:

```tcl
source SCRIPT_NAME.tcl
```

The output files will normally be written to the current working
directory.

Refer to the folder-specific README for the exact script name, atom
selection, analysis parameters, output format, and any required
trajectory preparation.

---

## Representative files and trajectory availability

The trajectory files are not included in this GitHub repository because
of their large file sizes.

The uploaded PDB structures, Tcl scripts, and output files provide
representative examples of the analysis workflows.

Researchers who require the trajectory files should contact the
following authors of the associated publication:

- **Andrew J. Christofferson** — andrew.christofferson@rmit.edu.au
- **Kalpani A. Mirihana** — kalpani.anuradha@outlook.com


Availability of trajectory files may be subject to storage,
institutional, authorship, and publication requirements.

---

## Reproducing the analyses

To reproduce an analysis:

1. Use the same or equivalent software version.
2. Confirm the trajectory frame interval and analysis period.
3. Confirm the AuNP and lipid residue names.
4. Confirm all selected atom names.
5. Apply appropriate periodic-boundary treatment.
6. Load the PDB and trajectory into the same VMD molecule.
7. Run the corresponding Tcl script.
8. Check the generated output against the format described in the
   folder-specific README.
9. Record any changes made to atom selections or analysis parameters.

The scripts should be reviewed before being used with a different
system. A script may run successfully but produce scientifically
incorrect results when the residue names, atom names, frame ranges, or
periodic-boundary treatment do not match the input system.

---

## Adapting the workflows

The uploaded scripts use DOPC as the representative lipid.

To analyse another lipid system, users may need to modify:

- The lipid residue name
- The selected headgroup or tail atom names
- The AuNP residue name
- The distance cutoff
- The trajectory-frame interval
- The analysed frame range
- The output filename
- The wrapping or alignment procedure

Atom names should always be confirmed using the relevant structure or
topology file.

Examples of common modifications are provided in each analysis-specific
README.

---

## Associated publication

**Kalpani A. Mirihana, Rashad Kariuki, Charlotte E. Conn, Aaron
Elbourne, and Andrew J. Christofferson**

*Structural and dynamic properties of lipid-coated gold nanoparticles.*

Journal: **Advanced Materials Interfaces**

Year: **2026**

DOI: **https://doi.org/10.1002/admi.70666**


---

## Citation

When using the scripts, methods, or data provided in this repository,
please cite both:

1. The associated journal article.
2. The archived release of this repository.

How to cite: **K. A. Mirihana, R. Kariuki, C. E. Conn, A. Elbourne, and A. J. Christofferson, “ Structural and Dynamic Properties of Lipid-Coated Gold Nanoparticles.” Advanced Materials Interfaces (2026): e70666. https://doi.org/10.1002/admi.70666**

A permanent repository citation and DOI will be added after a versioned
release has been archived.

---

## Authors

- **Kalpani A. Mirihana**
- **Rashad Kariuki**
- **Charlotte E. Conn**
- **Aaron Elbourne**
- **Andrew J. Christofferson**

School of Science, STEM College  
RMIT University  
Melbourne, Victoria, Australia

---

## Contact

For questions about the analysis scripts or repository, please open a
GitHub Issue.

For questions concerning the associated publication or access to the
simulation trajectories, contact the following authors:

- Andrew J. Christofferson — andrew.christofferson@rmit.edu.au
- Kalpani A. Mirihana - kalpani.anuradha@outlook.com

---

## Licence

## License

The content in this repository is licensed under the
**Creative Commons Attribution 4.0 International License (CC BY 4.0)**.

You are free to share and adapt the material, provided that you give
appropriate credit, provide a link to the license, and indicate if
changes were made.

If you use the scripts, data, figures, or analysis methods provided in
this repository for academic research. Please also cite the associated
publication and the archived version of this repository.

---

## Acknowledgements

This work was supported by computational resources provided by the
Australian Government through:

- The National Computational Infrastructure
- The Pawsey Supercomputing Research Centre
- The National Computational Merit Allocation Scheme

The associated project and resource allocations included project
`kl59` and resource grant `uo96`.

---

## Keywords

Gold nanoparticles; lipid-coated nanoparticles; lipid corona;
molecular dynamics simulations; atomistic simulation; computational
chemistry; GROMACS; VMD; Tcl; lipid adsorption; nano–bio interface;
radius of gyration; solvent-accessible surface area; lipid–nanoparticle
contact area; RMSF; phospholipids; nanomedicine; reproducible research.
