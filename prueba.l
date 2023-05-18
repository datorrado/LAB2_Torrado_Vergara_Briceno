%{
#include <stdio.h>
#include <string.h>
#include <stdbool.h>
#include "y.tab.h"

int contador = 1;
int cont_linea = 2;
int cont_lex = 0;
int new_line = 0;
int errorlexico = 0;
extern int errorcounter;
%}

%%

[01]+ {
    printf("num%d = %s\n", contador, yytext);
    contador++;
    return NUM;
}

[+] {
    printf("op-sum = %s\n", yytext);
    return MAS;
}

[*] {
    printf("op-mul = %s\n", yytext);
    return POR;
}

[-] {
    printf("op-men = %s\n", yytext);
    return MENOS;
}

[/] {
    printf("op-div = %s\n", yytext);
    return DIV;
}

[(] {
    printf("par-a = %s\n", yytext);
    return PAR_IZQ;
}

[)] {
    printf("par-c = %s\n", yytext);
    return PAR_DER;
}

not {
    printf("op-%s = %s\n", yytext, yytext);
    return NOT;
}

and {
    printf("op-%s = %s\n", yytext, yytext);
    return AND;
}

or {
    printf("op-%s = %s\n", yytext, yytext);
    return OR;
}

xor {
    printf("op-%s = %s\n", yytext, yytext);
    return XOR;
}

"$" {
    return ACCEPT;
}  

[01]+[\+\-\*\/]+[2-9]+ {
    printf("Error Léxico: %s\n", yytext);
    errorlexico = 1;
}

[2-9]+[\+\-\*\/]+[01]+ {
    printf("Error Léxico: %s\n", yytext);
    errorlexico = 1;
}

[2-9]+[01]+[2-9]+ {
    printf("Error Léxico: %s\n", yytext);
    errorlexico = 1;
}

[2-9]+[\+\-\*\/]+[2-9]+ {
    printf("Error Léxico: %s\n", yytext);
    errorlexico = 1;
}

[01]*[^(01)+\+\-\*\(\)\/ \n\t]+[01]* {
    printf("Error Léxico: %s\n", yytext);
    errorlexico = 1;
}

. {

}

[\n] {
    if (new_line) {
        printf("\n Linea %d\n", cont_linea);
        cont_linea++;
    }

    new_line = 1;
    errorlexico = 0; // Reiniciar la variable de error léxico al final de cada línea
}


%%

int yywrap() {
    return 1;
}
