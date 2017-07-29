# DawnCC libraries
DAWNCC = /home/alyson/git/dawncc/lib
PSKELCC = /home/alyson/git/pskelcc
PRA = ${DAWNCC}/PtrRangeAnalysis/libLLVMPtrRangeAnalysis.so

# PSkelCC library
STENCIL = "${PSKELCC}/build/src/libMyPass.so"

all: pskelcc llvm-ir pass

# Build PSkelCC
pskelcc: ${PSKELCC}/src/Stencil.cpp 
	make -C ${PSKELCC}/build

# Compile source to llvm ir
llvm-ir: $(SRC)
	clang -O0 -g -S -emit-llvm -c $(SRC) -o ${OBJS}-base.ll
	opt -S -mem2reg -instnamer ${OBJS}-base.ll -o ${OBJS}.ll

# Run stencil pass
pass: ${OBJS}.ll
	opt -load ${PRA} -load ${STENCIL} -stencil -stats ${OBJS}.ll -S -disable-output
	
clean:
	rm ${OBJS}.ll ${OBJS}-base.ll
