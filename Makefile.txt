CXX = g++
NVCC = nvcc
CXXFLAGS = -std=c++17 -O2
NVCCFLAGS = -std=c++17

# Paths to CUDA (adjust if needed)
CUDA_PATH ?= /usr/local/cuda
INCLUDES = -I$(CUDA_PATH)/include
LIBS = -L$(CUDA_PATH)/lib64 -lnppig -lnppicc -lnppc -lnppial -lnppif -lnppim -lnppist -lnppisu -lnppidei -lcudart

# Target
TARGET = npp_grayscale
SRC = main.cpp

all: $(TARGET)

$(TARGET): $(SRC)
	$(NVCC) $(NVCCFLAGS) $(INCLUDES) -o $(TARGET) $(SRC) $(LIBS)

clean:
	rm -f $(TARGET)