#ifndef __MULTMV_H
#define __MULTMV_H

__global__ void multMV(int m, int n, double *A, double *B, double *C);

void multMM(int m, int n, int p, double **A, double **B, double **C);

#endif
