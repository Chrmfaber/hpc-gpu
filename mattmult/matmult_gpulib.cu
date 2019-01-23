#include <cublas_v2.h>

extern "C" { void matmult_gpulib(int m, int n, int k,double *A, double *B, double *C) {

     // Create a handle for CUBLAS
   	 cublasHandle_t handle;
   	 //cublasCreate(&handle);

      const double alf = 1.0;
      const double bet = 0.0;
      const double *alpha = &alf;
      const double *beta = &bet;

      int lda = k, ldb = n, ldc = n;

     // Do the multiplication
     cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, m, k, alpha, B, ldb, A, lda, beta, C, ldc);

     // Destroy the handle
     cublasDestroy(handle);

   }
}
