main:
    movq $2, %rdi                     # first argument, x
    call fact
    # ret                             # exit program
fact:
    pushq %rbp                         # save the base pointer
    movq  %rsp, %rbp                 # set new base pointer
    subq  $16, %rsp                 # save space for 2 
    pushq %rbx                         # save callee-saved registers
    pushq %r12
    pushq %r13
    pushq %r14
    pushq %r15

    movq %rdi, -8(%rbp)
    movq $1, -16(%rbp)
    
facthelper_loop:
    movq -8(%rbp), %r15
    cmp $0x0, %r15                    # if (n === 0) goto facthelper_done;
    je facthelper_loop_done
    movq -8(%rbp), %r14
    subq $1, %r14                    # %r14 = n - 1
    movq -16(%rbp), %r15
    movq -8(%rbp), %r13
    imulq %r13, %r15                  # r15 = n * a
    movq %r14, -8(%rbp)                # first argument, n
    movq %r15, -16(%rbp)            # second argument, a
    jmp facthelper_loop                # boils down to facthelper(n-1, n*a)

facthelper_loop_done:
    movq -16(%rbp), %rax            # return a;
    popq %r15                         # restore callee-saved registers
    popq %r14
    popq %r13
    popq %r12
    popq %rbx
    movq %rbp, %rsp                 # reset stack pointer
    popq %rbp                         # recover previous base pointer
    ret                             # return to the caller
