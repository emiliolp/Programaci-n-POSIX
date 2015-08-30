#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pwd.h>
#include <grp.h>

void imprimirUsuarioEspanol(struct passwd *pw)
{
    printf("Nombre de usuario: %s\n", pw->pw_gecos);
    printf("Identificador de usuario: %d\n", pw->pw_uid);
    printf("Contraseña: %s\n", pw->pw_passwd);
    printf("Carpeta inicio: %s\n", pw->pw_dir);
    printf("Intérprete por defecto: %s\n", pw->pw_shell);
}

void imprimirUsuarioIngles(struct passwd *pw)
{
    printf("User name: %s\n",pw->pw_gecos);
    printf("User id: %d\n",pw->pw_uid);
    printf("Password: %s\n",pw->pw_passwd);
    printf("Home: %s\n",pw->pw_dir);
    printf("Default shell: %s\n",pw->pw_shell);
}

int main (int argc, char **argv)
{
    int gflag = 0;		/*Bandera información grupo*/
    int eflag = 0;		/*Bandera datos en español*/
    int sflag = 0;		/*Bandera datos en inglés*/
    char *uvalue = NULL;	/*Nombre de usuario*/
    int index;
    int c;
    char *lgn;
    struct passwd *pw;
    struct group *gr;
    const char *lang="LANG";
    char *valueLang;
    valueLang = getenv(lang);

    opterr = 0;

    while ((c = getopt (argc, argv, "u:ges")) != -1)
    {
        switch (c)
        {
        case 'g':
            gflag = 1;
            break;
        case 'e':
            eflag = 1;
            break;
        case 's':
            sflag=1;
            break;
        case 'u':
            uvalue = optarg;
            break;
        case '?':
            if (optopt == 'u')
                fprintf (stderr, "La opción %c requiere un argumento.\n", optopt);
            else if (isprint (optopt))
                fprintf (stderr, "Opción desconocida '-%c'.\n", optopt);
            else
                fprintf (stderr, "Caracter `\\x%x'.\n", optopt);
            return 1;
        default:
            abort ();
        }
    }

    for (index = optind; index < argc; index++)
        printf ("Argumento de la línea de comandos que NO es una opción %s\n", argv[index]);

    
    if(eflag && sflag)		/*Se ha introducido dos idiomas*/
    {
            printf("Error solo una de las dos\n");
            exit(-1);
    }
    
    if(uvalue)			/*Se ha introducido nombre de usuario*/
    {
        lgn = uvalue;
        if ((pw = getpwnam(lgn)) == NULL)
        {
            fprintf(stderr, "Get of user information failed.\n");
            exit(1);
        }
    }
    else	/*Si no se introduce username se coge el actual*/
    {
        lgn=getlogin();
        if ((pw = getpwnam(lgn)) == NULL)
        {
            fprintf(stderr, "Get of user information failed.\n");
            exit(1);
        }
    }

    if(eflag)	/*Información en español*/
    {
        imprimirUsuarioEspanol(pw);

        if(gflag)	/*Información del grupo*/
        {
            gr = getgrgid(pw->pw_gid);
            printf("Número id del grupo: %d\n", pw->pw_gid);
            printf("Nombre del grupo: %s\n", gr->gr_name);
        }
    }
    else if (sflag)	/*Información en inglés y del grupo*/
    {
        imprimirUsuarioIngles(pw);

        if(gflag)
        {
            gr=getgrgid(pw->pw_gid);
            printf("Main Group Number: %d\n",pw->pw_gid);
            printf("Main Group Name: %s\n",gr->gr_name);
        }
    }
    else if(!eflag && !sflag)	/*No se ha introducido idioma se busca el idioma del equipo*/
    {
        if (strstr(valueLang,"ES"))
        {
            imprimirUsuarioEspanol(pw);
                
            if(gflag)
            {
                gr=getgrgid(pw->pw_gid);
                printf("Número id del grupo: %d\n",pw->pw_gid);
                printf("Nombre del grupo: %s\n",gr->gr_name);
            }
        }
        else
        {
            imprimirUsuarioIngles(pw);

            if(gflag)
            {
                gr=getgrgid(pw->pw_gid);
                printf("Main Group Number: %d\n",pw->pw_gid);
                printf("Main Group Name: %s\n",gr->gr_name);
            }
        }
    }
	return 0;
}
