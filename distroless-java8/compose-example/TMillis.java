import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public class TMillis {
    public static void main(String[] args) {
	Calendar calendar = Calendar.getInstance();
	DateFormat dateFormat = new SimpleDateFormat("yyyy-mm-dd hh:mm:ss");
	
	for (;;) {
	    long timeStamp = System.currentTimeMillis();
	    calendar.setTimeInMillis(timeStamp);
		    
	    Date now = calendar.getTime();
	    String strNow = dateFormat.format(now);  
		    
	    System.out.println("Millis: " + timeStamp + "; Date: " + strNow);
		    
	
	    try {
		Thread.sleep(1000, 0);	//sleep for 1000 ms
	    } catch (InterruptedException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	    }
	}
    }
}
