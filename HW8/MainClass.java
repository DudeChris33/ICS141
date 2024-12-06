import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Hashtable;

class Disk {    // extends Thread
    static final int NUM_SECTORS = 2048;
    static final int DISK_DELAY = 80;  // 80 for Gradescope
    
    StringBuffer sectors[] = new StringBuffer[NUM_SECTORS];
    
    Disk() {
        for (int i = 0; i < NUM_SECTORS; i++) {
            sectors[i] = new StringBuffer();
        }
    }

    void write(int sector, StringBuffer data) {
        try {
            Thread.sleep(DISK_DELAY);
            sectors[sector].delete(0, sectors[sector].length());
            sectors[sector].append(data);
            // System.out.println("writing: " + data);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    void read(int sector, StringBuffer data) {
        try {
            Thread.sleep(DISK_DELAY);
            data.delete(0, data.length());
            data.append(sectors[sector]);
            // System.out.println("reading: " + data);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class Printer { // extends Thread
    static final int PRINT_DELAY = 275; // 275 for Gradescope
    private int printerIndex;

    public Printer(int index) {
        this.printerIndex = index;
    }

    void print(StringBuffer data) {
        try {
            Thread.sleep(PRINT_DELAY);  // Simulate print delay
            String fileName = "PRINTER" + printerIndex; // Write data to the PRINTERi file
            try (PrintWriter writer = new PrintWriter(new FileWriter(fileName, true))) {
                System.out.println("printing: " + data);
                writer.println(data);
            } catch (IOException e) {
                e.printStackTrace();
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class PrintJobThread extends Thread {
    StringBuffer line = new StringBuffer(); // only allowed one line to reuse for read from disk and print to printer
    private DiskManager diskManager;
    private PrinterManager printerManager;
    private String fileName;

    public PrintJobThread(String fileToPrint, DiskManager diskManager, PrinterManager printerManager) {
        this.fileName = fileToPrint;
        this.diskManager = diskManager;
        this.printerManager = printerManager;
    }

    @Override
    public void run() {
        FileInfo fileInfo = diskManager.directoryManager.lookup(fileName);

        if (fileInfo != null) {
            int printerIndex = printerManager.request();   // Request access to the printer
            System.out.println("requesting printer " + printerIndex);

            int startingSector = fileInfo.startingSector;
            int fileLength = fileInfo.fileLength;

            for (int i = 0; i < fileLength; i++) {
                StringBuffer line = new StringBuffer();
                diskManager.read(fileInfo.diskNumber, startingSector + i, line);
                printerManager.print(printerIndex, line);
            }

            printerManager.release(printerIndex);
            System.out.println("releasing printer " + printerIndex);
        }
    }
}

class FileInfo {
    int diskNumber;
    int startingSector;
    int fileLength;

    public FileInfo(int diskNumber, int startingSector, int fileLength) {
        this.diskNumber = diskNumber;
        this.startingSector = startingSector;
        this.fileLength = fileLength;
    }
}

class DirectoryManager {
    private Hashtable<String, FileInfo> T = new Hashtable<String, FileInfo>();

    void enter(String fileName, FileInfo file) {
        T.put(fileName, file);
    }

    FileInfo lookup(String fileName) {
        return T.get(fileName);
    }
}

class ResourceManager {
    boolean isFree[];

    ResourceManager(int numItems) {
        isFree = new boolean[numItems];
        for (int i = 0; i < isFree.length; i++) {
            isFree[i] = true;
        }
    }

    synchronized int request() {
        while (true) {
            for (int i = 0; i < isFree.length; i++) {
                if (isFree[i]) {
                    isFree[i] = false;
                    return i;
                }
            }
            try {
                this.wait();    // block until someone releases Resource
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    synchronized void release(int index) {
        isFree[index] = true;
        this.notify();  // let a blocked thread run
    }
}

class DiskManager extends ResourceManager {
    DirectoryManager directoryManager;
    private int NUM_DISKS;
    private static final int NUM_SECTORS = Disk.NUM_SECTORS;

    int nextFreeSector[];
    private Disk disks[];

    public DiskManager(int numDisks, DirectoryManager directoryManager) {
        super(numDisks);
        this.NUM_DISKS = numDisks;
        this.directoryManager = directoryManager;

        disks = new Disk[NUM_DISKS];
        for (int i = 0; i < NUM_DISKS; i++) {
            disks[i] = new Disk();
        }
        
        nextFreeSector = new int[NUM_DISKS];
        for (int i = 0; i < NUM_DISKS; i++) {
            nextFreeSector[i] = 0;
        }
    }
    
    synchronized int getNextFreeSector(int diskNumber) {
        int sector = nextFreeSector[diskNumber];
        nextFreeSector[diskNumber]++;
        return sector;
    }

    synchronized void write(int diskNumber, int sector, StringBuffer data) {
        disks[diskNumber].write(sector, data);
    }

    synchronized void read(int diskNumber, int sector, StringBuffer data) {
        disks[diskNumber].read(sector, data);
    }
}

class PrinterManager extends ResourceManager {
    private int NUM_PRINTERS;
    private Printer printers[];

    public PrinterManager(int numPrinters) {
        super(numPrinters);
        NUM_PRINTERS = numPrinters;
        printers = new Printer[NUM_PRINTERS];
        for (int i = 0; i < NUM_PRINTERS; i++) {
            printers[i] = new Printer(i);
        }
    }

    synchronized void print(int printerNumber, StringBuffer data) {
        printers[printerNumber].print(data);
    }
}

class UserThread extends Thread {
    private int userID;
    private DiskManager diskManager;
    private PrinterManager printerManager;
    private DirectoryManager directoryManager;

    public UserThread(int userID, DiskManager diskManager, PrinterManager printerManager, DirectoryManager directoryManager) {
        this.userID = userID;
        this.diskManager = diskManager;
        this.printerManager = printerManager;
        this.directoryManager = directoryManager;
    }

    StringBuffer copy_StringBuffer(StringBuffer input) {
        String strInput = input.toString();
        StringBuffer output = new StringBuffer(strInput);
        return output;
    }

    @Override
    public void run() {
        String fileName = "USER" + userID;
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName))) {
            String line;
            StringBuffer dataToSave = new StringBuffer();
            
            while ((line = reader.readLine()) != null) {
                if (line.startsWith(".save")) { // Start of a save command
                    dataToSave.delete(0, dataToSave.length());  // Clear previous data
                    String saveFileName = line.replace(".save", "").trim();
                    // System.out.println("saveFileName: " + saveFileName);
                    while (!(line = reader.readLine()).startsWith(".end")) {
                        dataToSave.append(line.trim()).append("\n");    // .replace(saveFileName, "")
                        // System.out.println("saving: " + line.trim());
                    }
                    
                    int diskIndex = diskManager.request();
                    // System.out.println("requesting disk " + diskIndex);
                    int startingSector = diskManager.getNextFreeSector(diskIndex);
                    // System.out.println("startingSector: " + startingSector);
                    String temp[] = copy_StringBuffer(dataToSave).toString().split("\n");
                    StringBuffer dataToSaveList[] = new StringBuffer[temp.length];
                    for (int i = 0; i < temp.length; i++) {
                        dataToSaveList[i] = new StringBuffer(temp[i]);
                    }
                    directoryManager.enter(saveFileName, new FileInfo(diskIndex, startingSector, dataToSaveList.length));
                    diskManager.write(diskIndex, startingSector, dataToSaveList[0]);
                    for (int i = 1; i < dataToSaveList.length; i++) {
                        diskManager.write(diskIndex, diskManager.getNextFreeSector(diskIndex), dataToSaveList[i]);
                    }
                    diskManager.release(diskIndex);
                    // System.out.println("releasing disk " + diskIndex);
                } else if (line.startsWith(".print")) { // Start of a print command
                    String printFileName = line.replace(".print", "").trim();
                    if (directoryManager.lookup(printFileName) != null) {
                        PrintJobThread printJobThread = new PrintJobThread(printFileName, diskManager, printerManager);  // Create and start a PrintJobThread
                        printJobThread.start();
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}


public class MainClass {
    public static void main(String[] args) {
        if (args.length < 3) {
            System.out.println("Usage: java -jar 141OS.jar -#ofUsers -#ofDisks -#ofPrinters");
            System.exit(1);
        }

        int numberOfUsers = -1 * Integer.parseInt(args[0]);
        int numberOfDisks = -1 * Integer.parseInt(args[1]);
        int numberOfPrinters = -1 * Integer.parseInt(args[2]);

        DirectoryManager directoryManager = new DirectoryManager();
        DiskManager diskManager = new DiskManager(numberOfDisks, directoryManager);
        PrinterManager printerManager = new PrinterManager(numberOfPrinters);

        UserThread userThread = new UserThread(0, diskManager, printerManager, directoryManager);
        userThread.start();

        try {
            userThread.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}
