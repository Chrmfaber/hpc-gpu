#include <stdio.h>

__global__ void d_gpu1(int m, int n, int p, double *A, double *B, double *C) {
  int i, j, k;

  double sum = 0;
  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {

      for (k = 0; k < p; k++) {
        sum += A[i * p + k] * B[k * m + j];

      }
      C[i * n + j] = sum;
    }
  }
};

extern "C" {
void matmult_gpu1(int m, int n, int k, double *A, double *B, double *C) {
  // Copy to device logic

  // Kernel config
  // TODO: set dynamically
  int num_blocks = 1;
  int num_threads = 1;

  // Size of matrix
  int size_A = m * k * sizeof(double);
  int size_B = k * n * sizeof(double);
  int size_C = m * n * sizeof(double);

  // device matrices initialized
  double *d_A, *d_B, *d_C;

  // device matrices memory allocation
  cudaMalloc((void **)&d_A, size_A);
  cudaMalloc((void **)&d_B, size_B);
  cudaMalloc((void **)&d_C, size_C);

  // Copy to device
  cudaMemcpy(d_A, A, size_A, cudaMemcpyHostToDevice);
  cudaMemcpy(d_A, B, size_B, cudaMemcpyHostToDevice);

  // launch kernel
  d_gpu1<<<num_blocks, num_threads>>>(m, n, k, d_A, d_B, d_C);

  // sync threads
  cudaDeviceSynchronize();

  // Copy back to host
  cudaMemcpy(C, d_C, size_C, cudaMemcpyDeviceToHost);

  // Free memory
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
};
}
