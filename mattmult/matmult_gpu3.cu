__global__ void gpu3_row(int m, int n, int k_max, double *A, double *B, double *C) {

    int i, j, k;
    double sum1, sum2;

    i = 2*(blockIdx.x * blockDim.x + threadIdx.x);
    j = blockIdx.y * blockDim.y + threadIdx.y;

    if(!(i >= m || j >= n)){
         sum1 = 0.0;
         sum2 = 0.0;
         for(k = 0; k < k_max; k++){
            sum1 += A[i*k_max+k] * B[k*n+j];
            sum2 += A[(i+1)*k_max+k] * B[k*n+j];
         }
         C[i*n+j] = sum1;
         C[(i+1)*n+j] = sum2;
      }
}
__global__ void gpu3_column(int m, int n, int k_max, double *A, double *B, double *C) {

    int i, j, k;
    double sum1, sum2;

    i = blockIdx.x * blockDim.x + threadIdx.x;
    j = 2*(blockIdx.y * blockDim.y + threadIdx.y);

    if(!(i >= m || j >= n)){
         sum1 = 0.0;
         sum2 = 0.0;
         for(k = 0; k < k_max; k++){
            sum1 += A[i*k_max+k] * B[k*n+j];
            sum2 += A[i*k_max+k] * B[k*n+(j+1)];
         }
         C[i*n+j] = sum1;
         C[i*n+(j+1)] = sum2;
      }else if(!(i = m || j = n-1)){
           sum1 = 0.0;
           //sum2 = 0.0;
           for(k = 0; k < k_max; k++){
              sum1 += A[i*k_max+k] * B[k*n+j];
              //sum2 += A[i*k_max+k] * B[k*n+(j+1)];
           }
           C[i*n+j] = sum1;
           //C[i*n+(j+1)] = sum2;
        }
}

extern "C" { __host__ void matmult_gpu3(int m, int n, int k, double *h_A, double *h_B, double *h_C){
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
   int gridx = (m/blockx)+1;
   int gridy = ((n/blocky)+1)/2 + 1;
   //int gridx = ((m/blockx)+1)/2 + 1;
   //int gridy = (n/blocky)+1;
   dim3 dimGrid(gridx,gridy,1);

   gpu3_column<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);
   //gpu3_row<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);

   cudaDeviceSynchronize();
   cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);

   cudaFree(d_A);
   cudaFree(d_B);
   cudaFree(d_C);
   }
}
