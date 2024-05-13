#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>
#include <time.h>
#include <limits.h>

int main(int argc, char *argv[]) {
    int rank, size;
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int sequence_length = 64;
    int *random_seq = (int *) malloc(sequence_length * sizeof(int));
    
    if (rank == 0) {
        srand(time(NULL));
        for (int i = 0; i < sequence_length; i++) {
            random_seq[i] = rand() % 1000;
        }
    }

    int local_length = sequence_length / size;
    int *local_seq = (int *) malloc(local_length * sizeof(int));

    MPI_Scatter(random_seq, local_length, MPI_INT, local_seq, local_length, MPI_INT, 0, MPI_COMM_WORLD);

    int local_min = INT_MAX, local_max = INT_MIN;
    for (int i = 0; i < local_length; i++) {
        if (local_seq[i] < local_min) {
            local_min = local_seq[i];
        }
        if (local_seq[i] > local_max) {
            local_max = local_seq[i];
        }
    }

    int global_min, global_max;

    MPI_Reduce(&local_min, &global_min, 1, MPI_INT, MPI_MIN, 0, MPI_COMM_WORLD);
    MPI_Reduce(&local_max, &global_max, 1, MPI_INT, MPI_MAX, 0, MPI_COMM_WORLD);

    if (rank == 0) {
        printf("Min = %d, Max = %d\n", global_min, global_max);
    }

    MPI_Finalize();
    free(random_seq);
    free(local_seq);

    return EXIT_SUCCESS;
}
