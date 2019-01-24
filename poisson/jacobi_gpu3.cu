extern "C" {
#include <omp.h>
#include <stdio.h>
#include <stdlib.h>


void write_matrix(double *U, int N, char filename[40]) {
<<<<<<< HEAD
  double u;
  double delta = (2.0 / N);
  FILE *matrix = fopen(filename, "w");
  for (int i = 0; i < N; i++) {
    fprintf(matrix, "\n");
    for (int j = 0; j < N; j++) {
      u = U[i * N + j];
      fprintf(matrix, "%6.2f\t", u);
=======
    double u;
    FILE *matrix=fopen(filename, "w");
    for (int i = 0; i < N; i++) {
        fprintf(matrix, "\n");
        for (int j = 0; j < N; j++) {
            u = U[i*N + j];
            fprintf(matrix, "%6.2f\t",u);
        }
>>>>>>> c35594f8edc18d82038f020126488e7de339070c
    }
  }
  fclose(matrix);
}
}

const int device0 = 0;
const int device1 = 1;
#define BLOCK_SIZE 16

<<<<<<< HEAD
void __global__ jacobi_gpu3_d0(int N, double delta, int kMAX, double *f,
                               double *u_new, double *u_old, double *d1_u_old) {
  int j = blockIdx.x * blockDim.x + threadIdx.x;
  int i = blockIdx.y * blockDim.y + threadIdx.y;
  if (i <= (N * 0.5 - 1) && j <= (N - 1) && i > 0 && j > 0) {
    u_new[i * N + j] = 0.25 * (u_old[(i - 1) * N + j] + u_old[(i + 1) * N + j] +
                               u_old[i * N + (j - 1)] + u_old[i * N + (j + 1)] +
                               delta * f[i * N + j]);
  } else if (i == (N * 0.5 - 1) && j < (N - 1) && j > 0) {
    u_new[i * N + j] =
        0.25 * (u_old[(i - 1) * N + j] + d1_u_old[j] + u_old[i * N + (j - 1)] +
                u_old[i * N + (j + 1)] + delta * f[i * N + j]);
  }
=======

void __global__ jacobi_gpu3_d0(int N, double delta, int kMAX, double *f, double *u_new, double *u_old, double *d1_u_old) {
    int j = blockIdx.x * blockDim.x + threadIdx.x;
    int i = blockIdx.y * blockDim.y + threadIdx.y;

    if (i <(N*0.5-1) && j < (N-1) && i > 0 && j > 0) {
        u_new[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + u_old[(i+1)*N + j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*f[i*N + j]);
    }
    else if (i == (N/2-1) && j < (N-1) && j > 0) {

        u_new[i*N + j] = 0.25 * (u_old[(i-1)*N + j] + d1_u_old[j] + u_old[i*N + (j-1)] + u_old[i*N + (j+1)] + delta*f[i*N + j]);
    }
>>>>>>> c35594f8edc18d82038f020126488e7de339070c
}

void __global__ jacobi_gpu3_d1(int N, double delta, int kMAX, double *f,
                               double *u_new, double *u_old, double *d0_u_old) {
  int j = blockIdx.x * blockDim.x + threadIdx.x;
  int i = blockIdx.y * blockDim.y + threadIdx.y;
  if (i < (N * 0.5 - 1) && j < (N - 1) && i > 0 && j > 0) { // i < N/2
    u_new[i * N + j] = 0.25 * (u_old[(i - 1) * N + j] + u_old[(i + 1) * N + j] +
                               u_old[i * N + (j - 1)] + u_old[i * N + (j + 1)] +
                               delta * f[i * N + j]);
  } else if (i == 0 && j < (N - 1) && j > 0) {
    u_new[i * N + j] = 0.25 * (d0_u_old[(N / 2 - 1) * N + j] +
                               u_old[(i + 1) * N + j] + u_old[i * N + (j - 1)] +
                               u_old[i * N + (j + 1)] + delta * f[i * N + j]);
  }
}

int main(int argc, char *argv[]) {

<<<<<<< HEAD
  // warm up:
  double *dummy_d;
  cudaSetDevice(device0);
  cudaMalloc((void **)&dummy_d, 0);
  cudaSetDevice(device1);
  cudaMalloc((void **)&dummy_d, 0);

  int kMAX, N, i, j;

  if (argc == 3) {
    N = atoi(argv[1]) + 2;
    kMAX = atoi(argv[2]);
  } else {
    // use default N
    N = 200;
    kMAX = 5000;
  }
  double delta = (2.0 / N) * (2.0 / N);

  // allocate mem
  double *h_f, *h_u_new, *h_u_old;
  double *d0_f, *d0_u_new, *d0_u_old, *d1_f, *d1_u_new, *d1_u_old;

  int size_f = N * N * sizeof(double);
  int size_u_new = N * N * sizeof(double);
  int size_u_old = N * N * sizeof(double);
  int size_f_p2 = N * N * 0.5;
  int size_u_new_p2 = N * N * 0.5;
  int size_u_old_p2 = N * N * 0.5;

  // Allocate memory on device
  cudaSetDevice(device0);
  cudaMalloc((void **)&d0_f, size_f / 2);
  cudaMalloc((void **)&d0_u_new, size_u_new / 2);
  cudaMalloc((void **)&d0_u_old, size_u_old / 2);
  cudaSetDevice(device1);
  cudaMalloc((void **)&d1_f, size_f / 2);
  cudaMalloc((void **)&d1_u_new, size_u_new / 2);
  cudaMalloc((void **)&d1_u_old, size_u_old / 2);
  // Allocate memory on host
  cudaMallocHost((void **)&h_f, size_f);
  cudaMallocHost((void **)&h_u_new, size_u_new);
  cudaMallocHost((void **)&h_u_old, size_u_old);

  // initialize boarder
  for (i = 0; i < N; i++) {
    for (j = 0; j < N; j++) {
      if (i >= N * 0.5 && i <= N * 2.0 / 3.0 && j >= N * 1.0 / 6.0 &&
          j <= N * 1.0 / 3.0)
        h_f[i * N + j] = 200.0;
      else
        h_f[i * N + j] = 0.0;

      if (i == (N - 1) || i == 0 || j == (N - 1)) {
        h_u_new[i * N + j] = 20.0;
        h_u_old[i * N + j] = 20.0;
      } else {
        h_u_new[i * N + j] = 0.0;
        h_u_old[i * N + j] = 0.0;
      }
=======
    // warm up:
    double *dummy_d;
    cudaSetDevice(device0);
    cudaMalloc((void**)&dummy_d, 0);
    cudaSetDevice(device1);
    cudaMalloc((void**)&dummy_d, 0);

    int kMAX, N,i,j;

    N = atoi(argv[1])+2;
    kMAX = atoi(argv[2]);

    double delta = (2.0 / N) * (2.0 / N);

    // allocate mem
    double *h_f, *h_u_new, *h_u_old;
    double *d0_f, *d0_u_new, *d0_u_old, *d1_f, *d1_u_new, *d1_u_old;

    int size = N * N * sizeof(double);
    int size_p2 = N*N*0.5;


    //Allocate memory on device
    cudaSetDevice(device0);
    cudaMalloc((void**)&d0_f, size/2);
    cudaMalloc((void**)&d0_u_new, size/2);
    cudaMalloc((void**)&d0_u_old, size/2);
    cudaSetDevice(device1);
    cudaMalloc((void**)&d1_f, size/2);
    cudaMalloc((void**)&d1_u_new, size/2);
    cudaMalloc((void**)&d1_u_old, size/2);
    //Allocate memory on host
    cudaMallocHost((void**)&h_f, size);
    cudaMallocHost((void**)&h_u_new, size);
    cudaMallocHost((void**)&h_u_old, size);

    // initialize boarder
    for (i = 0; i < N; i++){
        for (j = 0; j < N; j++){
            if (i >= N * 0.5  &&  i <= N * 2.0/3.0  &&  j >= N * 1.0/6.0  &&  j <= N * 1.0/3.0)
                h_f[i*N + j] = 200.0;
            else
                h_f[i*N + j] = 0.0;

            if (i == (N - 1) || i == 0 || j == (N - 1)){
                h_u_new[i*N + j] = 20.0;
                h_u_old[i*N + j] = 20.0;
            }
            else{
                h_u_new[i*N + j] = 0.0;
                h_u_old[i*N + j] = 0.0;
            }
        }
>>>>>>> c35594f8edc18d82038f020126488e7de339070c
    }
  }

  // Copy memory host -> device
  double time_tmp = omp_get_wtime();
  cudaSetDevice(device0);
  cudaMemcpy(d0_f, h_f, size_f / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(d0_u_new, h_u_new, size_u_new / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(d0_u_old, h_u_old, size_u_old / 2, cudaMemcpyHostToDevice);

  cudaSetDevice(device1);
  cudaMemcpy(d1_f, h_f + size_f_p2, size_f / 2, cudaMemcpyHostToDevice);
  cudaMemcpy(d1_u_new, h_u_new + size_u_new_p2, size_u_new / 2,
             cudaMemcpyHostToDevice);
  cudaMemcpy(d1_u_old, h_u_old + size_u_old_p2, size_u_old / 2,
             cudaMemcpyHostToDevice);
  double time_IO_1 = omp_get_wtime() - time_tmp;

  // peer enable
  cudaSetDevice(device0);
  cudaDeviceEnablePeerAccess(device1, 0);
  cudaSetDevice(device1);
  cudaDeviceEnablePeerAccess(device0, 0);

  // do program
  int k = 0;
  dim3 dim_grid(((N + BLOCK_SIZE - 1) / BLOCK_SIZE),
                ((N / 2 + BLOCK_SIZE - 1) / BLOCK_SIZE));
  dim3 dim_block(BLOCK_SIZE, BLOCK_SIZE);
  double *temp_p;
  double time_compute = omp_get_wtime();
  while (k < kMAX) {
    // Set u_old = u device 0
    temp_p = d0_u_new;
    d0_u_new = d0_u_old;
    d0_u_old = temp_p;
    // Set u_old = u device 0
    temp_p = d1_u_new;
    d1_u_new = d1_u_old;
    d1_u_old = temp_p;

<<<<<<< HEAD
    cudaSetDevice(device0);
    jacobi_gpu3_d0<<<dim_grid, dim_block>>>(N, delta, kMAX, d0_f, d0_u_new,
                                            d0_u_old, d1_u_old);
    cudaSetDevice(device1);
    jacobi_gpu3_d1<<<dim_grid, dim_block>>>(N, delta, kMAX, d1_f, d1_u_new,
                                            d1_u_old, d0_u_old);
    cudaDeviceSynchronize();
    cudaSetDevice(device0);
    cudaDeviceSynchronize();
    k++;
  } /* end while */
  double tot_time_compute = omp_get_wtime() - time_compute;
  // end program

  // Copy memory host -> device
  time_tmp = omp_get_wtime();
  cudaSetDevice(device0);
  cudaMemcpy(h_u_new, d0_u_new, size_u_new / 2, cudaMemcpyDeviceToHost);
  cudaSetDevice(device1);
  cudaMemcpy(h_u_new + size_u_new_p2, d1_u_new, size_u_new / 2,
             cudaMemcpyDeviceToHost);
  double time_IO_2 = omp_get_wtime() - time_tmp;

  tot_time_compute += time_IO_1 + time_IO_2;

  // stats
  double GB = 1.0e-09;
  double flop = kMAX * (double)(N) * (double)(N)*10.0;
  double gflops = (flop / tot_time_compute) * GB;
  double memory = size_f + size_u_new + size_u_old;
  double memoryGBs = memory * GB * (1 / tot_time_compute);

  printf("%d\t", N);
  printf("%g\t", memory); // footprint
  printf("%g\t", gflops); // Gflops
  // printf("%g\t", memoryGBs); // bandwidth GB/s
  printf("%g\t", tot_time_compute); // total time
  // printf("%g\t", time_IO_1 + time_IO_2); // I/O time
  // printf("%g\t", tot_time_compute); // compute time
  printf("# GPU3\n");
  write_matrix(h_u_new, N, "gpu3.dat");

  // peer enable
  cudaSetDevice(device0);
  cudaDeviceDisablePeerAccess(device1);
  cudaSetDevice(device1);
  cudaDeviceDisablePeerAccess(device0);

  // free mem
  cudaFree(d0_f), cudaFree(d0_u_new), cudaFree(d0_u_old);
  cudaFree(d1_f), cudaFree(d1_u_new), cudaFree(d1_u_old);
  cudaFreeHost(h_f), cudaFreeHost(h_u_new), cudaFreeHost(h_u_old);
  // end program
  return (0);
=======
    //Copy memory CPU -> GPU
    double time_tmp = omp_get_wtime();
    cudaSetDevice(device0);
    cudaMemcpy(d0_f, h_f, size/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d0_u_new, h_u_new, size/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d0_u_old, h_u_old, size/2, cudaMemcpyHostToDevice);
    cudaSetDevice(device1);
    cudaMemcpy(d1_f, h_f + size_p2, size/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d1_u_new, h_u_new + size_p2, size/2, cudaMemcpyHostToDevice);
    cudaMemcpy(d1_u_old, h_u_old + size_p2, size/2, cudaMemcpyHostToDevice);
    double time_IO_1 = omp_get_wtime() - time_tmp;

    // peer enable
    cudaSetDevice(device0);
    cudaDeviceEnablePeerAccess(device1,0);
    cudaSetDevice(device1);
    cudaDeviceEnablePeerAccess(device0,0);

    // do program
    int k = 0;
    dim3 dim_grid(((N +BLOCK_SIZE-1) / BLOCK_SIZE), ((N/2+BLOCK_SIZE-1) / BLOCK_SIZE));
    dim3 dim_block(BLOCK_SIZE, BLOCK_SIZE);
    double *temp_p;
    double time_compute = omp_get_wtime();
    while (k < kMAX) {
        // Set u_old = u device 0
        temp_p = d0_u_new;
        d0_u_new = d0_u_old;
        d0_u_old = temp_p;
        // Set u_old = u device 0
        temp_p = d1_u_new;
        d1_u_new = d1_u_old;
        d1_u_old = temp_p;

        cudaSetDevice(device0);
        jacobi_gpu3_d0<<<dim_grid, dim_block>>>(N, delta, kMAX, d0_f, d0_u_new, d0_u_old, d1_u_old);
        cudaSetDevice(device1);
        jacobi_gpu3_d1<<<dim_grid, dim_block>>>(N, delta, kMAX, d1_f, d1_u_new, d1_u_old, d0_u_old);
        cudaDeviceSynchronize();
        cudaSetDevice(device0);
        cudaDeviceSynchronize();
        k++;
    }/* end while */
    double tot_time_compute = omp_get_wtime() - time_compute;
    // end program

    //Copy memory GPU -> CPU
    time_tmp = omp_get_wtime();
    cudaSetDevice(device0);
    cudaMemcpy(h_u_new, d0_u_new, size/2, cudaMemcpyDeviceToHost);
    cudaSetDevice(device1);
    cudaMemcpy(h_u_new + size_p2, d1_u_new, size/2, cudaMemcpyDeviceToHost);
    double time_IO_2 = omp_get_wtime() - time_tmp;

    tot_time_compute += time_IO_1 + time_IO_2;

    // stats
    double GB = 1.0e-09;
    double flop = kMAX * (double)(N) * (double)(N) * 10.0;
    double gflops  = (flop / tot_time_compute) * GB;
    double memory  = size*3;
    double memoryGBs  = memory * GB * (1 / tot_time_compute);

    printf("%d\t", N);
    printf("%g\t", memory); // footprint
    printf("%g\t", gflops); // Gflops
    //printf("%g\t", memoryGBs); // bandwidth GB/s
    printf("%g\t", tot_time_compute); // total time
    //printf("%g\t", time_IO_1 + time_IO_2); // I/O time
    //printf("%g\t", tot_time_compute); // compute time
    printf("# GPU3\n");

    //To validate result we can write out the matrix
    write_matrix(h_u_new, N, "gpu3.dat");

    // peer enable
    cudaSetDevice(device0);
    cudaDeviceDisablePeerAccess(device1);
    cudaSetDevice(device1);
    cudaDeviceDisablePeerAccess(device0);

    // free mem
    cudaFree(d0_f), cudaFree(d0_u_new), cudaFree(d0_u_old);
    cudaFree(d1_f), cudaFree(d1_u_new), cudaFree(d1_u_old);
    cudaFreeHost(h_f), cudaFreeHost(h_u_new), cudaFreeHost(h_u_old);
    // end program
    return(0);
>>>>>>> c35594f8edc18d82038f020126488e7de339070c
}
