
all:
	rubber -d --into=build/ midterm.tex

clean:
	rm build/*_2* build/midterm.aux build/midterm.bbl build/midterm.blg build/midterm.log build/midterm.out build/midterm.pdf

run: all
	evince build/midterm.pdf &

