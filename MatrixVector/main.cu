#include <stdlib.h>
#include <stdio.h>
#include <time.h>

#if defined(__MACH__) && defined(__APPLE__)
#include <Accelerate/Accelerate.h>
#else
#include <cblas.h>
#endif

#include "datatools.h"		/* helper functions	        */
#include "matadd.h"		/* my matrix add fucntion	*/
#include "multMV.h"		/* my matrix add fucntion	*/

#define NREPEAT 100		/* repeat count for the experiment loop */

#define mytimer clock
#define delta_t(a,b) (1e3 * (b - a) / CLOCKS_PER_SEC)



int
main(int argc, char *argv[]) {

    int    i, m, n, p, N = NREPEAT;
    //double **A, **B, **C;
    double *h_A, *d_A; // *B, *C;
    double *h_V1, *d_V1, *h_V2, *d_V2;
    double tcpu1;

    clock_t t1, t2;

   //for (m = 50; m <= 500; m += 50) {
	//n = m + 3;
   //p = m;
   m = 3;
   n = 3;

	/* Allocate memory */
	//A = malloc_2d(m, n);
	//B = malloc_2d(n, p);
	//C = malloc_2d(m, p);
   //A = malloc(n*m*sizeof(double));
   //B = malloc(n*m*sizeof(double));
   //C = malloc(n*m*sizeof(double));
   //V1 = malloc(n * sizeof(double));
   //V2 = malloc(m * sizeof(double));

   int size_m = n*m*sizeof(double);
   int size_v1 = n*sizeof(double);
   int size_v2 = m*sizeof(double);

   cudaMallocHost((void **)&h_A, size_m);
   cudaMallocHost((void **)&h_V1, size_v1);
   cudaMallocHost((void **)&h_V2, size_v2);
   cudaMalloc((void**)&d_A, size_m);
   cudaMalloc((void**)&d_V1, size_v1);
   cudaMalloc((void**)&d_V2, size_v2);

   init_vector(n,h_V1);
   init_vector(m*n,h_A);
   init_vector(m,h_V2);

   cudaMemcpy(d_A, h_A, size_m, cudaMemcpyHostToDevice);
   cudaMemcpy(d_V1, h_V1, size_v1, cudaMemcpyHostToDevice);

   int blocksize = 32;
   int blocks = (m/32)+1;
   multMV<<<blocks,blocksize>>>(m,n,d_A,d_V1,d_V2);

   cudaMemcpy(h_V2, d_V2, size_v2, cudaMemcpyDeviceToHost);

   int k;
   for(k = 0; k < m; k++){
      printf("%f\n", *(h_V2+k));
   }

   cudaFreeHost(h_A);
   cudaFreeHost(h_V1);
   cudaFreeHost(h_V2);
   cudaFree(d_A);
   cudaFree(d_V1);
   cudaFree(d_V2);

   /*
	if (A == NULL || B == NULL | C == NULL) {
	    fprintf(stderr, "Memory allocation error...\n");
	    exit(EXIT_FAILURE);
	}
   */
   /*
   	// initialize with useful data - last argument is reference
   	init_M(m,n,A);

   	//timings for matadd
   	t1 = mytimer();
   	for (i = 0; i < N; i++)
   	    matadd(m, n, A, B, C);
   	t2 = mytimer();
   	tcpu1 = delta_t(t1, t2) / N;

   	check_results("main", m, n, C);

   	// Print n and results
   	printf("%4d %4d %8.3f\n", m, n, tcpu1);
   */
   //init_M(m,n,A);
   //init_M(n,p,B);
   //init_vector(m,V1);

   //multMV(m,n,A,V1,V2);

   //t1 = mytimer();
   //for (i = 0; i < N; i++)
       //multMV(m,n,A,V1,V2);
       //multMM(m,n,p,A,B,C);
   //    cblas_dgemm(CblasRowMajor, CblasNoTrans, CblasNoTrans, m, p, n, 1, A[0], m, B[0], n, 1, C[0], n);
   //t2 = mytimer();
   //tcpu1 = delta_t(t1, t2) / N;
   //printf("%4d %4d %8.3f\n", m, n, tcpu1);
   /*
   for(int k = 0; k < m; k++){
      printf("%f ", **(C+k));
   }
*/
   //cudaMemcpy(h_image, d_image, size, cudaMemcpyDeviceToHost);


	/* Free memory */
   /*
	free_2d(A);
	free_2d(B);
	free_2d(C);
   free(V1);
   free(V2);
   */
    //}

    return EXIT_SUCCESS;
}
