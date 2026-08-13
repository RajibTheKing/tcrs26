# Main LaTeX file (without .tex extension)
# Main LaTeX file (without .tex extension)
MAIN = tcrs26

PDF = $(MAIN).pdf

ifeq ($(OS),Windows_NT)
    CLEAN_CMD = -del /Q /F *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.out *.toc *.lof *.lot *.nav *.snm *.synctex.gz tcrs26.pdf 2>nul
else
    CLEAN_CMD = rm -f *.aux *.bbl *.blg *.fdb_latexmk *.fls *.log *.out *.toc *.lof *.lot *.nav *.snm *.synctex.gz tcrs26.pdf
endif

.PHONY: all clean rebuild

all: $(PDF)

$(PDF): $(MAIN).tex
	pdflatex -interaction=nonstopmode $(MAIN).tex
	bibtex $(MAIN)
	pdflatex -interaction=nonstopmode $(MAIN).tex
	pdflatex -interaction=nonstopmode $(MAIN).tex

clean:
	$(CLEAN_CMD)

rebuild: clean all