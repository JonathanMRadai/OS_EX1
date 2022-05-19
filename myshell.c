//207017443 Yonathan Mevarech-Radai
#include <stdio.h>
#include <string.h>
#include <unistd.h> 
#include <stdlib.h>
#include <stdio.h>
#include "string.h"
#include<unistd.h>
#include <sys/types.h>
#include<sys/wait.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct Data{
    char command[100];
    pid_t pid;

} Data;


typedef struct tmp
{
	Data* item;
	struct tmp *  next;
}Node;



typedef struct
{
	Node * head;
	Node * tail;

}List;


void initList(List * lp)
{
	lp->head = NULL;
	lp->tail = NULL;
}


Node * createNode(Data* item)
{
	Node * nNode;

	nNode = (Node *) malloc(sizeof(Node));

	nNode->item = item;
	nNode->next = NULL;

	return nNode;
}



void addAtTail(List * lp, Data* item)
{
	Node * node;
	node = createNode(item);

	
	if(lp->head == NULL)
	{
		lp->head = node;
		lp->tail = node;
	}
	else
	{
		lp->tail->next = node;
		lp->tail = lp->tail->next;
	}		
}

void printData(Node* n){
    printf("%d %s\n", n->item->pid, n->item->command);
}


void printList(List *lp)
{
	Node * node;
	node = lp->head;
	while(node != NULL)
	{
		printData(node);
        node = node->next;
	}
	
}



Data *createDate(char* command, pid_t pid) {

    Data* d = (Data*) malloc(sizeof(struct Data));
    strcpy(d->command, command);
    d->pid = pid;
    return d;

}

void deleteList(List* lp){
    Node * node;
    Node * temp;
	node = lp->head;
	while(node != NULL)
	{
        temp = node;
        node = node->next;
        free(temp->item);
        free(temp);
	}

}


void toHistory(char* command, pid_t pid, List *history){

    addAtTail(history, createDate(command,pid));
}


int CD(const char *path){
    return chdir(path);
}


void options(char* buffer, char **command_arr, int *command_arr_idx, char* command, List *history) {
    pid_t pid = getpid();
    int status;

    if (strcmp(command_arr[0], "cd") == 0) {
        CD(command_arr[1]);
       
    } 
    else if (strcmp(command_arr[0], "exit") == 0){
        deleteList(history);
        exit(0);
    }
    else if (strcmp(command_arr[0], "history") == 0){
        toHistory(command, pid, history);
        printList(history);
        return;
    }

    else {
        if ((pid = fork()) == 0) {
            if(execvp(command_arr[0], command_arr) == -1){
                perror("execvp failed");
                deleteList(history);
                exit(0);
            }

        }
        else {

            pid = wait(&status);
        }
    }

    toHistory(command, pid, history);

}


void getUserInput(List* history){

    char buffer[100];
    char command[100];
    char *command_arr[100] = { };
    int command_arr_idx = 0;


    printf("$ ");
    fflush(stdout);
    scanf("%[^\n]", buffer);
    getchar();
    char* current_word = NULL;
    int i = 0;
    strcpy(command,buffer);
    current_word = strtok(buffer, " ");
    

    while (current_word) {  
        command_arr[i++] = current_word;
        command_arr_idx++;
        current_word = strtok(NULL, " ");   
    }

    options(buffer, command_arr, &command_arr_idx, command, history);
}


int addSystemVar(int argc, char *argv[]){

    char *path = getenv("PATH");
    unsigned long new_path_length = strlen(path); 
    int i;

    for(i=1; i < argc; i++){
        new_path_length += ( strlen(argv[i]) + 1 ); 
    }

    char new_path[new_path_length];   
    strcpy(new_path, path);

    for(i = 1; i < argc; i++){
        strcat(new_path, ":");
        strcat(new_path, argv[i]);
    }

    setenv("PATH", new_path, 1);
}

int main(int argc, char *argv[]) {



    addSystemVar(argc, argv);
    List *history;
	history = (List *) malloc(sizeof(List));
	initList(history);


    while (1)
    {
        getUserInput(history);
    }
      
    return 0;

}

