extern "C" {
#include <cblas.h>
#include <omp.h>
#include <stdio.h>

void matmult_lib(int m, int n, int k, double *A, double *B, double *C) {

    double alpha = 1.0;
    double beta = 0.0;

    int lda = k, ldb = n, ldc = n;


    /* Ensure that all elements of C is 0 */
  	for (int i=0; i<m ; i++){
  		for (int j=0; j<n ; j++){
  			C[i*n + j] = 0;
  		}

  	}
    double time_start_lib = omp_get_wtime();
  cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);
  double lib_time = omp_get_wtime()-time_start_lib;

  printf("CPUTime = %f\n", lib_time);
}
}
