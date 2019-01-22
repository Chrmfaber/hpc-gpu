#include <stdio.h>

__global__ void matmatgpu(int n, int m, double *A, double *B, double *C) {
  int i, j;
  i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i >= m)
    return;

  double sum = 0;
  for (j = 0; j < n; j++) {
    printf("A[i * n + j] = %f, B[i * n + j] = %f \n",A[i * n + j], B[i * n + j]);
    sum += A[i * n + j] * B[i * n + j];
  }
  C[i] = sum;
};
