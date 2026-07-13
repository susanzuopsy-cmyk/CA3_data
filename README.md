# Figure reproducibility package

For each published figure panel: a Source Data Excel workbook (`source_data/`)
and a MATLAB script that reads it and plots the panel as PNG (`figure_scripts/`
→ `figures_repro/`).

**To reproduce the figures you only need `figure_scripts/` and the xlsx files
already included in `source_data/` — no other data files required.**

## How to run

```matlab
cd manuscript/figure_scripts
run_all_figures
```

Each `Fig*.m` script can also be run individually.

## Figures produced

| Script | Panels | Output |
|---|---|---|
| `Fig1.m` | C–H | `Fig1_C-H.png` |
| `Fig2.m` | A–K | `Fig2_A-K.png` |
| `Fig3.m` | A–I | `Fig3_A-I.png` |
| `Fig4.m` | A–I | `Fig4_A-I.png` |
| `Fig5.m` | C–H | `Fig5_C-H.png` |
| `FigS1.m` | A–D | `FigS1_A-D.png` |
| `FigS2.m` | A–B | `FigS2.png` |
| `FigS4.m` | A–F | `FigS4_A-F.png` |
| `FigS5.m` | A–C | `FigS5_A-C.png` |


## Requirements

MATLAB with Statistics and Machine Learning Toolbox.
