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

post_clean: build_documentation build_examples extract pre_clean status
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

build_examples: extract
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

# The meta-goal for a full build
build: build_documentation build_examples status pre_clean extract post_clean
	echo "$(NOW): The build has completed."

# .PHONY means that the targets init and test are not associated with files.
# see https://stackoverflow.com/questions/2145590
.PHONY: build build_documentation build_examples status pre_clean extract post_clean
