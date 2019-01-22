#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#include "matmatgpu.h"

#define mytimer clock
#define delta_t(a,b) (1e3 * (b - a) / CLOCKS_PER_SEC)


int
main(int argc, char *argv[]) {

    int n = 32;
    int m = 32;

    double tcpu1;

    clock_t t1, t2;

    // command line argument sets the dimensions of the image
    if ( argc == 2 ) m = n = atoi(argv[1]);

    // Kernel config
    int num_blocks = 82;
    int num_threads = 32;

    // Single indexed matrices (host)
    double *A, *B, *C;

    // device
    double *d_A, *d_B, *d_C;

    // Size of matrix
    int size = n * m * sizeof(double);

    // Memory allocation (host)
    cudaMallocHost((void **)&A, size);
    cudaMallocHost((void **)&B, size);
    cudaMallocHost((void **)&C, size);

    // device
    cudaMalloc((void **)&d_A, size)
    cudaMalloc((void **)&d_B, size)
    cudaMalloc((void **)&d_C, size)

    // Initalize A with 1s and B with 2s
    init_data(m, n, A, B);

    // Copy to device
    cudaMemcpy(d_A, A, size, cudaMemcpyHostToDevice)
    cudaMemcpy(d_A, B, size, cudaMemcpyHostToDevice)

    if ( A == NULL  || B == NULL || C == NULL) {
       fprintf(stderr, "memory allocation failed!\n");
       return(1);
    }

    mandelgpu<<<num_blocks, num_threads>>>(width, height, d_image, max_iter);
    cudaDeviceSynchronize();

    // Copy back to host
    cudaMemcpy(C, d_C , size, cudaMemcpyDeviceToHost)

    // Free memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    cudaFreeHost(A);
    cudaFreeHost(B);
    cudaFreeHost(C);




    return(0);
}
