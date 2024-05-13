import java.util.LinkedList;
import java.util.Queue;
import java.util.Scanner;

public class Palindrome {
    
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);

        while(true) {
            System.out.print("string: ");
            String string = sc.nextLine();

            if(isPalindrome(string)) {
                System.out.println(string + " is Palindrome");
            } 
            else {
                System.out.println(string+ "is NOT Palindrome");
            }
        }       
    }

    public static boolean isPalindrome(String string) {
        Queue<Character> queue = new LinkedList<>();
        NewFifo<Character> fifao = new NewFifo<>();
        NewStack<Character> customStack = new NewStack<>();

        for (char ch : string.toCharArray()) {
            fifao.add(ch);
            customStack.push(ch);
        }

        while (!fifao.isEmpty() && !customStack.isEmpty()) {
            if (!fifao.poll().equals(customStack.pop())) { // if not equal
                return false;
            }
        }
        return true;
    }
}