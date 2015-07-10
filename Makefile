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
	-mkdir bin
	javac -d bin src/org/compsys704/*.java


run:
	(cd sysj; $(TERMINAL) sysj controller.xml ; $(TERMINAL) sysj plant.xml)
	$(TERMINAL) java -cp bin org.compsys704.CapLoader

clean:
	rm -rfv sysj/*.java sysj/*.class
	rm -rfv src/org/compsys704/*.class
	rm -rfv bin
