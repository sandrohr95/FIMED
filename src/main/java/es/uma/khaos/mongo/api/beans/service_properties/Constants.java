package es.uma.khaos.mongo.api.beans.service_properties;

public class Constants {
	
	//PATH
	public static final String PATH_MELANOMA_PROPERTIES = "mongoDB.properties";
	
	//MongoDB
	public static final String MONGO_SERVER = Configurations.getProperty(Properties.MONGO_SERVER);
	public static final String MONGO_PORT = Configurations.getProperty(Properties.MONGO_PORT);

	//FILE PATH
	public static final String UPLOAD_LOCATION_FOLDER = Configurations.getProperty(Properties.UPLOAD_LOCATION_FOLDER);	
	public static final String FILE_FOLDER = Configurations.getProperty(Properties.FILE_FOLDER);	

}
