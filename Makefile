.PHONY: all clean archive zip

PACKAGE := miniview-comp
CLS_FILE := acmart.cls

all: $(PACKAGE).pdf

TEX_FILES := $(wildcard *.tex)

%.pdf: %.tex $(TEX_FILES)  $(CLS_FILE)  ACM-Reference-Format.bst
	cd $(dir $@) && pdflatex $(notdir $<)
	- cd $(dir $@) && bibtex $(notdir $(basename $<))
	cd $(dir $@) && pdflatex $(notdir $<)
	cd $(dir $@) && pdflatex $(notdir $<)
	while ( grep -q '^LaTeX Warning: Label(s) may have changed' $(basename $<).log) \
	do cd $(dir $@) && pdflatex $(notdir $<); done

.PRECIOUS: %.cls
%.cls:   %.ins %.dtx
	pdflatex $<

clean:
	$(RM) *.log *.aux \
	*.cfg *.glo *.idx *.toc \
	*.ilg *.ind *.out *.lof \
	*.lot *.bbl *.blg *.gls *.cut *.hd \
	*.dvi *.ps *.thm *.tgz *.zip *.rpi

archive:  all clean
	COPYFILE_DISABLE=1 tar -C .. -czvf ../$(PACKAGE).tgz --exclude '*~' --exclude '*.tgz' --exclude '*.zip'  --exclude CVS --exclude '.git*' paper; mv ../$(PACKAGE).tgz .

zip:  all clean
	zip -r  $(PACKAGE).zip * -x '*~' -x '*.tgz' -x '*.zip' -x CVS -x 'CVS/*'
