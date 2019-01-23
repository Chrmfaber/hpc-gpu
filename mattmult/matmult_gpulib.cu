#include <cublas_v2.h>
#include <curand.h>
#include <stdlib.h>
#include <stdio.h>
#include <cstdlib>
#include <cstdio>

<<<<<<< HEAD
extern "C" { void matmult_gpulib(const double *A, const double *B, double *C, const int m, const int k, const int n) {
=======
extern "C" { void matmult_gpulib(double *h_A, double *h_B, double *h_C, int m, int k, int n) {
>>>>>>> 636a2332b58e75c3948451cd22db6f85ccd42592
      int lda=m,ldb=k,ldc=m;
      double alfa = 1.0;
      double beta = 0.0;

     	int size_A = k*n*sizeof(double);
     	int size_B = m*k*sizeof(double);
     	int size_C = m*n*sizeof(double);

      /* Allocate device memory */
      double *d_A, *d_B, *d_C;
      cudaMalloc((void **)&d_A, size_A);
      cudaMalloc((void **)&d_B, size_B);
      cudaMalloc((void **)&d_C, size_C);

      /* Copy data to device */
      cudaMemcpy(d_A,h_A,size_A, cudaMemcpyHostToDevice);
      cudaMemcpy(d_B,h_B,size_B, cudaMemcpyHostToDevice);
      cudaMemcpy(d_C,h_C,size_C, cudaMemcpyHostToDevice);

     // Create a handle for CUBLAS
     cublasHandle_t handle;
     cublasCreate(&handle);

     // Do the actual multiplication
     cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, &alpha, A, lda, B, ldb, &beta, C, ldc);

     cudaMemcpy(h_C,d_C,size_C, cudaMemcpyDeviceToHost);

     // Destroy the handle
     cublasDestroy(handle);

   }
<<<<<<< HEAD
}
=======
 }
>>>>>>> 636a2332b58e75c3948451cd22db6f85ccd42592
