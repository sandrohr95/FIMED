package es.uma.khaos.mongo.api.beans.MongoListener;

import static java.lang.String.format;

import com.mongodb.*;
import org.apache.log4j.Logger;

import java.io.IOException;
import java.util.Arrays;
import java.util.Properties;
import java.util.concurrent.SynchronousQueue;

public class MongoConnection {

    private static Logger logger = Logger.getLogger(MongoConnection.class);
    private static MongoConnection instance = new MongoConnection();

    private MongoClient mongo = null;

    private MongoConnection() {
    }

    public MongoClient getMongo() throws RuntimeException {
        if (mongo == null) {
            logger.debug("Starting Mongo");
            System.out.println("Starting Mongo");
            MongoClientOptions.Builder options = MongoClientOptions.builder()
                    .connectionsPerHost(4)
                    .maxConnectionIdleTime((60 * 1_000))
                    .maxConnectionLifeTime((120 * 1_000));

            try {
                Properties props = new Properties();
                props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
                String hostname = props.getProperty("mongodb.hostname");
                String port = props.getProperty("mongodb.port");
                String auth_user = props.getProperty("mongodb.user");
                String auth_pwd = props.getProperty("mongodb.password");
                String dbname = props.getProperty("mongodb.admin");

                /* If we want to connect to our server with credentials */
                MongoCredential credential = MongoCredential.createCredential(auth_user, dbname, auth_pwd.toCharArray());

                /* Connection to Localhost */
                String client_url = "mongodb://" + hostname + ":" + port + "/"+ dbname;

//                MongoClientURI uri = new MongoClientURI(client_url, options);

                try {
                    /* If we want to connect to our server with credentials */
                    mongo = new MongoClient(new ServerAddress(hostname), Arrays.asList(credential));

                    /* Connection to Localhost */
//                    mongo = new MongoClient(uri);
                    mongo.setWriteConcern(WriteConcern.ACKNOWLEDGED);

                } catch (Exception ex) {
                    System.out.println("An error occoured when connecting to MongoDB");

                    logger.error("An error occoured when connecting to MongoDB", ex);
                }


                // To be able to wait for confirmation after writing on the DB
                mongo.setWriteConcern(WriteConcern.ACKNOWLEDGED);
            }catch (Exception e)
            {
                e.printStackTrace();
            }
        }

        return mongo;
    }

    public void init(){
        logger.debug("Bootstraping");
        System.out.println("Bootstraping");

        getMongo();

    }

    public void close() {
        System.out.println("Cerrando Mongo");
        logger.info("Closing MongoDB connection");
        if (mongo != null) {
            try {
                mongo.close();
                System.out.println("Nulling the connection dependency objects");
                logger.debug("Nulling the connection dependency objects");
                mongo = null;
            } catch (Exception e) {
                logger.error(format("An error occurred when closing the MongoDB connection\n%s", e.getMessage()));
            }
        } else {
            logger.warn("mongo object was null, wouldn't close connection");
        }
    }

    public static MongoConnection getInstance() {
        return instance;
    }
}
