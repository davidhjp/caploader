ifeq ($(OS),Windows_NT)
	S=\;
	TERMINAL=cygstart mintty -s 50,15
	BROWSER=explorer
else
	S=:
	TERMINAL=
endif

all:
	(cd sysj; sysjc --silence controller.sysj plant.sysj; javacc *.java)

run:
	(cd sysj; $(TERMINAL) sysj controller.xml ; $(TERMINAL) sysj plant.xml)

clean:
	rm -rfv sysj/*.java sysj/*.class
