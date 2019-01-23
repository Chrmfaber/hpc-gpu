TARGET_1 = jacobi_gpu1
SRCS_1	 = jacobi_gpu1.cu
OBJS_1	 = jacobi_gpu1.o

OPT = -g
PIC =
XOPTS = -Xptxas=-v
ARCH  = -arch=sm_70
OMP   = -fopenmp

CXX	= nvcc
CXXFLAGS= --compiler-options "$(OPT) $(PIC) $(OMP)" $(ARCH) $(XOPTS)

CUDA_PATH ?= /appl/cuda/10.0
INCLUDES = -I$(CUDA_PATH)/include -I$(CUDA_PATH)/samples/common/inc

SOFLAGS =
XLIBS	= -L$(CUDA_PATH)/lib -lcublas


# define project
all : $(TARGET_1)

$(TARGET_1): $(OBJS_1)
	$(CXX) -o $@ $(CXXFLAGS) $(SOFLAGS) $(INCLUDES) $^ $(XLIBS)

.SUFFIXES: .cu
.cu.o:
	$(CXX) -o $*.o -c $*.cu $(CXXFLAGS) $(SOFLAGS) $(INCLUDES)

clean:
	@/bin/rm -f $(TARGET_1) $(OBJS_1)