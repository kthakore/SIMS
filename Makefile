
all:
	rubber -d --into=build/ proposal.tex

clean:
	rm build/proposal.aux build/proposal.bbl build/proposal.blg build/proposal.log build/proposal.out build/proposal.pdf

run: all
	evince build/proposal.pdf &

