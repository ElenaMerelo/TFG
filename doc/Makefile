DOC := proyecto.tex

all: doc

doc: $(DOC:.tex=.pdf)

all: proyecto.pdf

%.pdf: %.tex
	pdflatex $< && bibtex $* && pdflatex $< && pdflatex $<

# Corrector ortográfico
spell:
	bash ./scripts/spell-check.sh

install-spell:
	sudo apt-get install aspell aspell-es aspell-en

order-dic:
	./scripts/order-dictionary.py

workflow-spell: install-spell spell

