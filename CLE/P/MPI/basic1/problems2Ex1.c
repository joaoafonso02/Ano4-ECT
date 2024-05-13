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

    sprintf(data, "I am here (%d)!", rank);

    MPI_Request request;

    if (rank == 0) {
        MPI_Isend(data, strlen(data) + 1, MPI_CHAR, (rank + 1) % size, 0, MPI_COMM_WORLD, &request); // sends data to the next process
        MPI_Recv(recData, 100, MPI_CHAR, size - 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // receives data from the last process
    } else {
        MPI_Recv(recData, 100, MPI_CHAR, rank - 1, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // receives data from the previous process
        MPI_Send(data, strlen(data) + 1, MPI_CHAR, (rank + 1) % size, 0, MPI_COMM_WORLD); // sends data to the next process
    }

    printf("Process %d received message: %s\n", rank, recData);

    MPI_Finalize();

    return EXIT_SUCCESS;
}
