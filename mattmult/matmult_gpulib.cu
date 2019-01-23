#include <cublas_v2.h>

extern "C" { void matmult_gpulib(double *A, double *B, double *C, int m, int k, int n) {

     // Create a handle for CUBLAS
   	 cublasHandle_t handle;
   	 cublasCreate(&handle);

      const double alf = 1;
      const double bet = 0;

      const double *alpha = &alf;
      const double *beta = &bet;

      int lda = m, ldb = k, ldc = m;

     // Do the multiplication
     cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, m, k, alpha, A, lda, B, ldb, beta, C, ldc);

     // Destroy the handle
     cublasDestroy(handle);

   }
}
