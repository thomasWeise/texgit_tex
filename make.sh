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
# Get the texgit version.
version="$(less "$currentDir/texgit.dtx" | sed -n 's/.*\\ProvidesPackage{texgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p')"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The texgit version is: '$version'."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting all temporary, intermediate, and generated files before the build."
rm -rf website || true
rm texgit.aux || true
rm texgit.glo || true
rm texgit.gls || true
rm texgit.hd || true
rm texgit.idx || true
rm texgit.ilg || true
rm texgit.ind || true
rm texgit.texgit.dummy || true
rm texgit.log || true
rm texgit.out || true
rm texgit.pdf || true
rm texgit.sty || true
rm texgit.toc || true
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
pdflatex texgit.ins
rm texgit.log
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished extracting the package."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the examples."
cp texgit.sty examples
cd examples
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 1."
pdflatex example_1.tex
"$PYTHON_INTERPRETER" -m texgit.run example_1
pdflatex example_1.tex
rm example_1.log
rm example_1.aux
rm example_1.texgit.dummy
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 2."
pdflatex example_2.tex
"$PYTHON_INTERPRETER" -m texgit.run example_2
pdflatex example_2.tex
rm example_2.log
rm example_2.aux
rm example_2.texgit.dummy
rm example_2.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 3."
pdflatex example_3.tex
"$PYTHON_INTERPRETER" -m texgit.run example_3
pdflatex example_3.tex
rm example_3.log
rm example_3.aux
rm example_3.texgit.dummy
rm example_3.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 4."
pdflatex example_4.tex
"$PYTHON_INTERPRETER" -m texgit.run example_4
pdflatex example_4.tex
rm example_4.log
rm example_4.aux
rm example_4.texgit.dummy
rm example_4.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 5."
pdflatex example_5.tex
"$PYTHON_INTERPRETER" -m texgit.run example_5
pdflatex example_5.tex
rm example_5.log
rm example_5.aux
rm example_5.texgit.dummy
rm example_5.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 6."
pdflatex example_6.tex
"$PYTHON_INTERPRETER" -m texgit.run example_6
pdflatex example_6.tex
rm example_6.log
rm example_6.aux
rm example_6.texgit.dummy
rm example_6.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 7."
pdflatex example_7.tex
"$PYTHON_INTERPRETER" -m texgit.run example_7
pdflatex example_7.tex
rm example_7.log
rm example_7.aux
rm example_7.texgit.dummy
rm example_7.out
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the example 8."
pdflatex example_8.tex
"$PYTHON_INTERPRETER" -m texgit.run example_8
pdflatex example_8.tex
rm example_8.log
rm example_8.aux
rm example_8.texgit.dummy
rm example_8.out
rm texgit.sty
cd ..
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished building the examples."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the documentation."
pdflatex texgit.dtx
"$PYTHON_INTERPRETER" -m texgit.run texgit
pdflatex texgit.dtx
"$PYTHON_INTERPRETER" -m texgit.run texgit
makeindex -s gglo.ist -o texgit.gls texgit.glo
makeindex -s gind.ist -o texgit.ind texgit.idx
pdflatex texgit.dtx
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building the documentation."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now building the website."
mkdir -p website
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now copying LICENSE and other files."
pygmentize -f html -l latex -O full -O style=default -o website/texgit_sty.html texgit.sty
pygmentize -f html -l latex -O full -O style=default -o website/texgit_dtx.html texgit.dtx
pygmentize -f html -l latex -O full -O style=default -o website/texgit_ins.html texgit.ins
pygmentize -f html -l text -O full -O style=default -o website/LICENSE.html LICENSE
pygmentize -f html -l text -O full -O style=default -o website/requirements.html requirements.txt
pygmentize -f html -l text -O full -O style=default -o website/requirements-dev.html requirements-dev.txt
pygmentize -f html -l Bash -O full -O style=default -o website/make.html make.sh
pygmentize -f html -l Bash -O full -O style=default -o website/make.html make_venv.sh

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Determining dependency versions (1)."
TEXGIT_VERSION="$(python3 -c "import texgit; print(texgit.__version__);")"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The version of the texgit Python package is $TEXGIT_VERSION."

deactivate
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now getting plain requirements."
venvDirPlain="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Got temp dir '$venvDirPlain', now creating environment in it."
python3 -m venv "$venvDirPlain"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Activating plain virtual environment in '$venvDirPlain'."
source "$venvDirPlain/bin/activate"
pip install "texgit==$TEXGIT_VERSION"
pip freeze --local > website/requirements-all.txt
deactivate
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting plain virtual environment."
rm -rf "$venvDirPlain"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Going back to full virtual environment."
source "$venvDir/bin/activate"
pygmentize -f html -l text -O full -O style=default -o website/requirements-all.html website/requirements-all.txt
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished creating additional files, now building index.html from README.md."
PART_A='<!DOCTYPE html><html><title>'
PART_B='</title><style>code {background-color:rgb(204 210 95 / 0.3);white-space:nowrap;border-radius:3px}</style><body style="margin-left:5%;margin-right:5%">'
PART_C='</body></html>'
BASE_URL='https\:\/\/thomasweise\.github\.io\/texgit_tex\/'
echo "${PART_A}texgit ${version}${PART_B}$("$PYTHON_INTERPRETER" -m markdown -o html ./README.md)$PART_C" > ./website/index.html
sed -i "s/\"$BASE_URL/\".\//g" ./website/index.html
sed -i "s/=$BASE_URL/=.\//g" ./website/index.html
sed -i "s/<\/h1>/<\/h1><h2>version\&nbsp;${version} build on\&nbsp;$(date +'%0Y-%0m-%0d %0R:%0S')<\/h2>/g" ./website/index.html
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished copying README.md to index.html, now minifying all files."
cd "website/"
find -type f -name "*.html" -exec "$PYTHON_INTERPRETER" -c "print('{}');import minify_html;f=open('{}','r');s=f.read();f.close();s=minify_html.minify(s,allow_noncompliant_unquoted_attribute_values=False,allow_optimal_entities=True,allow_removing_spaces_between_attributes=True,keep_closing_tags=False,keep_comments=False,keep_html_and_head_opening_tags=False,keep_input_type_text_attr=False,keep_ssi_comments=False,minify_css=True,minify_doctype=False,minify_js=True,preserve_brace_template_syntax=False,preserve_chevron_percent_template_syntax=False,remove_bangs=True,remove_processing_instructions=True);f=open('{}','w');f.write(s);f.close()" \;
cd "../"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Finished minifying all files, now copying or moving remaining files."
mv texgit.sty website
mv texgit.pdf website
cp texgit.dtx website
cp texgit.ins website
cp make.sh website
cp make_venv.sh website
cp requirements.txt website
cp requirements-dev.txt website
touch website/.nojekyll
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building the website."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now creating texgit.zip."
zipTempDir="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Created temp directory '$zipTempDir'. Now building zip."
mkdir -p "$zipTempDir/texgit/"
cp README.md "$zipTempDir/texgit/"
cp texgit.ins "$zipTempDir/texgit/"
cp texgit.dtx "$zipTempDir/texgit/"
cp website/texgit.pdf "$zipTempDir/texgit/texgit-doc.pdf"
cp website/requirements-all.txt "$zipTempDir/texgit/"

cd "$zipTempDir"
zip -9 -r "texgit.zip" *
mv "texgit.zip" "$currentDir/website"
cd "$currentDir"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building texgit.zip."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deactivating virtual environment."
deactivate
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting virtual environment."
rm -rf "$venvDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Now creating texgit.tds.zip."
tdsTempDir="$(mktemp -d)"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Created temp directory '$tdsTempDir'. Now building tds."
mkdir -p "$tdsTempDir/tex/latex/texgit/"
cp website/texgit.sty "$tdsTempDir/tex/latex/texgit/"
mkdir -p "$tdsTempDir/doc/latex/texgit/"
cp README.md "$tdsTempDir/doc/latex/texgit/"
cp website/requirements-all.txt "$tdsTempDir/doc/latex/texgit/"
cp website/index.html "$tdsTempDir/doc/latex/texgit/README.html"
cp website/texgit.pdf "$tdsTempDir/doc/latex/texgit/"
mkdir -p "$tdsTempDir/source/latex/texgit/"
cp texgit.ins "$tdsTempDir/source/latex/texgit/"
cp texgit.dtx "$tdsTempDir/source/latex/texgit/"
mkdir -p "$tdsTempDir/source/latex/texgit/examples"
cp examples/*.tex "$tdsTempDir/source/latex/texgit/examples"
cd "$tdsTempDir"
zip -9 -r "texgit.tds.zip" tex doc source
mv "texgit.tds.zip" "$currentDir/website"
cd "$currentDir"
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done building texgit.zip package."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Cleaning up temp directories."
rm -rf "$tdsTempDir"
rm -rf "$zipTempDir"

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Deleting all temporary and intermediate files after the build."
rm texgit.aux || true
rm texgit.glo || true
rm texgit.gls || true
rm texgit.hd || true
rm texgit.idx || true
rm texgit.ilg || true
rm texgit.ind || true
rm texgit.texgit.dummy || true
rm texgit.log || true
rm texgit.out || true
rm texgit.toc || true
rm -rf examples/*.log
rm -rf examples/*.aux
echo "$(date +'%0Y-%0m-%0d %0R:%0S'): Done deleting all temporary and intermediate files after the build."

echo "$(date +'%0Y-%0m-%0d %0R:%0S'): The build has completed."
