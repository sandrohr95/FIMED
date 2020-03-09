package es.uma.khaos.mongo.api.beans.service;

import com.mongodb.*;

import es.uma.khaos.mongo.api.beans.model.Analysis;
import es.uma.khaos.mongo.api.beans.model.Paciente;
import es.uma.khaos.mongo.api.beans.model.User;
import es.uma.khaos.mongo.api.beans.converter.*;

import org.bson.types.ObjectId;

import java.io.IOException;
import java.util.*;

import es.uma.khaos.mongo.api.beans.MongoListener.MongoConnection;

public class Database {
    private static String dbname = "FIMED";
    private static  String collection_name = "Clinicians";
    public static String name = "Name";
    public static String surname = "Surname";
    public static String email = "Email";
    public static String username = "Username";
    public static String password = "Password";
    public static String encrypt_key = "EncryptKey";
    public static String patients = "Patients";
    public static String form = "Form";
    public static String analysis = "Analysis";
    public static String metadata = "metadata";

    public static MongoClient DatabaseConnection(){
        return MongoConnection.getInstance().getMongo();
    }

    public User searchUserDb(String loginId, String loginPwd){

        User user = new User();
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        //primero busco el username, y miro la password y el salt y verifico que coinciden
        BasicDBObject query = new BasicDBObject(username, loginId);
        DBObject u = collection.findOne(query);

        if (u != null) {
            String salt = (String) u.get(encrypt_key);
            String pass = (String) u.get(password);

            Encrypt encrypt = new Encrypt();
            boolean passwordMatch = encrypt.verifyUserPassword(loginPwd, pass, salt);

            if (passwordMatch) {
                System.out.println("Provided user password " + loginPwd + " is correct.");
                List obj = new ArrayList();
                obj.add(new BasicDBObject(username, loginId));
                obj.add(new BasicDBObject(password, pass));
                BasicDBObject whereQuery = new BasicDBObject();
                whereQuery.put("$and", obj);
                DBCursor cursor = collection.find(whereQuery);

                try {
                    while (cursor.hasNext()) {
                        DBObject doc = cursor.next();
                        System.out.println(doc);
                        user.setId(doc.get("_id").toString());
                        user.setName(doc.get(name).toString());
                        user.setSurname(doc.get(surname).toString());
                        user.setEmail(doc.get(email).toString());
                        user.setUserName(doc.get(username).toString());
                        user.setPassword(doc.get(password).toString());
                    }

                } finally {
                    cursor.close();
                }

            } else {
                System.out.println("Provided password is incorrect");
            }
        }

        return user;
    }

    public static User searchUserDbById(String id){
        User user = new User();
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);
        DBCursor cursor = null;
        BasicDBObject query = (new BasicDBObject("_id", new ObjectId(id)));
        cursor = collection.find(query);

        try {

            while (cursor.hasNext()) {

                DBObject doc = cursor.next();
                user.setId(doc.get("_id").toString());
                user.setName(doc.get(name).toString());
                user.setSurname(doc.get(surname).toString());
                user.setEmail(doc.get(email).toString());
                user.setUserName(doc.get(username).toString());
                user.setPassword(doc.get(password).toString());
                BasicDBList pacientesMongoDb = (BasicDBList) doc.get(patients);

                if (pacientesMongoDb.isEmpty()) {

                    ArrayList<Paciente> pacientes = new ArrayList<Paciente>();

                    for (Object pacienteMongoDb : pacientesMongoDb) {
                        pacientes.add((Paciente) pacienteMongoDb);
                    }
                    user.setPatientList(pacientes);
                }
            }

        } finally {
            cursor.close();
        }
        return user;
    }


    public static boolean searchID(String id) {
        boolean findId = false;
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);
        DBCursor cursor = null;

        try {
            BasicDBObject query = (new BasicDBObject("_id", new ObjectId(id)));
            cursor = collection.find(query);

            while (cursor.hasNext()) {
                DBObject doc = cursor.next();
                System.out.println("El ID coincidente es: " + doc);
                findId = true;

            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return findId;

    }

    // Método para comprobar que se correspone el usario y la contraseña en el
    // login
    public static boolean searchUserInDb(String loginId, String loginPwd){
        boolean user_found = false;

        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        // Get the particular record from the mongodb collection
        List obj = new ArrayList();
        obj.add(new BasicDBObject(username, loginId));
        obj.add(new BasicDBObject(password, loginPwd));
        // Form a where query
        BasicDBObject whereQuery = new BasicDBObject();
        whereQuery.put("$and", obj);
        System.out.println("Sql query is= " + whereQuery.toString());
        DBCursor cursor = collection.find(whereQuery);

        try {
            while (cursor.hasNext()) {
                DBObject doc = cursor.next();
                System.out.println("Found= " + doc);
                user_found = true;
            }
        } finally {
            cursor.close();
        }

        return user_found;
    }

    // Método para que no se repitan los Usernames
    public static boolean searchUsername(String username){
        boolean repetedUSer = false;

        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        BasicDBObject query = (new BasicDBObject(username, username));
        System.out.println("Sql query is= " + query.toString());
        DBCursor cursor = collection.find(query);

        try {
            while (cursor.hasNext()) {
                DBObject doc = cursor.next();
                System.out.println("El usuario repetido es: " + doc);
                repetedUSer = true;

            }
        } finally {
            cursor.close();
        }

        return repetedUSer;

    }

    public String get_encrypted_salt(String id_user){
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);
        BasicDBObject query = (new BasicDBObject("_id", new ObjectId(id_user)));
        DBObject user_object = collection.findOne(query);
        return (String) user_object.get("EncryptKey");
    }

    public void saveAnalysis(String idUser, String html, String name_analysis){
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        BasicDBObject query = (new BasicDBObject("_id", new ObjectId(idUser)));

        try {
            Analysis analysis_list = new Analysis();
            analysis_list.setName_analysis(name_analysis);
            analysis_list.setResult(html);

            DBObject doc_analysis = PersonConverter.toDBObjectAnalysis(analysis_list);
            collection.update(query, new BasicDBObject("$push", new BasicDBObject(analysis, doc_analysis)));

        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    //Devuelve la lista de análisis realizados por un usuario
    public BasicDBList get_listAnalysis(String idUser) {
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        BasicDBObject query = new BasicDBObject().append("_id", new ObjectId(idUser));
        DBObject user = collection.findOne(query);

        return (BasicDBList) user.get(analysis);

    }

    //Devuelve un análisis para ser viasualizado
    public DBObject getAnalysis(String idUser, String id_analysis) {
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);

        BasicDBObject query = new BasicDBObject().append("_id", new ObjectId(idUser));

        BasicDBObject projection = new BasicDBObject(new BasicDBObject(analysis,
                new BasicDBObject("$elemMatch", new BasicDBObject("_id", new ObjectId(id_analysis)))));
        DBObject data = collection.findOne(query, projection);

        // Retrieve pacientes
        BasicDBList analysisList = (BasicDBList) data.get(analysis);

        DBObject analysis = null;

        // Solo debe devolver el análisis con el id coincidente
        if (analysisList.size() == 1) {
            analysis = (DBObject) analysisList.get(0);
        }

        return analysis;
    }

    public void delete_analysis(String idUser, String id_analysis){
        DB db = DatabaseConnection().getDB(dbname);
        DBCollection collection = db.getCollection(collection_name);
        BasicDBObject query = new BasicDBObject("_id", new ObjectId(idUser));

        BasicDBObject fields = new BasicDBObject(analysis,
                new BasicDBObject("_id", new ObjectId(id_analysis)));
        BasicDBObject update = new BasicDBObject("$pull", fields);
        collection.update(query, update);
    }




    public static void main(String[] args){

    }


}