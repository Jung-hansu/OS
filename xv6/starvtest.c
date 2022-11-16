#include "types.h"
#include "user.h"
#define N 50

void starvation_test(){
    int n, pid;

    printf(1, "starvation test\n");
    sleep(70);
    for(n=0; n<N; n++){
        pid = fork();
        if (n > 5) set_proc_priority(getpid(), 3);
        if(pid < 0) break;
        if(pid == 0)
            while(1){
                get_proc_cnt(getpid());
                sleep(10);
            }
    }
    wait();
}

int main(){
    starvation_test();
}