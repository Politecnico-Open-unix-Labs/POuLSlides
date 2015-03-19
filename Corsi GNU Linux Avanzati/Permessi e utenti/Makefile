.PHONY: all source images

PRESENTATION = 2015-03-17-advance_linux_permssions

all: $(PRESENTATION).pdf

source: $(PRESENTATION)-src.tar.gz

IMGS = \
        images/poul-logo.pdf \

$(PRESENTATION).pdf: slides.md header.tex $(IMGS)
	pandoc -t beamer \
		--include-in-header=header.tex \
		--variable=fontsize=14pt \
		--latex-engine=lualatex -o $@ $<

%.pdf: %.svg
	inkscape --export-pdf=$@ --export-dpi=600 $<

SRCS = \
	$(shell find . -maxdepth 1 '(' -name '$(PRESENTATION).GNUMakefile' -o -name 'Makefile' ')' -printf '%P\n') \
	slides.md header.tex $(IMGS)

$(PRESENTATION)-src.tar.gz: $(SRCS)
	tar -zcvf $@ --transform 's,$(PRESENTATION)\.GNUMakefile,Makefile,;s,^,$(PRESENTATION)/,' $(SRCS)
