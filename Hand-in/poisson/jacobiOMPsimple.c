#include <math.h>
#include <stdio.h>

#ifdef OMP
#include <omp.h>
#endif
/*
#if defined(__MACH__) && defined(__APPLE__)
#else
#include <omp.h>
#endif
*/

int jacobiOMPsimple(int N, int kMAX, double **f,
                    double **u_old, double **u_new) {
  int k = 0, i, j;
  double delta = (2.0 / N) * (2.0 / N);
  double **temp;
  double scalar = 1.0 / 4;

  while (k < kMAX) {
     #pragma omp parallel for schedule(runtime) shared(u_new, u_old, N, threshold, kMAX, f, k, delta) private(i,j) reduction(+: d)
     for (i = 1; i <= N; i++) {
        for (j = 1; j <= N; j++) {
           /*
           u_new[i][j] =
               scalar * (u_old[i - 1][j] + u_old[i + 1][j] + u_old[i][j - 1] +
                      u_old[i][j + 1] + delta * f[i][j]);
                      */
      }
    }
    temp = u_old;
    u_old = u_new;
    u_new = temp;
    k = k + 1;
  }
  return k;
}
