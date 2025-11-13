SVGFILES := $(wildcard ../graphics/*.svg)
PDFFILES := $(patsubst ../graphics/%.svg,%.pdf,$(SVGFILES))

all-pdfs: $(PDFFILES)

%.pdf : ../graphics/%.svg
	rsvg-convert -f pdf -d 300 -p 300 -o $@ $<

clean:
	rm -f $(PDFFILES)

.PHONY: all-pdfs clean