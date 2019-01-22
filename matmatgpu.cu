
__global__ void matmatgpu(int n, int m, double *A, double *B, double *C) {
  int i, j;
  i = blockIdx.x * blockDim.x + threadIdx.x;
  if (i >= m)
    return;

  double sum = 0;
  for (j = 0; j < n; j++) {
    sum += A[i * n + j] * B[i * n + j];
  }
  C[i] = sum;
  // printf("Hello world! I'm thread %d out of %d in block %d. My global thread
  // id is %d out of %d. C[%d] = %f)\n"
  //      , threadIdx.x, blockDim.x, blockIdx.x, blockIdx.x * blockDim.x +
  //      threadIdx.x, blockDim.x*gridDim.x, i, C[i]);
  //}
};
