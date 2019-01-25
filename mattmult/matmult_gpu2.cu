#include <stdio.h>
#include <omp.h>
__global__ void gpu2(int m, int n, int k_max, double *A, double *B, double *C) {

    int i, j, k;
    double sum;

    i = blockIdx.x * blockDim.x + threadIdx.x;
    j = blockIdx.y * blockDim.y + threadIdx.y;

    if(!(i >= m || j >= n)){
         sum = 0.0;
         for(k = 0; k < k_max; k++){
            //sum += A[i*k_max+k] * B[k*n+j];
            sum += A[i*k_max+k] * B[k*n+j];
         }
         C[i*n+j] = sum;
         //printf("%d %d %f\n", i,j,sum);
      }
}


extern "C" {__host__ void matmult_gpu2(int m, int n, int k, double *h_A, double *h_B, double *h_C){
   double *d_A, *d_B, *d_C;

   int devices;
   cudaGetDeviceCount(&devices);

   int A_elems = m*k;
   int B_elems = k*n;
   int C_elems = m*n;

   int size_A = A_elems*sizeof(double);
   int size_B = B_elems*sizeof(double);
   int size_C = C_elems*sizeof(double);

   cudaMalloc((void**)&d_A, size_A);
   cudaMalloc((void**)&d_B, size_B);
   cudaMalloc((void**)&d_C, size_C);

   cudaMemcpy(d_A, h_A, size_A, cudaMemcpyHostToDevice);
   cudaMemcpy(d_B, h_B, size_B, cudaMemcpyHostToDevice);

   int blockx = 16;
   int blocky = 16;
   dim3 dimBlock(blockx,blocky,1);
   int gridx = (n/blockx)+1;
   int gridy = (m/blocky)+1;
   dim3 dimGrid(gridx,gridy,1);

   double time_start_gpu2 = omp_get_wtime();

   gpu2<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);

   cudaDeviceSynchronize();

   double gpu2_time = omp_get_wtime()-time_start_gpu2;

   cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);
   int i,j;
   /*
   printf("\n");
   for(i = 0;i < m; i++){
      for(j = 0;j < k; j++){
         printf("%f ", h_A[i*k+j]);
      }
      printf("\n");
   }
   printf("\n");
   for(i = 0;i < k; i++){
      for(j = 0;j < n; j++){
         printf("%f ", h_B[i*k+j]);
      }
      printf("\n");
   }
   printf("\n");
   for(i = 0;i < m; i++){
      for(j = 0;j < n; j++){
         printf("%f ", h_C[i*k+j]);
      }
      printf("\n");
   }
   */

   printf("GPUTime = %f\n", gpu2_time);

   cudaFree(d_A);
   cudaFree(d_B);
   cudaFree(d_C);
   }
}
