CC=gcc

powers: powers.o
	$(CC) powers.o -o powers
powers.o: powers.asm
	nasm -felf -g -F stabs powers.asm
