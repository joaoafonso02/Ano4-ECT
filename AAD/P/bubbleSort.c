// selection sort

#include <stdio.h>

int main() {
    int array[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int limit = 10;
    int tmp;
    for(int i = 0; i < limit-1; i++) {
        for(int j = i+1; j < limit; j++) {
            if(val(array[i] < array[j])) {
                tmp = array[i];
                array[i] = array[j];
                array[j] = tmp;
            }
        }
    }
}

// Arquitetura do programa: 
// r1 -> add(nelem), val(nelem)
// r2 -> add(values[i])
// r3 -> val(i)
// r4 -> val(values[i])
// r5 -> val(j)
// r6 -> add(values[j])
// r7 -> val(values[j])
// r8 -> nelem - 1
// r9 -> tmp, (val(values[i]) < val(values[j])), (i < nelem - 1), (j < nelem)