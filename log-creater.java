import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

public class TestLogWriter {
    private static final String LOG_FILE_PATH = "/var/log/test.log";
    private static final DateTimeFormatter DATE_TIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    public static void main(String[] args) throws IOException, InterruptedException {
        File logFile = new File(LOG_FILE_PATH);
        if (!logFile.exists()) {
            logFile.createNewFile();
        }
        while (true) {
            LocalDateTime now = LocalDateTime.now();
            String logLine = now.format(DATE_TIME_FORMATTER) + " - Test log message";
            BufferedWriter writer = new BufferedWriter(new FileWriter(logFile, true));
            writer.write(logLine);
            writer.newLine();
            writer.close();
            Thread.sleep(60 * 1000); // sleep for 1 minute
        }
    }
}
