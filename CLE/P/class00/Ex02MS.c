// MS -> MERGE SORTING
#include <stdio.h>
#include <stdlib.h>

void merge(int* arr, int l, int m, int r) {
    int i, j, k;
    int n1 = m - l + 1; // size of left array
    int n2 = r - m; // size of right array

    int* LeftArray= (int*) malloc(sizeof(int)*n1);
    int* RightArray= (int*) malloc(sizeof(int)*n2);

    for (i = 0; i < n1; i++)
        LeftArray[i] = arr[l + i]; 
    for (j = 0; j < n2; j++)
        RightArray[j] = arr[m + 1 + j]; 

    i = 0, j = 0; k = l; 
    while (i < n1 && j < n2) {
        if (LeftArray[i] >= RightArray[j]) {
            arr[k] = LeftArray[i];
            i++;
        } else {
            arr[k] = RightArray[j];
            j++;
        }
        k++;
    }

    while (i < n1) {
        arr[k] = LeftArray[i];
        i++;
        k++;
    }

    while (j < n2) {
        arr[k] = RightArray[j];
        j++;
        k++;
    }
}

void merge_sort(int* arr, int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;

        merge_sort(arr, l, m);
        merge_sort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Please provide a file name as a command line argument.\n");
        return 1;
    }

    FILE *file = fopen(argv[1], "rb");
    if (file == NULL) {
        printf("Unable to open file.\n");
        return 1;
    }

    // n of integers in the file is given by the first num of the file
    int n;
    printf("aaaa\n");
    fread(&n, sizeof(int), 1, file);
    printf("%d\n", n);
    int* arr = (int*) malloc(sizeof(int)*n);

    fread(arr, sizeof(int), n, file);

    fclose(file);


    // printf("Original array: \n");
    // for (int i = 0; i < n; i++) {
    //     printf("%d ", arr[i]);
    // }

    // Perform merge sort
    printf("skrtt\n");
    merge_sort(arr, 0, n - 1);

    printf("\n\nSorted array: \n");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }

    printf("\n");
    return 0;
}
