#include <stdio.h>
#include <stdlib.h>
#include <wchar.h>
#include <locale.h>
#include <string.h>

int is_whitespace(wchar_t c) {
    return c == L' ' || c == L'\t' || c == L'\n' || c == L'\r';
}

int is_separation_symbol(wchar_t c) {
    return c == L'-' || c == L'\"' || c == L'“' || c == L'”' || c == L'[' || c == L']' || c == L'(' || c == L')';
}

int is_punctuation_symbol(wchar_t c) {
    return c == L'.' || c == L',' || c == L':' || c == L';' || c == L'?' || c == L'!' || c == L'—' || c == L'…';
}

void print_utf8_character(wchar_t c) {
    char utf8_buffer[4 * MB_CUR_MAX]; // Assuming a maximum of 4 bytes for a UTF-8 character
    int utf8_bytes = wctomb(utf8_buffer, c);

    if (utf8_bytes != -1) {
        utf8_buffer[utf8_bytes] = '\0';
        printf("UTF8 CHARACTER: %s (Hex: %04X)\n", utf8_buffer, c);
    } else {
        printf("Error: Invalid UTF-8 character\n");
    }
}

int main(int argc, char *argv[]) {
    setlocale(LC_ALL, "en_US.UTF-8");
    FILE *file;
    wchar_t c;
    int words = 0;
    int consonants = 0;
    
    for (int i = 1; i < argc; i++) {
        file = fopen(argv[i], "r");
        if (file == NULL) {
            printf("Error: File not found\n");
            return 1;
        }

        while ((c = fgetwc(file)) != WEOF) {
            if (is_whitespace(c) || is_separation_symbol(c) || is_punctuation_symbol(c)) {
                // Ignore whitespace, separation symbols, and punctuation symbols
            } else {
                words++;

                if (iswalnum(c) || wcschr(L"'‘’", c) != NULL) {
                    if (towlower(c) != L'a' && towlower(c) != L'e' && towlower(c) != L'i' && towlower(c) != L'o' && towlower(c) != L'u') {
                        consonants++;
                    }
                }

                // Print UTF-8 character information
                print_utf8_character(c);
            }
        }

        printf("File: %s\n", argv[i]);
        printf("Words: %d\n", words);
        printf("Consonants: %d\n", consonants);
        words = 0;
        consonants = 0;
        fclose(file);
    }

    return 0;
}
