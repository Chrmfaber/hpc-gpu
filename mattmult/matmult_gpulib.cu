#include <cublas_v2.h>
#include <curand.h>
#include <stdlib.h>
#include <stdio.h>
#include <cstdlib>
#include <cstdio>

extern "C" { void matmult_gpulib(const double *A, const double *B, double *C, const int m, const int k, const int n) {
      int lda=m,ldb=k,ldc=m;
      const double alf = 1.0;
      const double bet = 0.0;
      const double *alpha = &alf;
      const double *beta = &bet;

     // Create a handle for CUBLAS
     cublasHandle_t handle;
     cublasCreate(&handle);

     // Do the actual multiplication
     cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);

     // Destroy the handle
     cublasDestroy(handle);

   }
}
