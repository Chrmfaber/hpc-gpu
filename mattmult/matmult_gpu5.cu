#define BLOCK_SIZE 16

// A: stride = k
// B: stride = n
// C: stride = n

// Get a matrix element
__device__ float GetElement(double *A, int row, int col, int stride) {
  return A[row * stride + col];
}

// Set a matrix element
__device__ void SetElement(double *A, int row, int col, int stride,
                           float value) {
  A[row * stride + col] = value;
}

// Get the BLOCK_SIZExBLOCK_SIZE sub-matrix Asub of A that is
// located col sub-matrices to the right and row sub-matrices down
// from the upper-left corner of A
__device__ float GetSubMatrix(double *A, int row, int col, int stride) {
  return A[stride * BLOCK_SIZE * row + BLOCK_SIZE * col];
}

__global__ void d_gpu5(int m, int n, int p, double *A, double *B, double *C) {

  int i, e;
  double sum;

  // Block row and column
  int blockRow = blockIdx.y;
  int blockCol = blockIdx.x;

  // Each thread block computes one sub-matrix Csub of C
  double *Csub = GetSubMatrix(C, blockRow, blockCol, n);
  // Each thread computes one element of Csub
  // by accumulating results into Cvalue
  float Cvalue = 0;

  // Thread row and column within Csub
  int row = threadIdx.y;
  int col = threadIdx.x;

  for (i = 0; i < (k / BLOCK_SIZE); ++i) {

    // Get sub-matrix Asub of A
    Matrix Asub = GetSubMatrix(A, blockRow, i, k);

    // Get sub-matrix Bsub of B
    Matrix Bsub = GetSubMatrix(B, i, blockCol, n);

    // Shared memory used to store Asub and Bsub respectively
    __shared__ float As[BLOCK_SIZE][BLOCK_SIZE];
    __shared__ float Bs[BLOCK_SIZE][BLOCK_SIZE];

    // Load Asub and Bsub from device memory to shared memory
    // Each thread loads one element of each sub-matrix
    As[row][col] = GetElement(Asub, row, col, k);
    Bs[row][col] = GetElement(Bsub, row, col, n);

    // Synchronize to make sure the sub-matrices are loaded
    // before starting the computation
    __syncthreads();
    // Multiply Asub and Bsub together
    for (int e = 0; e < BLOCK_SIZE; ++e)
      Cvalue += As[row][e] * Bs[e][col];

    // Synchronize to make sure that the preceding
    // computation is done before loading two new
    // sub-matrices of A and B in the next iteration
    __syncthreads();
  }

  // Write Csub to device memory
  // Each thread writes one element
  SetElement(Csub, row, col, n, Cvalue);
}

extern "C" {
__host__ void matmult_gpu5(int m, int n, int k, double *h_A, double *h_B,
                           double *h_C) {
  double *d_A, *d_B, *d_C;

  int devices;
  cudaGetDeviceCount(&devices);

  int A_elems = n * k;
  int B_elems = k * m;
  int C_elems = n * m;

  int size_A = n * k * sizeof(double);
  int size_B = k * m * sizeof(double);
  int size_C = n * m * sizeof(double);

  cudaMalloc((void **)&d_A, size_A);
  cudaMalloc((void **)&d_B, size_B);
  cudaMalloc((void **)&d_C, size_C);

  cudaMemcpy(d_A, h_A, size_A, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size_B, cudaMemcpyHostToDevice);

  dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
  dim3 dimGrid(k / dimBlock.x, k / dimBlock.y);

  d_gpu5<<<dimGrid, dimBlock>>>(m, n, k, d_A, d_B, d_C);

  cudaDeviceSynchronize();
  cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);

  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}
}
