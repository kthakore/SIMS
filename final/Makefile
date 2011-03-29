
all: final 

final:
	rubber -d --into=build/ final.tex

clean:
	rm build/*_2* build/final.*

run: all
	evince build/final.pdf

