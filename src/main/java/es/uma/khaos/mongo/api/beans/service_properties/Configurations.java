package es.uma.khaos.mongo.api.beans.service_properties;

import java.util.ArrayList;
import java.util.List;
import java.util.Properties;
import java.util.StringTokenizer;

/** Class to get properties from properties file */
public final class Configurations {

	private Properties properties = null;
	private static Configurations instance = null;
	
	/** Make the constructor private so that this class cannot be instantiated */
	private Configurations (){
		this.properties = new Properties();
		try{
			// File path (we get path of the current thread plus the filename
			properties.load(Thread.currentThread().getContextClassLoader().getResourceAsStream(Constants.PATH_MELANOMA_PROPERTIES));
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}	
	
	/** Creates the instance is synchronized to avoid multithreads problems */
	private synchronized static void createInstance () {
        if (instance == null) { 
        	instance = new Configurations ();
        }
    }
	
	/** Get the properties instance. Uses singleton pattern */
	public static String getProperty(String key){
		String result = null;		
		// Uses singleton pattern to guarantee the creation of only one instance
		if(instance == null) {
			createInstance();
		}	
		// Once is created or if already exists we use the instance to get the property
		if(key !=null && !key.trim().isEmpty()){
			result = instance.properties.getProperty(key);
		}
		return result;
	}
	
	/** Get a list of properties */
	public static List<String> getListProperties(String key){
		if(instance == null) {
			createInstance();
		}
		List<String> result = null;
		if(key!=null  && !key.trim().isEmpty()){
			String aux = instance.properties.getProperty(key);
			if(aux!=null && !aux.trim().isEmpty()){
				StringTokenizer st = new StringTokenizer(aux, ",");
				if(st!=null){
					result = new ArrayList<String>();
					while(st.hasMoreTokens()){
						result.add(st.nextToken());
					}
				}
			}
		}
		return result;
	}
	
	/** Override the clone method to ensure the "unique instance" requeriment of this class */
	public Object clone() throws CloneNotSupportedException {
    	throw new CloneNotSupportedException();
	}
}
