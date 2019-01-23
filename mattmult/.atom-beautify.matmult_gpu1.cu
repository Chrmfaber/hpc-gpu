#include <stdio.h>

void matmult_gpu1(int m, int n, int k, double *A, double *B,
                             double *C) {
  int i, j, l;
  i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i >= m)
    return;

  for (j = 0; j < n; j++) {
    C[i * m + j] = 0;
    for (l = 0; l < k; l++) {
      C[i * m + j] += A[i * m + k] * B[l * n + j];
    }
  }
};
