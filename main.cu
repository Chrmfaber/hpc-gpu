#include <stdio.h>
#include <stdlib.h>
#include "mandel.h"
#include "writepng.h"
#include "mandelgpu.h"



int
main(int argc, char *argv[]) {

    int   width, height;
    int	  max_iter;
    int   *d_image; 
    int   *image;

    int num_blocks = 82;
    int num_threads = 32;

    char s[] = "mandelbrot.png";

    width    = 2601;
    height   = 2601;
    max_iter = 400;
    int size = width * height * sizeof(int);


    // command line argument sets the dimensions of the image
    if ( argc == 2 ) width = height = atoi(argv[1]);

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
