SVGFILES := $(wildcard *.svg)

all-pdfs: $(SVGFILES:%.svg=%.pdf)

%.pdf : %.svg
	inkscape -A $*.pdf $*.svg