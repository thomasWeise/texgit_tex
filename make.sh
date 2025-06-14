#!/bin/bash

# Make the book.

# strict error handling
set -o pipefail  # trace ERR through pipes
set -o errtrace  # trace ERR through 'time command' and other functions
set -o nounset   # set -u : exit the script if you try to use an uninitialized variable
set -o errexit   # set -e : exit the script if any statement returns a non-true return value

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Welcome to the building script."
currentDir="$(pwd)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We are working in directory: '$currentDir'."
# Get the latexgit version.
version="$(less "$currentDir/latexgit.dtx" | sed -n 's/.*\\ProvidesPackage{latexgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p')"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The latexgit version is: '$version'."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting all temporary, intermediate, and generated files before the build."
rm -rf website || true
rm latexgit.aux || true
rm latexgit.glo || true
rm latexgit.gls || true
rm latexgit.hd || true
rm latexgit.idx || true
rm latexgit.ilg || true
rm latexgit.ind || true
rm latexgit.latexgit.dummy || true
rm latexgit.log || true
rm latexgit.out || true
rm latexgit.pdf || true
rm latexgit.sty || true
rm latexgit.toc || true
rm -rf examples/*.log
rm -rf examples/*.aux
rm -rf examples/*.pdf
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done deleting all temporary, intermediate, and generated files before the build."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): We setup a virtual environment in a temp directory."
venvDir="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Got temp dir '$venvDir', now creating environment in it."
python3 -m venv --system-site-packages --copies "$venvDir"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Activating virtual environment in '$venvDir'."
source "$venvDir/bin/activate"
export PYTHON_INTERPRETER="$venvDir/bin/python3"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Setting python interpreter to '$PYTHON_INTERPRETER'."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Initialization: first install required packages from requirements.txt."
"$PYTHON_INTERPRETER" -m pip install --no-input --timeout 360 --retries 100 -r requirements.txt
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished installing required packages from requirements.txt, now installing packages required for development from requirements-dev.txt."
"$PYTHON_INTERPRETER" -m pip install --no-input --timeout 360 --retries 100 -r requirements-dev.txt
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished installing requirements from requirements-dev.txt, now printing all installed packages."
"$PYTHON_INTERPRETER" -m pip freeze
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished printing all installed packages."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now extracting the package."
pdflatex latexgit.ins
rm latexgit.log
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished extracting the package."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the examples."
cp latexgit.sty examples
cd examples
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 1."
pdflatex example_1.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_1
pdflatex example_1.tex
rm example_1.log
rm example_1.aux
rm example_1.latexgit.dummy
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 2."
pdflatex example_2.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_2
pdflatex example_2.tex
rm example_2.log
rm example_2.aux
rm example_2.latexgit.dummy
rm example_2.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 3."
pdflatex example_3.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_3
pdflatex example_3.tex
rm example_3.log
rm example_3.aux
rm example_3.latexgit.dummy
rm example_3.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 4."
pdflatex example_4.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_4
pdflatex example_4.tex
rm example_4.log
rm example_4.aux
rm example_4.latexgit.dummy
rm example_4.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 5."
pdflatex example_5.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_5
pdflatex example_5.tex
rm example_5.log
rm example_5.aux
rm example_5.latexgit.dummy
rm example_5.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 6."
pdflatex example_6.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_6
pdflatex example_6.tex
rm example_6.log
rm example_6.aux
rm example_6.latexgit.dummy
rm example_6.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 7."
pdflatex example_7.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_7
pdflatex example_7.tex
rm example_7.log
rm example_7.aux
rm example_7.latexgit.dummy
rm example_7.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 8."
pdflatex example_8.tex
"$PYTHON_INTERPRETER" -m latexgit.aux example_8
pdflatex example_8.tex
rm example_8.log
rm example_8.aux
rm example_8.latexgit.dummy
rm example_8.out
rm latexgit.sty
cd ..
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished building the examples."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the documentation."
pdflatex latexgit.dtx
pdflatex latexgit.dtx
makeindex -s gglo.ist -o latexgit.gls latexgit.glo
makeindex -s gind.ist -o latexgit.ind latexgit.idx
pdflatex latexgit.dtx
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building the documentation."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the website."
mkdir -p website
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now copying LICENSE and other files."
pygmentize -f html -l latex -O full -O style=default -o website/latexgit_sty.html latexgit.sty
pygmentize -f html -l latex -O full -O style=default -o website/latexgit_dtx.html latexgit.dtx
pygmentize -f html -l latex -O full -O style=default -o website/latexgit_ins.html latexgit.ins
pygmentize -f html -l text -O full -O style=default -o website/LICENSE.html LICENSE
pygmentize -f html -l text -O full -O style=default -o website/requirements.html requirements.txt
pygmentize -f html -l text -O full -O style=default -o website/requirements-dev.html requirements-dev.txt
pygmentize -f html -l Bash -O full -O style=default -o website/make.html make.sh
pygmentize -f html -l Bash -O full -O style=default -o website/make.html make_venv.sh
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished creating additional files, now building index.html from README.md."
PART_A='<!DOCTYPE html><html><title>'
PART_B='</title><style>code {background-color:rgb(204 210 95 / 0.3);white-space:nowrap;border-radius:3px}</style><body style="margin-left:5%;margin-right:5%">'
PART_C='</body></html>'
BASE_URL='https\:\/\/thomasweise\.github\.io\/latexgit_tex\/'
echo "${PART_A}latexgit ${version}${PART_B}$("$PYTHON_INTERPRETER" -m markdown -o html ./README.md)$PART_C" > ./website/index.html
sed -i "s/\"$BASE_URL/\".\//g" ./website/index.html
sed -i "s/=$BASE_URL/=.\//g" ./website/index.html
sed -i "s/<\/h1>/<\/h1><h2>version\&nbsp;${version} build on\&nbsp;$(date +'%0Y-%0m-%0d %0R:%0S')<\/h2>/g" ./website/index.html
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished copying README.md to index.html, now minifying all files."
cd "website/"
find -type f -name "*.html" -exec "$PYTHON_INTERPRETER" -c "print('{}');import minify_html;f=open('{}','r');s=f.read();f.close();s=minify_html.minify(s,allow_noncompliant_unquoted_attribute_values=False,allow_optimal_entities=True,allow_removing_spaces_between_attributes=True,keep_closing_tags=False,keep_comments=False,keep_html_and_head_opening_tags=False,keep_input_type_text_attr=False,keep_ssi_comments=False,minify_css=True,minify_doctype=False,minify_js=True,preserve_brace_template_syntax=False,preserve_chevron_percent_template_syntax=False,remove_bangs=True,remove_processing_instructions=True);f=open('{}','w');f.write(s);f.close()" \;
cd "../"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished minifying all files, now copying or moving remaining files."
mv latexgit.sty website
mv latexgit.pdf website
cp latexgit.dtx website
cp latexgit.ins website
cp make.sh website
cp make_venv.sh website
cp requirements.txt website
cp requirements-dev.txt website
touch website/.nojekyll
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building the website."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deactivating virtual environment."
deactivate
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting virtual environment."
rm -rf "$venvDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now creating latexgit.tds.zip."
tempDir="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Created temp directory '$tempDir'. Now building tds."
mkdir -p "$tempDir/tex/latex/latexgit/"
cp website/latexgit.sty "$tempDir/tex/latex/latexgit/"
mkdir -p "$tempDir/doc/latex/latexgit/"
cp README.md "$tempDir/doc/latex/latexgit/"
cp website/index.html "$tempDir/doc/latex/latexgit/README.html"
cp website/latexgit.pdf "$tempDir/doc/latex/latexgit/"
mkdir -p "$tempDir/source/latex/latexgit/"
cp latexgit.ins "$tempDir/source/latex/latexgit/"
cp latexgit.dtx "$tempDir/source/latex/latexgit/"
mkdir -p "$tempDir/source/latex/latexgit/examples"
cp examples/*.tex "$tempDir/source/latex/latexgit/examples"
cd "$tempDir"
zip -9 -r "latexgit.tds.zip" tex doc source
mv "latexgit.tds.zip" "$currentDir/website"
rm -rf "$tempDir"
cd "$currentDir"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building latexgit.tds.zip."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting all temporary and intermediate files after the build."
rm latexgit.aux || true
rm latexgit.glo || true
rm latexgit.gls || true
rm latexgit.hd || true
rm latexgit.idx || true
rm latexgit.ilg || true
rm latexgit.ind || true
rm latexgit.latexgit.dummy || true
rm latexgit.log || true
rm latexgit.out || true
rm latexgit.toc || true
rm -rf examples/*.log
rm -rf examples/*.aux
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done deleting all temporary and intermediate files after the build."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The build has completed."
