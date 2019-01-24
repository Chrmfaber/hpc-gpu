#define ELEMS 32

__global__ void gpu4_row(int m, int n, int k_max, double *A, double *B, double *C) {

    int i, j, k, l;
    double sum[ELEMS];

    i = ELEMS*(blockIdx.x * blockDim.x + threadIdx.x);
    j = blockIdx.y * blockDim.y + threadIdx.y;

    if(!(i+ELEMS >= m || j >= n)){
         for(l = 0; l < ELEMS; l++){
            sum[l] = 0.0;
         }
         for(k = 0; k < k_max; k++){
            for(l = 0; l < ELEMS; l++){
               sum[l] += A[(i+l)*k_max+k] * B[k*n+j];
            }
            //sum1 += A[i*k_max+k] * B[k*n+j];
            //sum2 += A[(i+1)*k_max+k] * B[k*n+j];
         }
         //C[i*n+j] = sum1;
         //C[(i+1)*n+j] = sum2;
         for(l = 0; l < ELEMS; l++){
            C[(i+l)*n+j] = sum[l];
         }
   }else if(!(i >= m || j >= n)){ //THIS IS CLEANUP IF ELEMS DOES NOT DIVIDE INTO DIMENSIONS
      for(l = 0; i+l < m && l < ELEMS; l++){
         sum[l] = 0.0;
      }
      for(k = 0; k < k_max; k++){
         for(l = 0; i+l < m && l < ELEMS; l++){
            sum[l] += A[(i+l)*k_max+k] * B[k*n+j];
         }
      }
      for(l = 0; i+l < m && l < ELEMS; l++){
         C[(i+l)*n+j] = sum[l];
      }
   }

}
__global__ void gpu4_column(int m, int n, int k_max, double *A, double *B, double *C) {

    int i, j, k, l;
    double sum[ELEMS];

    i = blockIdx.x * blockDim.x + threadIdx.x;
    j = ELEMS*(blockIdx.y * blockDim.y + threadIdx.y);

    if(!(i >= m || j+ELEMS >= n)){
      for(l = 0; l < ELEMS; l++){
          sum[l] = 0.0;
      }
      for(k = 0; k < k_max; k++){
         for(l = 0; l < ELEMS; l++){
            sum[l] += A[i*k_max+k] * B[k*n+(j+l)];
         }
            //sum1 += A[i*k_max+k] * B[k*n+j];
            //sum2 += A[i*k_max+k] * B[k*n+(j+1)];
      }
      for(l = 0; l < ELEMS; l++){
         C[i*n+(j+l)] = sum[l];
      }
         //C[i*n+j] = sum1;
         //C[i*n+(j+1)] = sum2;
      }else if(!(i >= m || j >= n)){
         for(l = 0; j+l < n && l < ELEMS; l++){
             sum[l] = 0.0;
         }
         for(k = 0; k < k_max; k++){
            for(l = 0; j+l < n && l < ELEMS; l++){
               sum[l] += A[i*k_max+k] * B[k*n+(j+l)];
            }
               //sum1 += A[i*k_max+k] * B[k*n+j];
               //sum2 += A[i*k_max+k] * B[k*n+(j+1)];
         }
         for(l = 0; j+l < n && l < ELEMS; l++){
            C[i*n+(j+l)] = sum[l];
         }
      }
}

extern "C" { __host__ void matmult_gpu4(int m, int n, int k, double *h_A, double *h_B, double *h_C){
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

   //Grid for column algorithm
   int gridx = (m/blockx)+1;
   int gridy = ((n/blocky)+1)/ELEMS + 1;

   //Grid for row algorithm
   //int gridx = ((m/blockx)+1)/ELEMS + 1;
   //int gridy = (n/blocky)+1;
   dim3 dimGrid(gridx,gridy,1);

   double time_start_gpu4 = omp_get_wtime();
   //gpu4_column<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);
   gpu4_row<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);

   cudaDeviceSynchronize();

   double gpu4_time = omp_get_wtime()-time_start_gpu4;

   cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);
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

  printf("GPUTime = %f\n", gpu4_time);

   cudaFree(d_A);
   cudaFree(d_B);
   cudaFree(d_C);
   }
}
