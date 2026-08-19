# hiPSC_saRNA_Analysis
Analysis code to accompany publication entitled "Rapid, durable, non-integrating transgenesis of hiPSCs via self-amplifying RNA"
# Reproducibility Code and Data

This repository contains the code and data used to generate the figures presented in the associated paper. The repository is organized by figure, with each folder containing the relevant scripts, data, and other files needed to reproduce the corresponding figure panels.

## Repository Structure

```text
.
├── Figure 1/
├── Figure 2/
├── Figure 3/
├── Figure 4/
├── Supplement/
├── .gitattributes
├── LICENSE
└── README.md
```

### `Figure 1/` – `Figure 4/`

Each figure folder contains the code and data associated with the corresponding main-text figure.

Where applicable, **folder or file names indicate the specific figure panels** to which the contents refer. For example, a file or subfolder labeled with a panel designation (e.g., `A`, `B`, or `A-B`) corresponds to that panel or set of panels in the paper.

The figure folders may contain:

* **Code** used to process data, perform analyses, or generate plots.
* **Data** required for the analysis or figure.
* **Intermediate or processed files**, where applicable.
* Other supporting files needed to reproduce the figure.

### `Supplement/`

Contains code and data associated with the supplementary figures and analyses. As with the main figure folders, names indicate the relevant analysis title as opposed to the figure number and panel.

## Using the Code

Comments are included within the code files to provide guidance on their use. These comments describe, where relevant, required inputs, expected file locations, parameters, and steps needed to run the analysis or reproduce the associated figure.

To reproduce a particular figure:

1. Navigate to the corresponding figure folder.
2. Identify the code file(s) associated with the desired figure or panel.
3. Review the comments within the code before running it.
4. Ensure that the required data files are available in the expected locations.
5. Run the code according to the instructions provided in the script.

Because the exact workflow may differ between figures, users should refer to the comments in each individual code file for figure-specific instructions.

## Data

Data files are provided within the relevant figure folders and/or the `Supplement/` folder. File names are intended to indicate the figure or panel with which the data are associated.

## Reproducibility

The repository is intended to provide the code and data necessary to reproduce the key analyses and figures reported in the paper. The organization by figure is designed to make it straightforward to identify the materials associated with each figure and its individual panels.

## Contact

For questions about the code, data, or reproduction analyses and figures, please contact the corresponding authors on the accompanying publication.

## License

The contents of this repository are distributed under the license provided in [`LICENSE`](LICENSE).
