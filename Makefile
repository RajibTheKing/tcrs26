# Main LaTeX file (without .tex extension)
MAIN = main

PDF = $(MAIN).pdf

.PHONY: all clean rebuild

all: $(PDF)

$(PDF): $(MAIN).tex
	pdflatex -interaction=nonstopmode $(MAIN).tex
	bibtex $(MAIN)
	pdflatex -interaction=nonstopmode $(MAIN).tex
	pdflatex -interaction=nonstopmode $(MAIN).tex

clean:
	rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.out *.toc *.lof *.lot *.nav *.snm *.synctex.gz main.pdf

rebuild: clean all