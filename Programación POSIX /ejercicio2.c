#include <unistd.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <pwd.h>
#include <grp.h>
#include <string.h>

int main (int argc, char **argv)
{
    char *gvalue = NULL;
    int eflag = 0;
    int sflag = 0;
    //char *uvalue = NULL;
    int index;
    int c;
    char *lgn;
    //char *grp;
    struct passwd *pw;
    struct group *gr;
    const char *path="PATH";
    char *valuePath;
    valuePath = getenv(path);		/*Path utilizada por el usuario actual*/
    const char *lang="LANG";
    char *valueLang;
    valueLang = getenv(lang);		/*Idioma actual*/

    opterr = 0;
    while ((c = getopt (argc, argv, "g:es")) != -1)	/*Examina los parámetros introducidos*/
    {
        switch (c)
        {
        case 'g':
            gvalue = optarg;
            break;
        case 'e':
            eflag = 1;
            break;
        case 's':
            sflag=1;
            break;
        case '?':
            if (optopt == 'g')
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

    
    if(eflag && sflag)			/*Error al introducir idioma*/
    {
            printf("Error solo una de las dos\n");
            exit(-1);
    }

    if(gvalue)
    {
    	if((gr = getgrnam(gvalue))==NULL)
    	{
    		fprintf(stderr, "Get of group information failed.\n");
            exit(1);
    	}
    }
    else
    {
	lgn=getlogin();						//usuario actual
	if ((pw = getpwnam(lgn)) == NULL)			//estructura usuario actual
        {
            fprintf(stderr, "Get of user information failed.\n");
            exit(1);
        }

    	if((gr=getgrgid(pw->pw_gid))==NULL)			//grupo usuario actual
    	{
    		fprintf(stderr,"Get of group information failed.\n");
    		exit(1);
    	}
    }

    if(eflag)
    {
        printf("Path del usuario actual: %s\n",valuePath);
        printf("Identificador del grupo: %d\n",gr->gr_gid);
        printf("Nombre del grupo: %s\n",gr->gr_name);
    }
    else if(sflag)
    {
        printf("Current user path: %s\n",valuePath);
        printf("Group identifier: %d\n",gr->gr_gid);
        printf("Group name: %s\n",gr->gr_name);
    }
    else if(!eflag && !sflag)
    {
        if (strstr(valueLang,"ES"))
        {
            printf("Path del usuario actual: %s\n",valuePath);
            printf("Identificador del grupo: %d\n",gr->gr_gid);
            printf("Nombre del grupo: %s\n",gr->gr_name);
        }
        else
        {
            printf("Current user path: %s\n",valuePath);
            printf("Group identifier: %d\n",gr->gr_gid);
            printf("Group name: %s\n",gr->gr_name);
        }
    }
	return 0;
}
