#include <stdio.h>
#include <omp.h>

__global__ void d_gpu1(int m, int n, int k, double *A, double *B, double *C) {
  int i, j, l;

  for (i = 0; i < m; i++) {
    for (j = 0; j < n; j++) {
      double sum = 0;
      for (l = 0; l < k; l++) {
        sum += A[i * k + l] * B[l * n + j];
      }
      C[i * n + j] = sum;
    }
  }
};

extern "C" {
void matmult_gpu1(int m, int n, int k, double *A, double *B, double *C) {
  // Copy to device logic
  int i, j;




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
  cudaMemcpy(d_B, B, size_B, cudaMemcpyHostToDevice);

  double time_start_gpu1 = omp_get_wtime();
  // launch kernel
  d_gpu1<<<num_blocks, num_threads>>>(m, n, k, d_A, d_B, d_C);

  // sync threads
  cudaDeviceSynchronize();

  double gpu1_time = omp_get_wtime()-time_start_gpu1;

  // Copy back to host
  cudaMemcpy(C, d_C, size_C, cudaMemcpyDeviceToHost);

  printf("GPUTime = %f\n", gpu1_time);

  // Free memory
  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
};
}
