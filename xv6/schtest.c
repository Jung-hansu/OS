#include "types.h"
#include "user.h"

void child_test(int priority){
    int pid = fork();

    if (pid > 0){
        set_proc_priority(getpid(), 3);
        get_proc_priority(getpid());
    }
    else if (pid == 0){
        get_proc_priority(getpid());
        exit();
    }
    else{
        printf(2, "fork error\n");
        exit();
    }
    wait();
    exit();
}

void starvation_test(){
    int N, n, pid;
    N = 50;

    printf(1, "starvation test\n");

    for(n=0; n<N; n++){
        pid = fork();
        if(pid < 0)
            break;
        if(pid == 0){
            while(1){
                get_proc_priority(getpid());
                sleep(5);
            }
            exit();
        }
    }

    if(n == N){
        printf(1, "fork claimed to work N times!\n", N);
    }

    for(; n > 0; n--){
        if(wait() < 0){
            printf(1, "wait stopped early\n");
            exit();
        }
    }

    if(wait() != -1){
        printf(1, "wait got too many\n");
        exit();
    }

    printf(1, "starvation test OK\n");
    exit();
}

int main(){
    // child_test(6);
    starvation_test();

    return 0;
}