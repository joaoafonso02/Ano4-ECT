public class NewFifo<T> {
    private Node<T> top;
    private Node<T> bottom;

    public void add(T elem) {
        Node<T> newNode = new Node<>(elem);
        if (bottom != null) {
            bottom.next = newNode;
        }
        bottom = newNode;
        if (top == null) {
            top = bottom;
        }
    }

    public T poll() {
        if (isEmpty()) {
            throw new IllegalStateException("Fifo empty");
        }
        T elem = top.elem;
        top = top.next;
        if (top == null) {
            bottom = null;
        }
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