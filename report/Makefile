images =  $(addsuffix .pdf, $(basename $(wildcard images/*.svg)))
images += $(addsuffix .pdf, $(basename $(wildcard images/*.eps)))

default: ${images}
	rst2latex.py report.rst | ./transform.rb | rubber-pipe --pdf > ../report.pdf
	open ../report.pdf

images/%.pdf: images/%.svg
	svg2pdf $< $@

images/%.pdf: images/%.eps
	epstopdf $<

view:
	zsh -c 'view <( rst2latex.py report.rst 2>/dev/null | ./transform.rb )'

clean:
	rm rubtmp?.*
