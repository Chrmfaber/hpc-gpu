#include <cublas_v2.h>
#include <curand.h>
#include <stdlib.h>
#include <stdio.h>
#include <cstdlib>
#include <cstdio>
#include <datatools.h>

void matmult_gpulib(const float *A, const float *B, float *C, const int m, const int k, const int n) {
      int lda=m,ldb=k,ldc=m;
      const float alf = 1.0;
      const float bet = 0.0;
      const float *alpha = &alf;
      const float *beta = &bet;

     // Create a handle for CUBLAS
     cublasHandle_t handle;
     cublasCreate(&handle);

     // Do the actual multiplication
     cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);

     // Destroy the handle
     cublasDestroy(handle);

   }
