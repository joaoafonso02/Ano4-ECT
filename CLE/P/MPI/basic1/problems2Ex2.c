#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int rank, size;
    char data[100], recData[100];

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (rank == 0) {
        sprintf(data, "I am here (%d) and alive!", rank);
        // sends data to all other processes
        for (int i = 1; i < size; i++) {
            MPI_Send(data, strlen(data) + 1, MPI_CHAR, i, 0, MPI_COMM_WORLD);
        }

        // The process of rank 0 reads all the messages that it has received and prints them in the computer screen.
        for (int i = 1; i < size; i++) {
            MPI_Recv(recData, 100, MPI_CHAR, i, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE);
            printf("Process %d received message: %s\n", i, recData);
        }
    } else {
        MPI_Recv(recData, 100, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // receives data from rank 0
        sprintf(data, "I am here (%d) and alive!", rank);
        MPI_Send(data, strlen(data) + 1, MPI_CHAR, 0, 0, MPI_COMM_WORLD); // sends data back to rank 0
    }

    MPI_Finalize();

    return EXIT_SUCCESS;
}
