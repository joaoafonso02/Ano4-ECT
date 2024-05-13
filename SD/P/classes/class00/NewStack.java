public class NewStack<T> {
    private Node<T> top;

    public void push(T elem) {
        Node<T> newNode = new Node<>(elem);
        newNode.next = top;
        top = newNode;
    }

    public T pop() {
        if(isEmpty()) {
            throw new IllegalStateException("Stack empty");
        }
        T elem = top.elem;
        top = top.next;
        return elem;
    }

    public boolean isEmpty() {
        return top == null;
    }
    
    private static class Node<T> {
        private T elem;
        private Node<T> next;

        public Node(T elem) {
            this.elem = elem;
        }
    }
}
