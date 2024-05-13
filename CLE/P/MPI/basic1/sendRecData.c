#include <mpi.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main (int argc, char *argv[])
{
    int rank; // 0, . . . , size − 1, where size is the number of processes in the group
    char data[] = "I am here!", *recData;

    MPI_Init (&argc, &argv);
    MPI_Comm_rank (MPI_COMM_WORLD, &rank);
    if (rank == 0) { 
        printf ("Transmitted message: %s \n", data);
        MPI_Send (data, strlen (data), MPI_CHAR, 1, 0, MPI_COMM_WORLD); // sends data from process 0 to process 1
    } else if (rank == 1){ 
        int i;
        recData = malloc (100);
        for (i = 0; i < 100; i++)
        recData[i] = '\0';
        MPI_Recv (recData, 100, MPI_CHAR, 0, 0, MPI_COMM_WORLD, MPI_STATUS_IGNORE); // receives data into recData buffer from process 0
        printf ("Received message: %s \n", recData);
    }
    MPI_Finalize ();

    return EXIT_SUCCESS;
}
