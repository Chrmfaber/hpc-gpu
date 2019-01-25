#ifndef __MULTMV_H
#define __MULTMV_H

__global__ void d_pu6(int m, int n, int p, double *A, double *B, double *C);

__host__ void matmult_gpu6(int m, int n, int k, double *h_A, double *h_B,
                           double *h_C);

#endif
