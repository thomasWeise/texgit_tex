# texgit: Download, access, and potentially execute files from git repositories to access them or their output from LaTeX.

- [Introduction](#1-introduction)
- [Installation and Usage](#2-installation-and-usage)
- [Files](#3-files)
- [License](#4-license)
- [Contact](#5-contact)

The `texgit` package allows you to do the following things

- download files from a `git` repository and access them from LaTeX,
- apply some post-processor to the downloaded files (e.g., strip comments and type hints from Python code) and access the post-processed files instead,
- execute scripts or programs &mdash; either local or downloaded from `git` repositories &mdash; and fetch their output into local files accessible from LaTeX,
- create local paths accessible from LaTeX which can be passed as arguments to the scripts or programs that are executed, e.g., as argument to a Python script that creates and stores a `matplotlib` plot under the path that it received as argument, allowing you to programmatically create figures and include them LaTeX documents.

The package works a bit like `BibTeX`:
Let's say your document is named `document.tex`.
During the first `pdflatex` run, executed as `pdflatex document`, all the requests mentioned above, say, to download files from `git` repositories, are stored in the `aux` file.
The paths corresponding to the requests point to an empty file at this stage.
Then you would apply the `texgit` post-processor by calling `python3 -m texgit.run document`.
This [Python program](https://pypi.org/project/texgit) executes all the requests and caches their results locally.
During the second run of `pdflatex document`, the paths corresponding to the requests then point to the actual downloaded or generated files.

All downloaded or generated files will be locally cached in a folder named `__git__`.
You can delete this folder to refresh the files.

**This LaTeX package requires a companion Python package to work.**
Please see [Installation and Usage](#2-installation-and-usage).

## 1. Introduction
This package allows you to download and access files that reside in a `git` repository from within your LaTeX code.
This can be used, for example, to include program code from an actual software in life repository in your LaTeX documents.
It allows you to postprocess these files, e.g., to apply programs that remove comments or reformat code and then to include these postprocessed files.
It furthermore allows you to execute programs (or scripts from `git` repositories) on your machine and include their output into your LaTeX
documents.
Finally, it also allows you to allocate files and pass them as parameters to the programs that you execute.
With this, you could create PDF figures on the fly and then include them into your LaTeX documents.

This LaTeX package works \emph{only} in combination with the Python package [`texgit`](https://github.com/thomasWeise/texgit_py).
To implement its functionality, it offers the following commands:

- `\gitLoad{id}{repoURL}{pathInRepo}{postproc}` loads a file `pathInRepo` from the `git` repository `repoURL`, *optionally* post-processes it by piping its contents into the standard input of a command `postproc` capturing its standard output.

- `\gitFile{id}` provides a local path to a file created this way.
   Using the `\gitFile{id}` macro, you can then include the file in LaTeX directly or load it as source code listing.

- `\gitUrl{id}` provides the URL to the original file in the `git` repository.

- `\gitExec{id}{repoURL}{pathInRepo}{command}` executes an arbitrary command `command`, either in the current directory or inside a directory `pathInRepo` of the `git` repository `repoURL` and fetches the standard output into a local file, the path to which is made available to the file again as macro `\gitFile{id}`.

- `\gitArg{id}{prefix}{suffix}` allocates an additional file, whose name will be composed of the optional `prefix` and `suffix`. 
  Such files can be passed as arguments to `\gitExec` or `\gitLoad`\tbindex{gitLoad} by including `(?id?)` in their commands' argument list. 
  This way, we can, for example, instruct a program to create a graphic and store it in a certain file that we can later load from `\gitFile{id}`.

- `\gitName{id}` provides the name of the original file in the `git` repository.
- 
- `\gitNameEsc{id}` provides the name of the original file in the `git` repository, but with some special characters escaped.
  This makes it easy to include the file name in LaTeX documents.

- `\gitIf{id}{ifDone}{ifNotDone}` executes the code `ifDone` starting  in the second `pdflatex` pass, i.e., after the Python `texgit` package has been applied to the `aux` file generated during the first `pdflatex` pass.
  During the first `pdflatex` pass and before the Python `texgit` package was applied, `ifNotDone` will be executed.

The functionality of the package is implemented by storing the `git` requests in the `aux` file of the project during the first `pdflatex` pass.
The `aux` file is then processed by the Python package [`texgit`](https://github.com/thomasWeise/texgit_py) which performs the actual `git` queries, program executions, stores the result in local files, and adds the resolved paths to the `aux` file.
Thus, during the first `pdflatex` run, `\gitFile` and `\gitUrl` offer dummy results.
During the second and later pass, after the Python program `texgit` has been applied to the `aux` file, they then provide the actual paths and URLs.

`texgit` is a LaTeX package that works in combination with a [Python companion](https://thomasweise.github.io/texgit_py) package for accessing files located in `git` repositories from within LaTeX.
It works somewhat like BibTeX:
In your LaTeX document, you first can define requests to load files from `git` repositories.
During your first LaTeX compilation, these requests just evaluate to dummy results.
They are, however, stored in that `aux` file of your project, say `article.aux`.
Then you execute `python3 -m texgit.run article` (pretty much as you would execute `bibtex article` for building a bibliography).
This Python package will then perform the actual `git` requests and update the `aux` file.
In your next LaTeX pass, you can now access the contents of these files.
This process is described in detail in the [documentation](https://thomasweise.github.io/texgit_tex/texgit.pdf). 

## 2. Installation and Usage
1. Install the Python package `texgit` via `pip install texgit`.
2. Make sure that `git` is installed.
   On Ubuntu Linux, you could install it via `sudo apt-get install git`.
3. Download and copy [`texgit.sty`](https://thomasweise.github.io/texgit_tex/texgit.sty) from <https://thomasweise.github.io/texgit_tex/texgit.sty> into the folder of your LaTeX project *or* unpack [`texgit.tds.zip`](https://thomasweise.github.io/texgit_tex/texgit.tds.zip) into your TeX tree<sup>[1](https://ctan.org/TDS-guidelines)</sup> as described [here](https://texfaq.org/FAQ-inst-tds-zip) or [here](https://tex.stackexchange.com/questions/30307). 
4. Find the recommended usage and use cases of the `texgit` LaTeX package described in [`texgit.pdf`](https://thomasweise.github.io/texgit_tex/texgit.pdf) at <https://thomasweise.github.io/texgit_tex/texgit.pdf>. 
5. Optionally: Read the [documentation](https://thomasweise.github.io/texgit_py) of the `texgit` Python companion at <https://thomasweise.github.io/texgit_py>.

To sum up things briefly:
If you use the command `\gitLoad{id}{myRepoUrl}{myFilePath}{myPostProcessor}`, then our package will download the file at path `myFilePath` relative to the root of the `git` repository available at URL `myRepoUrl`.
If `myPostProcessor` is left empty, the file is provided as-is at the path `\gitFile{id}`.
If not left empty, `myPostProcessor` is executed as command in the shell, the downloaded file is piped into its `stdin`, and whatever the command writes to its `stdout` will become available as file pointed to by `\gitFile{id}`.
You can then include this file via `\input{\gitFile{id}}` or load it as code listing from path `\gitFile{id}`.
Again, please read the [documentation](https://thomasweise.github.io/texgit_tex/texgit.pdf).

If your main document was stored as `article.tex`, you would build it using (at least) the three following steps:

1. `pdflatex article`
2. `python3 -m texgit.run article`
3. `pdflatex article`

During the first `pdflatex` run, all the requests to `texgit` are collected (and stored in the `aux` file).
Calls to `\gitPath{...}` return the path to an empty dummy file.
In the second step, `python3 -m texgit.run article`, the Python companion package is applied, reads the `aux` file, executes all the queries, and assigns proper paths to their results to them.
In the second `pdflatex` run, `\gitFile` now returns the paths to the correctly downloaded and processed files.

## 3. Files
Below, we provide a list of files that may be interesting to look at.

1. `texgit.dtx` is the main source file of the package [[html](https://thomasweise.github.io/texgit_tex/texgit_dtx.html)] | [[raw](https://thomasweise.github.io/texgit_tex/texgit.dtx)]
2. `texgit.ins` is the installation script of the package [[html](https://thomasweise.github.io/texgit_tex/texgit_ins.html)] | [[raw](https://thomasweise.github.io/texgit_tex/texgit.ins)]
3. `texgit.sty` is the compiled style file [[html](https://thomasweise.github.io/texgit_tex/texgit_sty.html)] | [[raw](https://thomasweise.github.io/texgit_tex/texgit.sty)]
4. [`texgit.zip`](https://thomasweise.github.io/texgit_tex/texgit.zip) is a zipped version of our package in the format that can be submitted to <https://ctan.org/upload>.
5. [`texgit.tds.zip`](https://thomasweise.github.io/texgit_tex/texgit.tds.zip) is a [TDS packaged](https://ctan.org/TDS-guidelines) version of our package.
   In other words, it is an <em>a `.zip` file that is ready to unzip into a user's TeX tree</em><sup>[1](https://ctan.org/TDS-guidelines)</sup>.
   This may be done as described [here](https://texfaq.org/FAQ-inst-tds-zip) or [here](https://tex.stackexchange.com/questions/30307).
6. [`texgit.pdf`](https://thomasweise.github.io/texgit_tex/texgit.pdf) is the documentation of the package [[pdf](https://thomasweise.github.io/texgit_tex/texgit.pdf)]
7. [`LICENSE.html`](https://thomasweise.github.io/texgit_tex/LICENSE.html) holds the license information for the package [[html](https://thomasweise.github.io/texgit_tex/LICENSE.html)]
8. `make.sh` is the script with the build process [[html](https://thomasweise.github.io/texgit_tex/make.html)] | [[raw](https://thomasweise.github.io/texgit_tex/make.sh)]
9. `make_venv.sh` creates a virtual environment with the required Python packages installed [[html](https://thomasweise.github.io/texgit_tex/make_venv.html)] | [[raw](https://thomasweise.github.io/texgit_tex/make_venv.sh)]
10. `requirements.txt` holds the Python requirements for using the package [[html](https://thomasweise.github.io/texgit_tex/requirements.html)] | [[txt](https://thomasweise.github.io/texgit_tex/requirements.txt)]
11. `requirements-all.txt` holds the exact versions of the Python packages that were used when building the current version and documentation [[html](https://thomasweise.github.io/texgit_tex/requirements-all.html)] | [[txt](https://thomasweise.github.io/texgit_tex/requirements-all.txt)]
12. `requirements-dev.txt` holds the Python requirements for building the package [[html](https://thomasweise.github.io/texgit_tex/requirements-dev.html)] | [[txt](https://thomasweise.github.io/texgit_tex/requirements-dev.txt)]

## 4. License
[`texgit`](https://thomasweise.github.io/texgit_py) is a tool for accessing files in `git` repositories from `LaTeX`.

Copyright (C) 2023&mdash;2025 Thomas Weise (汤卫思教授)

Dr. Thomas Weise (see [Contact](#4-contact)) holds the copyright of this package.
The package and its documentation are under the LaTeX Project Public License, version 1.3, which may be found online at <http://www.latex-project.org/lppl.txt> or at <https://thomasweise.github.io/texgit_tex/LICENSE.html>.

## 5. Contact
If you have any questions or suggestions, please contact
Prof. Dr. Thomas Weise (汤卫思教授) of the 
Institute of Applied Optimization (应用优化研究所, IAO) of the
School of Artificial Intelligence and Big Data ([人工智能与大数据学院](http://www.hfuu.edu.cn/aibd/)) at
[Hefei University](http://www.hfuu.edu.cn/english/) ([合肥大学](http://www.hfuu.edu.cn/)) in
Hefei, Anhui, China (中国安徽省合肥市) via
email to [tweise@hfuu.edu.cn](mailto:tweise@hfuu.edu.cn) with CC to [tweise@ustc.edu.cn](mailto:tweise@ustc.edu.cn).
