import java.util.Random;
class ArrayManager {
    private int[] arr;
    private final int arraySize;
    private final int threadCount;
    private int finishedThreads;

    public ArrayManager(int arraySize, int threadCount) {
        this.arraySize = arraySize;
        this.threadCount = threadCount;
        arr = new int[arraySize];
    }

    public void generateArray() {
        Random random = new Random();
        for (int i = 0; i < arraySize; i++) {
            arr[i] = random.nextInt(1000);
        }
        int negativeElement = random.nextInt(arraySize);
        arr[negativeElement] = -1 * random.nextInt(1000);
    }

    public void findMin() {
        MinFinder[] threads = new MinFinder[threadCount];
        for (int i = 0; i < threads.length; i++) {
            threads[i] = new MinFinder(i * (arraySize / threadCount),
                    (i + 1) * (arraySize / threadCount), arr, this);
            threads[i].start();
        }
        synchronized (this) {
            try {
                wait();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public synchronized void threadFinished() {
        finishedThreads++;
        if (finishedThreads == threadCount) {
            notify();
        }
    }

    public int findIndex(int value) {
        for (int i = 0; i < arraySize; i++) {
            if (arr[i] == value) {
                return i;
            }
        }
        int minNegative = Integer.MAX_VALUE;
        int index = -1;
        for (int i = 0; i < arraySize; i++) {
            if (arr[i] < minNegative) {
                minNegative = arr[i];
                index = i;
            }
        }
        return index;
    }

}