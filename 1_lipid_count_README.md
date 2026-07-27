# Lipid count within 4 Å of the AuNP surface

## Description

This folder contains a representative DOPC example of the analysis used
to count lipid molecules located within 4 Å of the gold nanoparticle
surface during the final 10 ns of the molecular dynamics simulation.

The same analysis procedure was applied to the other lipid systems
reported in the associated publication.

## Files

- `AuNP_DOPC.pdb` – Example DOPC–AuNP structure used for the analysis
- `DOPC_count.tcl` – VMD Tcl script used to perform the lipid-count analysis
- `DOPC_count.dat` – Output containing the calculated DOPC lipid counts

The trajectory file is not included in this GitHub repository because of
GitHub file-size limitations. The uploaded files provide a representative
example of the analysis workflow.

Researchers who require the trajectory files should contact the corresponding
authors of the publication associated with this repository. Their contact
details are provided in the publication.

## Analysis details

- Lipid system: DOPC
- Nanoparticle: 5 nm gold nanoparticle
- Distance cutoff: 4 Å
- Analysis period: Final 10 ns of the simulation
- Software: VMD

## How to run the analysis

All input files required for this analysis should be placed in the same
folder as the analysis script.

1. Open VMD.
2. Load the structure file, `AuNP_DOPC.pdb`.
3. Load the corresponding trajectory file into the same molecule:
4. Open the VMD Tk Console:
5. In the Tk Console, run the analysis script using:

```tcl
source DOPC_count.tcl
