#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define MATRIX_SIZE 4

void generateRandomMatrix(int matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            matrix[i][j] = rand() % 10; // Generate random numbers between 0 and 9
        }
    }
}

void printMatrix(int matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            printf("%d\t", matrix[i][j]);
        }
        printf("\n");
    }
}

int main(int argc, char** argv) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int A[MATRIX_SIZE][MATRIX_SIZE], B[MATRIX_SIZE][MATRIX_SIZE], C[MATRIX_SIZE][MATRIX_SIZE];

    if (rank == 0) {
        // Initialize matrices A and B in process 0
        generateRandomMatrix(A);
        generateRandomMatrix(B);
    }

    // Broadcast matrices A and B to all processes
    MPI_Bcast(A, MATRIX_SIZE * MATRIX_SIZE, MPI_INT, 0, MPI_COMM_WORLD);
    MPI_Bcast(B, MATRIX_SIZE * MATRIX_SIZE, MPI_INT, 0, MPI_COMM_WORLD);

    // Initialize matrix C to all 0s
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            C[i][j] = 0;
        }
    }

    // Compute the local portion of the result matrix C
    for (int i = rank * MATRIX_SIZE / size; i < (rank + 1) * MATRIX_SIZE / size; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            for (int k = 0; k < MATRIX_SIZE; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }

    // Non-blocking send and receive to gather partial results
    MPI_Request send_req, recv_req;
    MPI_Status status;
    if (rank != 0) {
        MPI_Isend(C, MATRIX_SIZE * MATRIX_SIZE / size, MPI_INT, 0, 0, MPI_COMM_WORLD, &send_req);
    } else {
        for (int i = 1; i < size; i++) {
            MPI_Irecv(C + i * MATRIX_SIZE / size, MATRIX_SIZE * MATRIX_SIZE / size, MPI_INT, i, 0, MPI_COMM_WORLD, &recv_req);
            MPI_Wait(&recv_req, &status);
        }
    }

    // Synchronize all processes before printing the result
    MPI_Barrier(MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Matrix A:\n");
        printMatrix(A);
        printf("\n");

        printf("Matrix B:\n");
        printMatrix(B);
        printf("\n");

        printf("Matrix C (Product of A and B):\n");
        printMatrix(C);
    }

    MPI_Finalize();

    return 0;
}
