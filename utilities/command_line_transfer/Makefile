# LIBRARIES = -framework OpenGL -framework GLUT -framework Carbon -lpng

EXE = bin2tec

serialib.o: serialib.cpp

all:
	clang++ -arch x86_64 -std=c++17 -mmacosx-version-min=10.15 -Wall serialib.cpp $(EXE).cpp -o $(EXE)


clean:
	-rm $(EXE)
