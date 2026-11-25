struct stack {
    void** items;
    int capacity;
    int top;
};

struct stack* stack_create();
// arbitrary capacity
void stack_push(struct stack* stk, void* item);
void* stack_pop(struct stack* stk);
size_t stack_size(struct stack* stk);
// # of items on stack
void* stack_item(size_t position);
/* Returns a pointer to the item at the specified
position, without removing it from the stack.
0 indicates the bottom of stack;
stack_size()-1 indicates the top of stack */
