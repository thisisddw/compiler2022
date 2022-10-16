exprl.exe : exprl.c
	gcc -o exprl.exe exprl.c
	
exprl.c : exprl.y
	bison -o exprl.c exprl.y
	
run : exprl.exe
	./exprl.exe
