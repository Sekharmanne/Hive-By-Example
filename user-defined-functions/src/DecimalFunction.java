

import java.text.DecimalFormat;

import org.apache.hadoop.hive.ql.exec.UDF;
import org.apache.hadoop.io.Text;
/**
 * 
 * @author Bigdata Training 
 * This class is used as a User Defined Function in Hive.
 * This UDF will strip the Decimal value to the precision
 */
public class DecimalFunction extends UDF{
	
	private Text result = new Text();
	/**
	 * 
	 * @param value
	 * @param precision
	 * @return
	 * This method is used to strip the Decimal value to the precision mentioned
	 */
	public Text evaluate(String value, String precision){		
		double numberValue = Double.parseDouble(value);
		int numberPrecision = Integer.parseInt(precision);
		DecimalFormat df = new DecimalFormat("#.0000000");
		df.setMaximumFractionDigits(numberPrecision);
		result.set(df.format(numberValue));
		return result;
	}
	
}
