import java.io.FileReader;
import java.io.FileWriter;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Hashtable;

class Disk {    // extends Thread
    static final int NUM_SECTORS = 2048;
    static final int DISK_DELAY = 8;  // 80 for Gradescope
    
    StringBuffer sectors[] = new StringBuffer[NUM_SECTORS];
    
    Disk() {
        for (int i = 0; i < NUM_SECTORS; i++) {
            sectors[i] = new StringBuffer();
        }
    }

    void write(int sector, StringBuffer data) {
        try {
            Thread.sleep(DISK_DELAY);
            sectors[sector].setLength(0);
            sectors[sector].append(data);
            // System.out.println("writing: " + data);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    void read(int sector, StringBuffer data) {
        try {
            Thread.sleep(DISK_DELAY);
            data.setLength(0);
            data.append(sectors[sector]);
            // System.out.println("reading: " + data);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
}

class Printer { // extends Thread
    static final int PRINT_DELAY = 27; // 275 for Gradescope
    private int printerIndex;

    public Printer(int index) {
        this.printerIndex = index;
        try(BufferedWriter writer = new BufferedWriter(new FileWriter("PRINTER" + printerIndex, true))) {
            writer.close();
        } catch(IOException e) {
            e.printStackTrace();
        }
    }

    void print(StringBuffer data) {
        try {
            Thread.sleep(PRINT_DELAY);  // Simulate print delay
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        try(BufferedWriter writer = new BufferedWriter(new FileWriter("PRINTER" + printerIndex, true))) {
            writer.write(data.toString());
            writer.newLine();
            writer.flush();
            // System.out.println("printing: " + data);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}

class PrintJobThread extends Thread {
    StringBuffer line = new StringBuffer(); // only allowed one line to reuse for read from disk and print to printer
    private StringBuffer fileName;
    private DiskManager diskManager;
    private PrinterManager printerManager;

    public PrintJobThread(StringBuffer fileName, DiskManager diskManager, PrinterManager printerManager) {
        this.fileName = fileName;
        this.diskManager = diskManager;
        this.printerManager = printerManager;
    }

    @Override
    public void run() {
        FileInfo fileInfo = diskManager.directoryManager.lookup(fileName);

        if (fileInfo != null) {
            int printerIndex = printerManager.request();   // Request access to the printer
            // System.out.println("requesting printer " + printerIndex);

            int diskNumber = fileInfo.diskNumber;
            int startingSector = fileInfo.startingSector;
            int fileLength = fileInfo.fileLength;

            for (int i = 0; i < fileLength; i++) {
                line = new StringBuffer();
                diskManager.read(diskNumber, startingSector + i, line);
                printerManager.print(printerIndex, line);
            }

            printerManager.release(printerIndex);
            // System.out.println("releasing printer " + printerIndex);
        }
    }
}

class FileInfo {    // given
    int diskNumber;
    int startingSector;
    int fileLength;

    public FileInfo(int diskNumber, int startingSector, int fileLength) {
        this.diskNumber = diskNumber;
        this.startingSector = startingSector;
        this.fileLength = fileLength;
    }
}

class DirectoryManager {    // given
    private Hashtable<String, FileInfo> T = new Hashtable<String, FileInfo>();

    void enter(StringBuffer fileName, FileInfo file) {
        T.put(fileName.toString(), file);
    }

    FileInfo lookup(StringBuffer fileName) {
        return T.get(fileName.toString());
    }
}

class ResourceManager { // given
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
        return nextFreeSector[diskNumber];
    }

    synchronized void write(int diskNumber, int sector, StringBuffer data) {
        nextFreeSector[diskNumber]++;
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

    public UserThread(int userID, DiskManager diskManager, PrinterManager printerManager) {
        this.userID = userID;
        this.diskManager = diskManager;
        this.printerManager = printerManager;
    }

    @Override
    public void run() {
        StringBuffer fileName = new StringBuffer("USER" + userID);
        try (BufferedReader reader = new BufferedReader(new FileReader(fileName.toString()))) {
            String line;
            
            while ((line = reader.readLine()) != null) {
                if (line.startsWith(".save")) { // Start of a save command
                    StringBuffer saveFileName = new StringBuffer(line.replace(".save", "").trim());
                    // System.out.println("saveFileName: " + saveFileName);
                    int diskIndex = diskManager.request();
                    // System.out.println("requesting disk " + diskIndex);
                    int startingSector = diskManager.getNextFreeSector(diskIndex);
                    // System.out.println("startingSector: " + startingSector);
                    int fileLength = 0;
                    
                    while (!(line = reader.readLine()).startsWith(".end")) {
                        StringBuffer dataToSave = new StringBuffer(line);
                        diskManager.write(diskIndex, diskManager.getNextFreeSector(diskIndex), dataToSave);
                        fileLength++;
                        // System.out.println("saving: " + dataToSave);
                    }
                    diskManager.directoryManager.enter(saveFileName, new FileInfo(diskIndex, startingSector, fileLength));

                    diskManager.release(diskIndex);
                    // System.out.println("releasing disk " + diskIndex);
                } else if (line.startsWith(".print")) { // Start of a print command
                    StringBuffer printFileName = new StringBuffer(line.replace(".print", "").trim());
                    if (diskManager.directoryManager.lookup(printFileName) != null) {
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
    UserThread[] users;

    int numberOfUsers;
    int numberOfDisks;
    int numberOfPrinters;

    DirectoryManager directoryManager;
    DiskManager diskManager;
    PrinterManager printerManager;

    public static MainClass instance;

    MainClass(String[] args) {
        if (args.length < 3) {
            System.out.println("Usage: java -jar 141OS.jar -#ofUsers -#ofDisks -#ofPrinters");
            System.exit(1);
        }

        this.numberOfUsers = -1 * Integer.parseInt(args[0]);
        this.numberOfDisks = -1 * Integer.parseInt(args[1]);
        this.numberOfPrinters = -1 * Integer.parseInt(args[2]);

        this.users = new UserThread[numberOfUsers];
        this.directoryManager = new DirectoryManager();
        this.diskManager = new DiskManager(numberOfDisks, directoryManager);
        this.printerManager = new PrinterManager(numberOfPrinters);

        for (int i = 0; i < numberOfUsers; i++) {
            UserThread user = new UserThread(i, diskManager, printerManager);
            users[i] = user;
        }
    }

    //singleton instance as we only want 1 running at a time
    public static MainClass instance(String[] args) {
        if(instance == null) {
            instance = new MainClass(args);
        }
        return instance;
    }

    public void StartThreads() {
        for (int i = 0; i < numberOfUsers; i++) {
            users[i].start();
        }
    }

    public void JoinThreads() {
        for (int i = 0; i < numberOfUsers; i++) {
            try {
                users[i].join();
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }

    public static void main(String[] args) {
        MainClass os = MainClass.instance(args);
        os.StartThreads();
        os.JoinThreads();
    }
}
