exprl.exe : exprl.cpp
	g++ -o exprl.exe exprl.cpp
	
exprl.cpp : exprl.y
	bison -o exprl.cpp exprl.y
	
run : exprl.exe
	./exprl.exe

clean : 
	rm exprl.cpp
	rm exprl.exe
