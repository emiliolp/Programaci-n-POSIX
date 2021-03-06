#include <sys/ipc.h>
#include <sys/types.h>
#include <sys/msg.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <ctype.h>
#include <signal.h>     /* Manejo de señales */

#define ID_COLA_CENTRAL 2400	// Identificador para la cola central

struct {
	long prioridad;		// Prioridad del mensaje
	int id;			// Identificador del proceso
	int temp;		// Temperatura
	int esEstable;		// 1: estable, 0: no estable
} mensajeRecibido, mensajeEnviado;

// Apuntador al fichero de log (se utilizará en el ejercicio resumen)
FILE *fLog = NULL;

// Prototipo de la función de log
void funcionLog(char *mensaje);
void manejador(int signal);
// Descriptor de la cola de este proceso
int desColaProceso = -1;

// Identificador del proceso (parámetro de la línea de comandos)
int idProceso;
char mensaje[300];
char ruta[100];		//ruta incluido el fichero actual
char *cwd;		//path del fichero	
// Main
int main(int argc, char *argv[]) {

	// Variables locales
	int esInestable = 1;
	int resultado, longitudMensaje;
	int temperaturaInicial=50;
	int desColaCentral;
	int c;
	int iflag=0;


	if (signal(SIGINT, manejador) == SIG_ERR)
        printf("No puedo asociar la señal SIGINT al manejador!\n");
    if (signal(SIGHUP, manejador) == SIG_ERR)
        printf("No puedo asociar la señal SIGHUP al manejador!\n");
    if (signal(SIGTERM, manejador) == SIG_ERR)
        printf("No puedo asociar la señal SIGTERM al manejador!\n");

	while ((c = getopt (argc, argv, "i:t:")) != -1)
    	{
        /* Podemos observar qué pasas con las variables externas que va gestionando
           getopt() durante las sucesivas llamadas 
           optopt recoge el valor de la opción cuando es desconocida (?)*/
        if(c=='i')
        {
        	iflag=1;
        }
        switch (c)
        {
        case 'i':
            idProceso = atoi(optarg);
            break;
        case 't':
        	temperaturaInicial = atoi(optarg);
        	break;
        case '?':
            if (optopt == 'i')
                fprintf (stderr, "La opción %c requiere un argumento.\n", optopt);
            else if (optopt=='t')
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
    	if(!iflag)
    	{
    		sprintf(mensaje,"Debe introducir un identificador de proceso\n");
    		printf("%s",mensaje);
		funcionLog(mensaje);
    		exit(0);
    	}
		

	if((cwd=getcwd(NULL,500))==NULL)
	{
		perror("pwddfsd");
		exit(2);
	}
	sprintf(ruta,"%s/ejercicio4-servidor.c",cwd);
	key_t key=ftok(ruta,ID_COLA_CENTRAL);

	sprintf(mensaje,"Lanzando el proceso cliente %d...\n", idProceso);
	printf("%s",mensaje);
	funcionLog(mensaje);

	// Crear o abrir la cola central con identificador ID_COLA_CENTRAL
	desColaCentral = msgget(key, 0600 | IPC_CREAT);

	// Crear o abrir la cola concreta para este proceso y almacenar el identificador
	// Usaremos como identificador ID_COLA_CENTRAL más lo que se pasa como argumento
	desColaProceso = msgget((key + idProceso), 0600 | IPC_CREAT);

	// Inicializar el mensaje a enviar
	mensajeEnviado.prioridad = 1;
	mensajeEnviado.id = idProceso;
	mensajeEnviado.temp = temperaturaInicial;
	mensajeEnviado.esEstable = 1;

	// La longitud del mensaje es el tamaño de la estructura
	longitudMensaje = sizeof(mensajeEnviado) - sizeof(long);

	// Mientras que todos los procesos tengan distinta temperatura
	while(esInestable == 1){
		// Envío mi temperatura al proceso central
		resultado = msgsnd( desColaCentral, &mensajeEnviado, longitudMensaje, 0);
		if(resultado != 0){
			sprintf(mensaje,"\nERROR al mandar el mensaje a la cola central\n");
			printf("%s",mensaje);
			funcionLog(mensaje);
			exit(1);				
		}


		// Recibo un nuevo mensaje del proceso central
		resultado = msgrcv( desColaProceso, &mensajeRecibido, longitudMensaje, 1, 0);
		if(resultado != longitudMensaje){
			sprintf(mensaje,"\nERROR al recibir el mensaje de la cola central\n");
			printf("%s",mensaje);
			funcionLog(mensaje);
			exit(1);				
		}

		// Si el mensaje indica que ya se ha estabilizado la temperatura
                // Salgo del bucle
		if(mensajeRecibido.esEstable == 1) {
			esInestable = 0;
			sprintf(mensaje,"\nProceso %d termina con temperatura: %d\n", mensajeEnviado.id, mensajeEnviado.temp);
			printf("%s",mensaje);
			funcionLog(mensaje);
		}
		// En otro caso, calculamos una nueva temperatura y la almacenamos
		else {
			int nuevaTemperatura = (mensajeEnviado.temp * 3 + 2 * mensajeRecibido.temp) / 5;
			sprintf(mensaje,"Nueva temperatura %d\n",nuevaTemperatura);
			printf("%s",mensaje);
			funcionLog(mensaje);
			// Actualizo la temperatura para volvérsela a enviar al servidor
			mensajeEnviado.temp = nuevaTemperatura;
		}
	}

	exit(0);
}

// Función auxiliar, escritura de un log
void funcionLog(char *mensaje) {
	int resultado;
	char nombreFichero[100];
	char mensajeAEscribir[300];
	time_t t;

	// Abrir el fichero
	sprintf(nombreFichero,"log-cliente-%d.txt",idProceso);
	if(fLog==NULL)
		fLog = fopen(nombreFichero,"at");

	// Obtener la hora actual
	t = time(NULL);
	struct tm * p = localtime(&t);
	strftime(mensajeAEscribir, 1000, "[%Y-%m-%d, %H:%M:%S]", p);

	// Vamos a incluir la hora y el mensaje que nos pasan
	sprintf(mensajeAEscribir, "%s ==> %s\n", mensajeAEscribir, mensaje);
	
	// Escribir finalmente en el fichero
	resultado = fputs(mensajeAEscribir,fLog);
	if ( resultado < 0)
		printf("Error escribiendo en el fichero de log\n");

	fclose(fLog);
	fLog=NULL;
}

void manejador(int signal){
	int i;
	switch(signal)
	{
		case SIGINT:
			sprintf(mensaje,"\nCapturada la señal SIGINT\n");
			printf("%s",mensaje);
			funcionLog(mensaje);
			break;

		case SIGHUP:
			sprintf(mensaje,"\nCapturada la señal SIGHUP\n");
			printf("%s",mensaje);
			funcionLog(mensaje);
			break;

		case SIGTERM:
			sprintf(mensaje,"Capturada la señal SIGTERM\n");
			printf("%s",mensaje);
			funcionLog(mensaje);
			break;
	}

	sprintf(mensaje,"\nCerrando la cola de este proceso...\n");
	printf("%s",mensaje);
	funcionLog(mensaje);
	int resultado = msgctl(desColaProceso, IPC_RMID, 0);
	if(resultado != 0){
		sprintf(mensaje,"\nERROR cerrando la cola de este proceso\n");
		printf("%s",mensaje);
		funcionLog(mensaje);
	}
	for(i=0; i<3; i++){
        printf("Hasta luego... cerrando ficheros...\n");
        sleep(2);
    }
    exit(0);
}
