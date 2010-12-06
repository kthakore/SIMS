
all: midterm

sds:
	rubber -d --into=build/ sds.tex

srs:
	rubber -d --into=build/  srs.tex

midterm:
	rubber -d --into=build/ midterm.tex

clean:
	rm build/*_2* build/midterm.*

run: all
	evince build/midterm.pdf &
	evince build/srs.pdf 

