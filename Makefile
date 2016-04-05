ifeq ($(OS),Windows_NT)
	S=\;
	TERMINAL=cygstart mintty -s 50,15
	ASYN=;
else
	S=:
	TERMINAL=xterm -e
	ASYN=&
endif

all:
	(cd sysj; sysjc --silence controller.sysj ; \
		if [ -f plant.sysj ]; then\
		sysjc --silence plant.sysj;\
		fi;)
	-mkdir bin
	javac -d bin src/org/compsys704/*.java


run:
	(cd sysj; $(TERMINAL) sysjr controller.xml $(ASYN) $(TERMINAL) sysjr plant.xml $(ASYN))
	$(TERMINAL) java -cp bin org.compsys704.CapLoader $(ASYN)

lab:
	git checkout -- .
	git clean -dfx
	(cd sysj; sysjc --silence plant.sysj)
	rm sysj/*.java sysj/plant.sysj 
	tar cvaf WPLoader.tar.gz *

clean:
	rm -rfv sysj/*.java sysj/*.class
	rm -rfv src/org/compsys704/*.class
	rm -rfv bin
