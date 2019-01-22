#include <stdio.h>
#include <stdlib.h>
#include "matmatgpu.h"



int
main(int argc, char *argv[]) {

    int n = 32;
    int m = 32;

    int num_blocks = 82;
    int num_threads = 32;

    double **A, **B, **C;

    int size = n * m * sizeof(int);


    // command line argument sets the dimensions of the image
    if ( argc == 2 ) m = n = atoi(argv[1]);

    cudaMalloc((void **)&d_image, size);
    cudaMallocHost((void **)&image, size);
    // image = (int *)malloc(size);
    if ( image == NULL ) {
       fprintf(stderr, "memory allocation failed!\n");
       return(1);
    }

    mandelgpu<<<num_blocks, num_threads>>>(width, height, d_image, max_iter);
    cudaDeviceSynchronize();
    cudaMemcpy(image, d_image, size, cudaMemcpyDeviceToHost);


    writepng(s, image, width, height);
    cudaFree(d_image);
    cudaFreeHost(image);



    return(0);
}
