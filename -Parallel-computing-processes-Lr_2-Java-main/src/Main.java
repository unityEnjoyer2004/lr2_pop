

public class Main {

    private static volatile int min = Integer.MAX_VALUE;

    public static void main(String[] args) {
        ArrayManager arrayManager = new ArrayManager(1000, 10);
        arrayManager.generateArray();
        long startTime = System.nanoTime();
        arrayManager.findMin();
        long endTime = System.nanoTime();
        double duration = (endTime - startTime) / 1e6; 
        System.out.println("Час виконання: " + duration + " мс");
        arrayManager.findMin();
        System.out.println("Мінімальний елемент масиву: " + min);
        System.out.println("Індекс мінімального елементу: " + arrayManager.findIndex(min));
    }

    public static synchronized void updateMin(int localMin) {
        if (localMin < min) {
            min = localMin;
        }
    }
}
