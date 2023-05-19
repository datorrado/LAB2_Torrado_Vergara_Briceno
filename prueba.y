%{
#include <stdio.h>
#include "lex.yy.c"

extern FILE *yyin;
extern int yylex();
extern int yylineno;
void yyerror(char *s);
void yyrestart(FILE* archivo);
int errorcounter=0;
extern int errorlexico;
// extern void yy_scan_string(const char *str);

%}

%token NUM AND OR XOR NOT
%token MAS MENOS POR DIV PAR_IZQ PAR_DER
%token ACCEPT

%left MAS MENOS
%left POR DIV
%left AND OR XOR
%right NOT

%%

expresion: expresion MAS expresion
         | expresion MENOS expresion
         | expresion POR expresion
         | expresion DIV expresion
         | expresion AND expresion
         | expresion OR expresion
         | expresion XOR expresion
         | NOT expresion
         | PAR_IZQ expresion PAR_DER
         | operando
         | error
         | expresion ACCEPT {//printf("Fin de la entrada en esa linea!\n");
                   if(errorlexico==1){
                    return 2;
                    }
                }
         ;

operando: NUM;

%%

void yyerror(char *s) {
    //printf("Error sintáctico!\n");
    errorcounter++;
}

int main(int cont_entradas, char *entradas[]) {
    //freopen("salida.txt", "w", stdout);
    // Validacion de entradas 
    if (cont_entradas < 2) {
        printf("Invalido. Asegurese de proveer un archivo de entrada");
        return 1;
    } else if (cont_entradas > 2) {
        printf("Invalido. Recuerde que solo puede haber un archivo de entrada");
        return 1;
    }

    // Abrir el archivo y validarlo
    /* printf("Linea 1\n"); */
    FILE *f = fopen(entradas[1], "r");
    if (!f) {
        printf("El siguiente archivo no se pudo abrir: %s \n", entradas[1]);
        return 1;
    } 

    // Iniciar analisis con el archivo como entrada
    yyin = f;


    int linea = 1;
    char buffer[1024];

    while (fgets(buffer, sizeof(buffer), f)) {
        printf("Línea %d\n", linea);
        strtok(buffer, "\n");
        strcat(buffer, " $");

        // Pasar la línea al analizador léxico
        YY_BUFFER_STATE rbuffer = yy_scan_string(buffer);

        // Iniciar el análisis sintáctico
        int result = yyparse();
        /* printf("\n");
        printf("Resultado: %d\n", result);
        printf("Error léxicos: %d\n", errorlexico); */
        if (result == 2) {
            printf("No se ejecuta el análisis sintáctico\n");
        } else if (errorcounter > 0 ) {
            printf("Análisis sintáctico\nErrores sintácticos: %d\n", errorcounter);
        } else {
            printf("Análisis sintáctico\nCorrecto!\n");
        }

        // Reiniciar el analizador léxico para la siguiente línea
        //yyrestart(f);
        errorlexico = 0;
        errorcounter = 0;
        yy_delete_buffer(rbuffer);
        linea++;
        printf("\n");
    }
    // Terminar ejecucion
    fclose(f);
    return 0;
}
