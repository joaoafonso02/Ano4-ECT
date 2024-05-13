package class01; 
import java.util.LinkedList;

/**
 * General description:
 * the class will create a Stack with a LinkedList.
 *
 * @author João Afonso Ferreira
 * @version 1.0 - 22/02/2024
 */
public class Stack {
    // Create a Stack with a LinkedList
    private LinkedList<Integer> stack = new LinkedList<Integer>();

    /**
     * General description:
     * the method will add an integer to the end of the Stack.
     * @param i
     */
    // Push an integer onto the stack
    public void push(int i) {
        stack.push(i);
    }

    /**
     * General description:
     * the method will remove an integer from the beginning of the Stack.
     * @return
     */
    // Pop an integer off the stack
    public int pop() {
        return stack.pop();
    }

    /**
     * General description:
     * the method will return if the Stack is empty.
     * @return
     */
    public int size() {
        return stack.size();
    }

    /**
     * General description:
     * the method will return the integer at the given index.
     * @param i
     * @return
     */
    public int get(int i) {
        return stack.get(i);
    }
}