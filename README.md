[![make build](https://github.com/thomasWeise/latexgit_tex/actions/workflows/build.yaml/badge.svg)](https://github.com/thomasWeise/latexgit_tex/actions/workflows/build.yaml)

# latexgit: Accessing Git Repositories from LaTeX

- [Introduction](#1-introduction)
- [Installation](#2-installation)
- [Files](#3-files)
- [License](#4-license)
- [Contact](#5-contact)


## 1. Introduction
`latexgit` is a LaTeX package that works in combination with a [preprocessor](https://thomasweise.github.io/latexgit_py) for accessing files from `git` repositories from `LaTeX`.
It works somewhat like BibTeX:
In your LaTeX document, you first can define requests to load files from `git` repositories.
During your first LaTeX compilation, these requests just evaluate to dummy results.
They are, however, stored in that `aux` file of your project, say `article.aux`.
Then you execute `python3 -m latexgit.aux article` (pretty much as you would execute `bibtex article` for building a bibliography).
This Python package will then perform the actual `git` requests and update the `aux` file.
In your next LaTeX pass, you can now access the contents of these files.
This process is described in detail in the [documentation](https://thomasweise.github.io/latexgit_tex/latexgit.pdf). 

## 2. Installation and Usage
1. Install the Python package `latexgit` via `pip install latexgit`
2. Download and copy [`latexgit.sty`](https://thomasweise.github.io/latexgit_tex/latexgit.sty) from <https://thomasweise.github.io/latexgit_tex/latexgit.sty> into the folder of your LaTeX project *or* unpack [`latexgit.tds.zip`](https://thomasweise.github.io/latexgit_tex/latexgit.tds.zip) into your TeX tree<sup>[1](https://ctan.org/TDS-guidelines)</sup> as described [here](https://texfaq.org/FAQ-inst-tds-zip) or [here](https://tex.stackexchange.com/questions/30307). 
3. Find the usage of the `latexgit` LaTeX package described in [`latexgit.pdf`](https://thomasweise.github.io/latexgit_tex/latexgit.pdf) at <https://thomasweise.github.io/latexgit_tex/latexgit.pdf>. 
4. Optionally: Read the [documentation](https://thomasweise.github.io/latexgit_py) of the `latexgit` Python companion at <https://thomasweise.github.io/latexgit_py>.

To sum up things briefly:
If you use the command `\gitLoad{myRepoUrl}{myFilePath}{myPostProcessor}`, then our package will download the file at path `myFilePath` relative to the root of the `git` repository available at URL `myRepoUrl`.
If `myPostProcessor` is left empty, the file is provided as-is at the path `\gitFile` which will automatically by defined by `\gitLoad`.
If not left empty, `myPostProcessor` is executed as command in the shell, the downloaded file is piped into its `stdin`, and whatever the command writes to its `stdout` will become available as file pointed to by `\gitFile`.
You can then include this file or load it as code listing.
Again, please read the [documentation](https://thomasweise.github.io/latexgit_tex/latexgit.pdf).

If your main document was stored as `article.tex`, you would build it using (at least) the three following steps:
1. `pdflatex article`
2. `python3 -m latexgit.aux article`
3. `pdflatex article`

## 3. Files
Below, we provide a list of files that may be interesting to look at.

1. `latexgit.dtx` is the main source file of the package [[html](https://thomasweise.github.io/latexgit_tex/latexgit_dtx.html)] | [[raw](https://thomasweise.github.io/latexgit_tex/latexgit.dtx)]
2. `latexgit.ins` is the installation script of the package [[html](https://thomasweise.github.io/latexgit_tex/latexgit_ins.html)] | [[raw](https://thomasweise.github.io/latexgit_tex/latexgit.ins)]
3. `latexgit.sty` is the compiled style file [[html](https://thomasweise.github.io/latexgit_tex/latexgit_sty.html)] | [[raw](https://thomasweise.github.io/latexgit_tex/latexgit.sty)]
4. [`latexgit.tds.zip`](https://thomasweise.github.io/latexgit_tex/latexgit.tds.zip) is a [TDS packaged](https://ctan.org/TDS-guidelines) version of our package.
   In other words, it is an <em>a `.zip` file that is ready to unzip into a user's TeX tree</em><sup>[1](https://ctan.org/TDS-guidelines)</sup>.
   This may be done as described [here](https://texfaq.org/FAQ-inst-tds-zip) or [here](https://tex.stackexchange.com/questions/30307).
5. [`latexgit.pdf`](https://thomasweise.github.io/latexgit_tex/latexgit.pdf) is the documentation of the package [[pdf](https://thomasweise.github.io/latexgit_tex/latexgit.pdf)]
6. [`LICENSE.html`](https://thomasweise.github.io/latexgit_tex/LICENSE.html) holds the license information for the package [[html](https://thomasweise.github.io/latexgit_tex/LICENSE.html)]
7. `Makefile` is the make file with the build process [[html](https://thomasweise.github.io/latexgit_tex/Makefile.html)] | [[raw](https://thomasweise.github.io/latexgit_tex/Makefile)]
8. `requirements.txt` holds the Python requirements for using the package [[html](https://thomasweise.github.io/latexgit_tex/requirements.html)] | [[txt](https://thomasweise.github.io/latexgit_tex/requirements.txt)]
9. `requirements-dev.txt` holds the Python requirements for building the package [[html](https://thomasweise.github.io/latexgit_tex/requirements-dev.html)] | [[txt](https://thomasweise.github.io/latexgit_tex/requirements-dev.txt)]

## 4. License
[`latexgit`](https://thomasweise.github.io/latexgit_py) is a tool for accessing files in `git` repositories from `LaTeX`.

Copyright (C) 2023 [Thomas Weise](http://iao.hfuu.edu.cn/5) (汤卫思教授)

Dr. Thomas Weise (see [Contact](#4-contact)) holds the copyright of this package.
The package and its documentation are under the LaTeX Project Public  License, version 1.3, which may be found online at <http://www.latex-project.org/lppl.txt> or at <https://thomasweise.github.io/latexgit_tex/LICENSE.html>.

## 5. Contact
If you have any questions or suggestions, please contact
Prof. Dr. [Thomas Weise](http://iao.hfuu.edu.cn/5) (汤卫思教授) of the 
Institute of Applied Optimization (应用优化研究所, [IAO](http://iao.hfuu.edu.cn)) of the
School of Artificial Intelligence and Big Data ([人工智能与大数据学院](http://www.hfuu.edu.cn/aibd/)) at
[Hefei University](http://www.hfuu.edu.cn/english/) ([合肥学院](http://www.hfuu.edu.cn/)) in
Hefei, Anhui, China (中国安徽省合肥市) via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).
