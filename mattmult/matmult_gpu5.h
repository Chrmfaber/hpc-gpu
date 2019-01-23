#ifndef __MULTMV_H
#define __MULTMV_H

__global__ void d_pu5(int m, int n, int p, double *A, double *B, double *C);

__host__ void matmult_gpu5(int m, int n, int k, double *h_A, double *h_B,
                           double *h_C);

#endif
