extern "C" {
#include <cblas.h>

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
  cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, n, k, alpha, A, lda, B, ldb, beta, C, ldc);
}
}
