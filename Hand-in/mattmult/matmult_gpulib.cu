#include <cublas_v2.h>

extern "C" { void matmult_gpulib(int m, int n, int k,double *A, double *B, double *C) {

  int lda = k, ldb = n, ldc = n;

  // Create a handle for CUBLAS
  cublasHandle_t handle;
  cublasCreate(&handle);

  const double alf = 1.0;
  const double bet = 0.0;
  const double *alpha = &alf;
  const double *beta = &bet;

  /* Allocate device memory */
  int size_A = k*m*sizeof(double);
  int size_B = n*k*sizeof(double);
  int size_C = n*m*sizeof(double);

  double *d_A, *d_B, *d_C;
  cudaMalloc((void **)&d_A, size_A);
  cudaMalloc((void **)&d_B, size_B);
  cudaMalloc((void **)&d_C, size_C);

  /* Copy data to device */
  cudaMemcpy(d_A,A,size_A, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B,B,size_B, cudaMemcpyHostToDevice);
  cudaMemcpy(d_C,C,size_C, cudaMemcpyHostToDevice);

  // Do the multiplication
  cublasDgemm(handle, CUBLAS_OP_N, CUBLAS_OP_N, n, m, k, alpha, d_B, ldb, d_A, lda, beta, d_C, ldc);

  // Destroy the handle
  cublasDestroy(handle);

  // Copy result back to host
  cudaMemcpy(C,d_C,size_C, cudaMemcpyDeviceToHost);

  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}
}

