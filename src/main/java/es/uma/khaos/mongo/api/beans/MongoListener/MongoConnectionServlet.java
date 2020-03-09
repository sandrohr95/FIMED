package es.uma.khaos.mongo.api.beans.MongoListener;


import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class MongoConnectionServlet implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce)  {
        MongoConnection conn = MongoConnection.getInstance();
        conn.init();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        MongoConnection conn = MongoConnection.getInstance();
        conn.close();
    }

}
