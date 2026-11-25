
struct stack* stack_create() {
    struct stack* stk = (struct stack*)malloc(sizeof(struct stack));
    if (stk == NULL) {
        printf("failed to malloc a stack");
        exit(1);
    }
    stk->capacity = 100;
    stk->top = -1;
    void** arr = (void**)malloc(sizeof(void*) * 100);
    if (arr == NULL) {
        printf("failed to malloc stack array");
        free(stk);
        exit(1);
    }
    stk->items = arr;
    return stk;
}

// capacity = 400 + 10
//
// top = 399
// stack_push

void stack_push(stack* stk, void* item) {
    if (stk->top + 1 >= stk->capacity) {
        void** new_arr = realloc(stk->items, sizeof(void*) * (stk->capacity + 10));
        if (new_arr == NULL) {
            printf("Reallocation failed");
            exit(1);
        }
        stk->items = new_arr;
        stk->capacity = stk->capacity + 10;
    }
    stk->items[++stk->top] = item;
}

//   top = 1
//
//   2
//   1
//   7 <- items

void* stack_pop(stack* stk) {
    if (stk->top < 0) return NULL;
    void* elem = stk->items[stk->top--];
    return elem;
}
size_t stack_size(stack* stk) { return (size_t)(stk->top + 1); }
// # of items on stack
void* stack_item(size_t position) {
    if (position > top) {
        printf("Stack indexing error.");
        return NULL;
    }
    return stk->items[position];
}
/* Returns a pointer to the item at the specified
position, without removing it from the stack.
0 indicates the bottom of stack;
stack_size()-1 indicates the top of stack */
