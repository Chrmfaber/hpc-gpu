#include <helper_cuda.h>
#include <omp.h>
#include <stdio.h>

#define BLOCK_SIZE 16

// A: stride = k
// B: stride = n
// C: stride = n

// Get a matrix element
// __device__ double GetElement(double *A, int row, int col, int stride) {
  // printf("Index at = %d \n", row * stride + col);
 // return A[row * stride + col];
// }

// Set a matrix element
// __device__ void SetElement(double *A, int row, int col, int stride,
 //                          double value) {
//  A[row * stride + col] = value;
//}

// Get the BLOCK_SIZExBLOCK_SIZE sub-matrix Asub of A that is
// located col sub-matrices to the right and row sub-matrices down
// from the upper-left corner of A
//__device__ void GetSubMatrix(double *A, double **Asub, int row, int col,
//                             int stride) {
//  *Asub = &A[stride * BLOCK_SIZE * row + BLOCK_SIZE * col];
// }

__global__ void d_gpu6(int m, int n, int k, double *A, double *B, double *C) {

  int i, e;
  double sum;

  // Block row and column
  int blockRow = blockIdx.y;
  int blockCol = blockIdx.x;

  // Each thread block computes one sub-matrix Csub of C
  double *Csub = &C[n * BLOCK_SIZE * blockRow + BLOCK_SIZE * blockCol];
  // GetSubMatrix(C, &Csub, blockRow, blockCol, n);

  // Each thread computes one element of Csub
  // by accumulating results into Cvalue
  double Cvalue = 0;

  // Thread row and column within Csub
  int row = threadIdx.y;
  int col = threadIdx.x;

  for (i = 0; i < (k / BLOCK_SIZE); ++i) {
    //  Example: *Asub = &A[stride * BLOCK_SIZE * row + BLOCK_SIZE * col];
    double *Asub = &A[k * BLOCK_SIZE * blockRow + BLOCK_SIZE * i];
    double *Bsub = &B[n * BLOCK_SIZE * i + BLOCK_SIZE * blockCol];
    // Get sub-matrix Asub of A

    // GetSubMatrix(A, &Asub, blockRow, i, k);

    // Get sub-matrix Bsub of B
    // GetSubMatrix(B, &Bsub, i, blockCol, n);

    // Shared memory used to store Asub and Bsub respectively
    __shared__ double As[BLOCK_SIZE][BLOCK_SIZE];
    __shared__ double Bs[BLOCK_SIZE][BLOCK_SIZE];

    // Load Asub and Bsub from device memory to shared memory
    // Each thread loads one element of each sub-matrix

    As[row][col] = Asub[row * k + col];
    Bs[row][col] = Bsub[row * n + col];

    // Synchronize to make sure the sub-matrices are loaded
    // before starting the computation
    __syncthreads();
    // Multiply Asub and Bsub together
    for (e = 0; e < BLOCK_SIZE; ++e) {
      Cvalue += As[row][e] * Bs[e][col];
    }

    // Synchronize to make sure that the preceding
    // computation is done before loading two new
    // sub-matrices of A and B in the next iteration
    __syncthreads();
  }

  // Write Csub to device memory
  // Each thread writes one element
  Csub[row * n + col] = Cvalue;
}

extern "C" {
__host__ void matmult_gpu6(int m, int n, int k, double *h_A, double *h_B,
                           double *h_C) {
  double *d_A, *d_B, *d_C;

  cudaSetDevice(1);

  int size_A = m * k * sizeof(double);
  int size_B = k * n * sizeof(double);
  int size_C = m * n * sizeof(double);

  cudaHostRegister(h_A, size_A, cudaHostRegisterPortable);
  cudaHostRegister(h_B, size_B, cudaHostRegisterPortable);
  cudaHostRegister(h_C, size_C, cudaHostRegisterPortable);


  cudaMalloc((void **)&d_A, size_A);
  cudaMalloc((void **)&d_B, size_B);
  cudaMalloc((void **)&d_C, size_C);

  cudaMemcpy(d_A, h_A, size_A, cudaMemcpyHostToDevice);
  cudaMemcpy(d_B, h_B, size_B, cudaMemcpyHostToDevice);

  dim3 dimBlock(BLOCK_SIZE, BLOCK_SIZE);
  dim3 dimGrid(m / dimBlock.x, n / dimBlock.y);


  d_gpu6<<<dimGrid, dimBlock>>>(m, n, k, d_A, d_B, d_C);

  cudaDeviceSynchronize();
  


  cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);

  int i, j; 



  cudaFree(d_A);
  cudaFree(d_B);
  cudaFree(d_C);
}
}
