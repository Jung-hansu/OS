###### hw1 ######
- hello.c
printf를 사용하여 표준 출력으로 "Hello World\n"를 출력하는 프로그램

-Makefile
UPROGS부분에 hello.c 추가


###### hw2 ######
- forknexectest.c
시스템 콜 forknexec를 테스트하는 프로그램

- Makefile
UPROGS부분에 forknexectest.c 추가

- syscall.c
sys_forknexec 래핑함수 extern 및 system call 추가

- syscall.h
SYS_forknexec를 22로 정의

- defs.h
forknexec 함수 원형 추가

- user.h
forknexec 함수 원형 추가

- usys.S
forknexec 시스템 콜 매크로 추가

- sysproc.c
sys_forknexec 함수 선언 및 정의

- proc.c
forknexec 함수 선언 및 정의


###### hw3 ######
- starvtest.c
fork와 무한루프를 이용해 스케줄링상에 starvation 여부를 관찰하는 프로그램

- Makefile
UPROGS 부분에 starvtest.c 추가

- syscall.c
sys_set_proc_priority, sys_get_proc_priority, sys_get_proc_cnt 함수를 extern하고 syscall 변수로 추가

- syscall.h
SYS_set_proc_priority, SYS_get_proc_priority, SYS_get_proc_cnt 값 추가

- defs.h
proc.c 부분에 set_proc_priority, get_proc_priority, get_proc_cnt 함수 추가

- user.h
proc.c 부분에 set_proc_priority, get_proc_priority, get_proc_cnt 함수 추가

- usys.S
set_proc_priority, get_proc_priority, get_proc_cnt 시스템콜 추가

- sysproc.c
sys_set_proc_priority, sys_get_proc_priority, sys_get_proc_cnt 함수 추가

- proc.c
allocproc(), fork(), scheduler()함수에 프로세스 priority 기능 추가 및 set_proc_priority, get_proc_priority, get_proc_cnt 함수 원형 추가

- proc.h
proc 구조체에 priority, cnt 변수 추가


##### hw4 #####
- cowtest.c
fork와 getNumFreePages 시스템콜을 사용해 copy on write를 테스트하는 코드

- Makefile
UPROG부분에 cowtest 추가

- mmu.h
PGSHIFT 전역상수를 12로 설정

- syscall.c
sys_getNumFreePages 함수 extern

- syscall.h
SYS_getNumFreePages 시스템콜 번호 정의

- defs.h
 kalloc.c의 get/inc/dec_refcount 함수와 getNumFreePages 시스템콜 함수 추가
 vm.c의 pagefault함수 추가

- user.h
system call부분에 getNumFreePages함수 추가

- usys.S
getNumFreePages 시스템콜 추가

- sysproc.c
sys_getNumFreePages함수 정의

- vm.c
 copyuvm 함수에서 자식프로세스의 메모리를 kalloc하여 할당하는 부분을 삭제하고 write권한을 빼는 연산과 참조카운트 증가 연산도 추가
 pagefault를 처리하는 pagefault함수 추가


- trap.c
trap함수에 pagefault 발생시 pagefault() 함수를 호출하여 처리하는 구문 추가

- kalloc.c
num_free_pages, pgrefcount[] 선언
get_refcount(uint pa), inc_refcount(uint pa), dec_refcount(uint pa) 함수 정의
getNumFreePages 함수 정의
kinit1 함수에서 num_free_pages 변수를 0으로 초기화
freerange 함수에서 free할 page의 pgrefcount값을 0으로 초기화
kfree 함수에서 참조 페이지가 존재하면 refcount값을 줄이고, 존재하지 않으면 free pages의 수를 증가