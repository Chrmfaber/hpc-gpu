__global__ void gpu2(int m, int n, int p, double *A, double *B, double *C) {

    int i, j, k;
    double sum;

    i = blockIdx.x * blockDim.x + threadIdx.x;
    j = blockIdx.y * blockDim.y + threadIdx.y;

    if(!(i >= m || j >= n)){
         sum = 0.0;
         for(k = 0; k < p; k++){
            sum += A[i*p+k] * B[k*m+j];
         }
         C[i*n+j] = sum;
      }
}


extern "C" {__host__ void matmult_gpu2(int m, int n, int k, double *h_A, double *h_B, double *h_C){
   double *d_A, *d_B, *d_C;

   int devices;
   cudaGetDeviceCount(&devices);

   int A_elems = n*k;
   int B_elems = k*m;
   int C_elems = n*m;

   int size_A = n*k*sizeof(double);
   int size_B = k*m*sizeof(double);
   int size_C = n*m*sizeof(double);

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

   gpu2<<<dimGrid,dimBlock>>>(m,n,k,d_A,d_B,d_C);

   cudaDeviceSynchronize();
   cudaMemcpy(h_C, d_C, size_C, cudaMemcpyDeviceToHost);

   cudaFree(d_A);
   cudaFree(d_B);
   cudaFree(d_C);
   }
}
