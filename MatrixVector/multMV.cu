#include <stdio.h>
__global__ void multMV(int m, int n, double *A, double *B, double *C) {
    int i,j;
   i = blockIdx.x * blockDim.x + threadIdx.x;
   if (i >= m) return;
    //for(i = 0; i < m; i++){
      double sum = 0;
      for(j = 0; j < n; j++){
         //printf("%f %f %f \n", A[i][j], B[j], A[i][j]*B[j]);
         sum += A[i*n+j]*B[j];
      }
      C[i] = sum;
      //printf("Hello world! I'm thread %d out of %d in block %d. My global thread id is %d out of %d. C[%d] = %f)\n"
      //      , threadIdx.x, blockDim.x, blockIdx.x, blockIdx.x * blockDim.x + threadIdx.x, blockDim.x*gridDim.x, i, C[i]);
   //}
}



void multMM(int m, int n, int p, double **A, double **B, double **C) {
    int i, j, k;
    double sum;
    //printf("%d %d %d\n", m,n,p);
    for(i = 0; i < m; i++){
      //printf("1");
      for(j = 0; j < p; j++){
         //printf("2");
         sum = 0.0;
         for(k = 0; k < n; k++){
            //printf("3");
            //printf("%f %f %f \n", A[i][k], B[k][j], A[i][k] * B[k][j]);
            sum += A[i][k] * B[k][j];
            //printf("%f\n", sum);
         }
         //printf("%f\n", sum);
         C[i][j] = sum;
      }
   }
}
