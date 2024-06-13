class MinFinder extends Thread {
    private final int startIndex;
    private final int endIndex;
    private final int[] arr;
    private final ArrayManager arrayManager;

    public MinFinder(int startIndex, int endIndex, int[] arr, ArrayManager arrayManager) {
        this.startIndex = startIndex;
        this.endIndex = endIndex;
        this.arr = arr;
        this.arrayManager = arrayManager;
    }

    @Override
    public void run() {
        int localMin = Integer.MAX_VALUE;
        for (int i = startIndex; i < endIndex; i++) {
            if (arr[i] < localMin) {
                localMin = arr[i];
            }
        }
        Main.updateMin(localMin);
        arrayManager.threadFinished();
    }
}