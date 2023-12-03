# the default goal is build
.DEFAULT_GOAL := build

# Set the shell to bash
SHELL := /bin/bash

# Get the current working directory
CWD := $(shell pwd)

# Get the latexgit version.
VERSION := $(shell (less '$(CWD)/latexgit.dtx' | sed -n 's/.*\\ProvidesPackage{latexgit}\[[0-9\/]* *\([.0-9]*\) .*\].*/\1/p'))

# Get the current date and time
NOW = $(shell date +'%0Y-%0m-%0d %0R:%0S')

# Print the status information.
status:
	echo "$(NOW): working directory: '$(CWD)'." &&\
	echo "$(NOW): latexgit version to build: '$(VERSION)'." &&\
	echo "$(NOW): shell: '$(SHELL)'"

pre_clean: status
	echo "$(NOW): Deleting all temporary, intermediate, and generated files before the build." && \
    rm -rf website &&\
	rm latexgit.aux || true &&\
	rm latexgit.glo || true &&\
	rm latexgit.gls || true &&\
	rm latexgit.idx || true &&\
	rm latexgit.ilg || true &&\
	rm latexgit.ind || true &&\
	rm latexgit.latexgit.dummy || true &&\
	rm latexgit.log || true &&\
	rm latexgit.out || true &&\
	rm latexgit.pdf || true &&\
	rm latexgit.sty || true &&\
	rm latexgit.toc || true &&\
	rm -rf examples/*.log &&\
	rm -rf examples/*.aux &&\
	rm -rf examples/*.pdf &&\
	echo "$(NOW): Done deleting all temporary, intermediate, and generated files before the build."


# Initialization: Install all Python requirements, both for executing and building the library.
python_dependencies: pre_clean
	echo "$(NOW): Initialization: first install required packages from requirements.txt." && \
	pip install --no-input --timeout 360 --retries 100 -r requirements.txt && ## nosem \
	echo "$(NOW): Finished installing required packages from requirements.txt, now installing packages required for development from requirements-dev.txt." && \
	pip install --no-input --timeout 360 --retries 100 -r requirements-dev.txt && ## nosem \
	echo "$(NOW): Finished installing requirements from requirements-dev.txt, now printing all installed packages." &&\
	pip freeze &&\
	echo "$(NOW): Finished printing all installed packages."

post_clean: extract build_documentation build_examples build_website pre_clean python_dependencies status
	echo "$(NOW): Deleting all temporary and intermediate files after the build." && \
	rm latexgit.aux &&\
	rm latexgit.glo &&\
	rm latexgit.gls &&\
	rm latexgit.idx &&\
	rm latexgit.ilg &&\
	rm latexgit.ind &&\
	rm latexgit.latexgit.dummy || true &&\
	rm latexgit.log &&\
	rm latexgit.out &&\
	rm latexgit.toc &&\
	rm -rf examples/*.log &&\
	rm -rf examples/*.aux &&\
	echo "$(NOW): Done deleting all temporary and intermediate files after the build."

extract: pre_clean
	echo "$(NOW): Now extracting the package." &&\
	pdflatex latexgit.ins &&\
	rm latexgit.log &&\
	echo "$(NOW): Finished extracting the package."

build_examples: extract python_dependencies
	echo "$(NOW): Now building the examples." &&\
	cp latexgit.sty examples &&\
	cd examples &&\
	pdflatex example_1.tex &&\
	python3 -m latexgit.aux example_1 &&\
	pdflatex example_1.tex &&\
	rm example_1.log &&\
	rm example_1.aux &&\
	rm example_1.latexgit.dummy &&\
	pdflatex example_2.tex &&\
	python3 -m latexgit.aux example_2 &&\
	pdflatex example_2.tex &&\
	rm example_2.log &&\
	rm example_2.aux &&\
	rm example_2.latexgit.dummy &&\
	rm example_2.out &&\
	rm latexgit.sty &&\
	cd .. &&\
	echo "$(NOW): Finished building the examples."

build_documentation: extract build_examples
	echo "$(NOW): Now building the documentation." &&\
	pdflatex latexgit.dtx &&\
	pdflatex latexgit.dtx &&\
	makeindex -s gglo.ist -o latexgit.gls latexgit.glo &&\
	makeindex -s gind.ist -o latexgit.ind latexgit.idx &&\
	pdflatex latexgit.dtx &&\
	echo "$(NOW): Done building the documentation."

build_website: build_documentation
	echo "$(NOW): Now building the website." &&\
	mkdir -p website &&\
	echo "$(NOW): Now copying LICENSE and other files." &&\
	pygmentize -f html -l latex -O full -O style=default -o website/latexgit_sty.html latexgit.sty &&\
	pygmentize -f html -l latex -O full -O style=default -o website/latexgit_dtx.html latexgit.dtx &&\
	pygmentize -f html -l latex -O full -O style=default -o website/latexgit_ins.html latexgit.ins &&\
	pygmentize -f html -l text -O full -O style=default -o website/LICENSE.html LICENSE &&\
	pygmentize -f html -l text -O full -O style=default -o website/requirements.html requirements.txt &&\
	pygmentize -f html -l text -O full -O style=default -o website/requirements-dev.html requirements-dev.txt &&\
	pygmentize -f html -l make -O full -O style=default -o website/Makefile.html Makefile &&\
	echo "$(NOW): Finished creating additional files, now building index.html from README.md." &&\
	export PART_A='<!DOCTYPE html><html><title>' &&\
	export PART_B='</title><body>' &&\
	export PART_C='</body></html>' &&\
	export BASE_URL='https\:\/\/thomasweise\.github\.io\/latexgit_tex\/' &&\
	echo "$${PART_A}Contributing to latexgit$${PART_B}$(shell (python3 -m markdown -o html ./README.md))$$PART_C" > ./website/index.html &&\
	sed -i "s/\"$$BASE_URL/\".\//g" ./website/index.html &&\
	sed -i "s/=$$BASE_URL/=.\//g" ./website/index.html &&\
	echo "$(NOW): Finished copying README.md to index.html, now minifying all files." &&\
	cd "website/" &&\
	find -type f -name "*.html" -exec python3 -c "print('{}');import minify_html;f=open('{}','r');s=f.read();f.close();s=minify_html.minify(s,do_not_minify_doctype=True,ensure_spec_compliant_unquoted_attribute_values=True,keep_html_and_head_opening_tags=False,minify_css=True,minify_js=True,remove_bangs=True,remove_processing_instructions=True);f=open('{}','w');f.write(s);f.close()" \; &&\
	cd "../" &&\
	echo "$(NOW): Finished minifying all files, now copying or moving remaining files." &&\
	mv latexgit.sty website &&\
	mv latexgit.pdf website &&\
	cp latexgit.dtx website &&\
	cp latexgit.ins website &&\
	touch website/.nojekyll &&\
	echo "$(NOW): Done building the website."

# The meta-goal for a full build
build: build_documentation build_examples build_website extract status pre_clean post_clean python_dependencies
	echo "$(NOW): The build has completed."

# .PHONY means that the targets init and test are not associated with files.
# see https://stackoverflow.com/questions/2145590
.PHONY: build build_documentation build_examples build_website extract status pre_clean post_clean python_dependencies
