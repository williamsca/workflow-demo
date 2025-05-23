%.pdf: %.tex
	pdflatex $*
	bibtex $*
	pdflatex $*
	pdflatex $*

# Clean target
.PHONY: clean

clean:
	rm -f paper.pdf
	rm -f Rplots.pdf
	rm -f .RData
	rm -f *.aux
	rm -f *.log
	rm -f *.gz
	rm -f *.out
	rm -f *.bbl
	rm -f *.blg
