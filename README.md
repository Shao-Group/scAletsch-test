# Overview

This repository tests and compares the performance of single-cell transcript assembler
[**scAletsch**](https://github.com/Shao-Group/aletsch) with other three leading meta-assemblers at individual-level,
[Psiclass](https://github.com/splicebox/PsiCLASS),
[TransMeta](https://github.com/yutingsdu/TransMeta) and
[Aletsch](https://github.com/Shao-Group/aletsch).
Here we provide instructions to download and link all necessary tools, we also provide scripts to download datasets, run the four methods, evaluated the
predicted transcripts, and reproduce the results and figures in the Scallop2 paper.

The pipeline involves in the following four steps:
1. Download and/or compile necessary tools (`programs` directory).
2. Download necessary datasets (`data` directory).
3. Run the methods to produce results (`results` directory).
4. Summarize results and produce figures (`plots` directory).
