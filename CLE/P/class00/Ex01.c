#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>
#include <locale.h>
#include <string.h>

#define NUM_CONSONANTS 26

int is_whitespace(wchar_t c) {
    return c == L' ' || c == L'\t' || c == L'\n' || c == L'\r';
}

int is_separation_symbol(wchar_t c) {
    return c == L'-' || c == L'\"' || c == L'“' || c == L'”' || c == L'[' || c == L']' || c == L'(' || c == L')';
}

int is_punctuation_symbol(wchar_t c) {
    return c == L'.' || c == L',' || c == L':' || c == L';' || c == L'?' || c == L'!' || c == L'—' || c == L'…';
}

int is_alphanumeric_or_underscore(wchar_t c) {
    return iswalnum(c) || c == L'_'; // is alpha or digit
}

int is_consonant(wchar_t c) {
    return wcschr(L"aeiouAEIOU", towlower(c)) == NULL;
}

void set_to_zero(int *numberOfConsonantsOccur) {
    for (int i = 0; i < NUM_CONSONANTS; i++) {
        numberOfConsonantsOccur[i] = 0;
    }
}

void process_a_char(wchar_t c, int *inWord, int *nWords, int *nWordsWMultCons, int *numberOfConsonantsOccur) {
    if (is_whitespace(c) || is_separation_symbol(c) || is_punctuation_symbol(c) || c == L'\0') {
        if (*inWord) {
            *inWord = 0;
            (*nWords)++;
        }
    } else {
        if (!*inWord) {
            *inWord = 1;
        }
        if (is_alphanumeric_or_underscore(c)) {
            if (is_consonant(c) && towlower(c) >= L'a' && towlower(c) <= L'z'){
                printf("Consonant: %lc\n", c);
                int index = towlower(c) - L'a';
                numberOfConsonantsOccur[index]++;
                if (numberOfConsonantsOccur[index] > 1) {
                    (*nWordsWMultCons)++;
                }
            }
        }
    }
}

void print_utf8_character(wchar_t c) {
    char utf8_buffer[4 * MB_CUR_MAX]; 
    int utf8_bytes = wctomb(utf8_buffer, c);

    if (utf8_bytes != -1) {
        utf8_buffer[utf8_bytes] = '\0';
        printf("UTF8 CHARACTER: %s (Hex: %04X)\n", utf8_buffer, c);
    } else {
        printf("Invalid UTF-8 character\n");
    }
}

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "en_US.UTF-8");
    FILE *file;
    wchar_t c;
    int inWord = 0;
    int nWords = 1;
    int nWordsWMultCons = 0;
    int numberOfConsonantsOccur[NUM_CONSONANTS] = {0};

    for (int i = 1; i < argc; i++) {
        file = fopen(argv[i], "r");

        while ((c = fgetwc(file)) != WEOF) {
            process_a_char(c, &inWord, &nWords, &nWordsWMultCons, numberOfConsonantsOccur);
        }

        fclose(file);

        // Print the results for the current file
        printf("File: %s\n", argv[i]);
        printf("Number of words: %d\n", nWords);
        printf("Number of words with multiple consonants: %d\n", nWordsWMultCons);
   
        // Reset counters for the next file
        inWord = 0;
        nWords = 0;
        nWordsWMultCons = 0;
        set_to_zero(numberOfConsonantsOccur);
    }

    return 0;
}
