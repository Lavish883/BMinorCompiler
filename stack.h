
stack* stack_create();
// arbitrary capacity
void stack_push(stack* stk, void* item);
void* stack_pop(stack* stk);
size_t stack_size(stack* stk);
// # of items on stack
void* stack_item(size_t position);
/* Returns a pointer to the item at the specified
position, without removing it from the stack.
0 indicates the bottom of stack;
stack_size()-1 indicates the top of stack */
