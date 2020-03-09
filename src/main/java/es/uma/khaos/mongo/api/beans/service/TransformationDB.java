package es.uma.khaos.mongo.api.beans.service;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBObject;
import es.uma.khaos.mongo.api.beans.converter.PersonConverter;
import es.uma.khaos.mongo.api.beans.dao.PacienteDao;
import es.uma.khaos.mongo.api.beans.model.Paciente;
import es.uma.khaos.mongo.api.beans.model.User;
import org.bson.types.ObjectId;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.sql.*;
import java.util.*;


// DB Transformation: First you should create a MongoDB User and insert here the patients from OracleDB
public class TransformationDB {

    private TransformationDB() {
    }

    // Insert patient for a given user
    private void insert_patient_in_mongodb(String id_user, Paciente paciente)
    {
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
            DB database = Database.DatabaseConnection().getDB(props.getProperty("mongodb.dbname"));
            DBCollection collectionUser = database.getCollection(props.getProperty("mongodb.dbcollection"));
            BasicDBObject mongo_query = new BasicDBObject();
            mongo_query.put("_id", new ObjectId(id_user));

            //Convertimos las clases paciente y fichero a DBObject para introducirlas en MongoDB
            ObjectId objectId = new ObjectId();
            DBObject docPac = PersonConverter.toDBObjectPatient(paciente);
            docPac.put("_id", objectId);
            collectionUser.update(mongo_query, new BasicDBObject("$push", new BasicDBObject("Patients", docPac)));
        }catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    // With this method we take the patients table in OracleDB and transform to MongoDB for a given user
    private void insert_patients_oracle_db_transformation(String id_user, int ID_USUARIO) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));

            EncryptionDB encryptionDB = new EncryptionDB();

            String dbUrl = props.getProperty("db.url");
            String dbUser = props.getProperty("db.user");
            String dbPassword = props.getProperty("db.password");
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);
            String query = "select p.CODIGO_PACIENTE, p.ID_USUARIO, p.REFERENCIAHOSPITAL,p.SEXO, p.FECHANACIMIENTO, p.ANTECEDENTES, p.POLIMEDICACION, " +
            "p.SISTEMAAB0, p.ECOG, p.FECHADIAGNOSTICOTUMORPRIMARIO, p.FECHADIAGNOSTICOMELANOMAMETAST," +
            "p.OPERACIONTUMORPRIMARIO, p.RECIBIOADYUVANCIA, p.INICIOADYUVANCIA, p.FINADYUVANCIA, p.ADYUVANCIACOMPLETA," +
            "p.FENOMENOSAUTOINMUNESADYUVANCIA, p.TOXICIDADADYUVANCIA, p.METASTASECTOMA, " +
            "NMM.TITULO as Estadio_NMM, NMT.TITULO as Estadio_NMT, R.TITULO as Raza, p.MITOSIS, p.ULCERACION, p.TIL," +
            "TNM.TITULO as TNM, MU.TITULO ID_Mutacion, RM.TITULO as Resultado_Metasectomia,INHBRAF.TITULO as INHBRAF,p.FECHAINICIOINHBRAF, " +
            "p.NUMEROLINEAS,p.DOSISINICIALINHBRAF, p.REDUCCIONDOSISINHBRAF, p.SEMANASINHBRAF, INHMEK.TITULO as INHMEK, " +
            "p.FECHAINICIOINHMEK, p.DOSISINICIALINHMEK, p.REDUCCIONDOSISINHMEK,p.SEMANASINHMEK, p.OTROTRATAMIENTOCONCOMINANTE," +
            "p.FECHASUSPENSION , MS.TITULO as Motivo_Suspension, p.COMENTARIOS, p.FECHA_PROGRESION, p.FECHA_FINAL, p.VIVO_SUPERVIVENCIA," +
            "RESP_IMG.TITULO as Respuesta_Prueba_Imagen ,RES.TITULO as Mejor_Respuesta_final, p.FECHA_CREACION " +
            "from MELANOMA.PACIENTES p " +
            "FULL JOIN MELANOMA.RAZA R on p.IDRAZA = R.IDRAZA "+
            "FULL JOIN MELANOMA.RESPUESTAS RES on p.MEJOR_RESPUESTA_FINAL = RES.ID_RESPUESTA " +
            "FULL JOIN MELANOMA.RESPUESTAS RESP_IMG on p.RESPUESTA_PRUEBA_IMAGEN = RESP_IMG.ID_RESPUESTA " +
            "FULL JOIN MELANOMA.MUTACIONES_BRAF MU on p.ID_MUTACION = MU.ID_MUTACION "+
            "FULL JOIN MELANOMA.ESTADIOTNMM NMM on p.IDTNMM = NMM.IDTNMM "+
            "FULL JOIN MELANOMA.ESTADIOTNMT NMT on p.IDTNMT = NMT.IDTNMT "+
            "FULL JOIN MELANOMA.RESULTADOS_METASECTOMIA RM on p.ID_RESULTADO = RM.ID_RESULTADO "+
            "FULL JOIN MELANOMA.TNM TNM on p.TNM = TNM.ID_TNM "+
            "FULL JOIN MELANOMA.INHBRAF INHBRAF on p.IDINHBRAF = INHBRAF.IDINHBRAF "+
            "FULL JOIN MELANOMA.INHMEK INHMEK on p.IDINHMEK = INHMEK.IDINHMEK "+
            "FULL JOIN MELANOMA.MOTIVOSSUSPENSION MS on p.IDMOTIVO = MS.IDMOTIVO "+
            "where p.ID_USUARIO=? ";

            stmt = conn.prepareStatement(query);
            stmt.setInt(1, ID_USUARIO);
            rs = stmt.executeQuery();

            ResultSetMetaData rsmd = rs.getMetaData();

            System.out.println("No of columns in the table:"
                    + rsmd.getColumnCount());

            // Get encrypted key of the user for data encryption
            Database db = new Database();
            String encrypted_key = db.get_encrypted_salt(id_user);

            // For each row in OracleDB (Pacientes) we create a new Patient in MongoDB
            while (rs.next()) {
                Paciente paciente = new Paciente();
                PacienteDao pacienteDao = new PacienteDao();
                Map<String, Object> patient_info = new LinkedHashMap<>();
                Map<Object, Object> patient_info_type = new LinkedHashMap<>();
                List<String> type = new ArrayList<>();

                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    String cname = rsmd.getColumnName(i);

                    if (rs.getString(i) != null) {
                        type.add(casting_oracle_type_to_mongodb(rsmd.getColumnTypeName(i)));
                        String value = rs.getString(i);
                        if (rsmd.getColumnTypeName(i).equalsIgnoreCase("DATE"))
                        {
                            String [] date = rs.getString(i).split("-");
                            String day = date[2].split(" ")[0];
                            String months = date[1];
                            String year = date[0];
                            value = year+"-"+months+"-"+day;
                        }
                        // Data encryption before inserting in MongoDB
                        String encrypt = encryptionDB.encrypt_field(value, encrypted_key);
                        patient_info.put(cname, encrypt);
                    }
                }
                patient_info_type.put(patient_info, type);
                Map<String, Object> castingFields = pacienteDao.castingFieldsPatient(patient_info_type);
                paciente.setParameters(castingFields);

                // For each patient insert in MongoDB
                insert_patient_in_mongodb(id_user, paciente);
            }
        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private void get_all_patients_code(String id_user, String oracle_query)
    {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
            String dbUrl = props.getProperty("db.url");
            String dbUser = props.getProperty("db.user");
            String dbPassword = props.getProperty("db.password");
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Primero haríamos un select distinct p.codigo_paciente para recuperar todos los códigos de los pacientes para insertarle las evaluaciones

            // Acabar de seccionar todos los parámetros de esta tabla
            String sql_evaluaciones = "select DISTINCT p.CODIGO_PACIENTE " +
                    "from MELANOMA.PACIENTES p";

            stmt = conn.prepareStatement(sql_evaluaciones);

            rs = stmt.executeQuery();
            while (rs.next()) {
                String patient_code = rs.getString("CODIGO_PACIENTE");
                read_evaluations_foreach_patient(id_user, patient_code, oracle_query);
            }

        }catch (Exception e)
        {
            e.printStackTrace();
        }
    }

    private void read_evaluations_foreach_patient(String id_user, String patient_code, String oracle_query) throws SQLException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));

            EncryptionDB encryptionDB = new EncryptionDB();

            String dbUrl = props.getProperty("db.url");
            String dbUser = props.getProperty("db.user");
            String dbPassword = props.getProperty("db.password");
            Class.forName("oracle.jdbc.driver.OracleDriver");
            conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword);

            // Primero haríamos un select distinct p.codigo_paciente para recuperar todos los códigos de los pacientes para insertarle las evaluaciones

            String sql_query = "";
            switch (oracle_query)
            {
                case "Location":
                    sql_query = "select p.CODIGO_PACIENTE, LM.TITULO as Localizacion_Metastasis, l.MEJOR_O_PROGRESION " +
                            "from MELANOMA.PACIENTES p, MELANOMA.LOCALIZACIONES_RESPUESTA l  "+
                            "FULL JOIN MELANOMA.LOCALIZACIONMETASTASIS LM on l.IDLOCALIZACIONMETASTASIS = LM.IDLOCALIZACIONMETASTASIS "+
                            "where p.CODIGO_PACIENTE=? ";
                    break;

                case "evaluations":
                    sql_query = "select DISTINCT TE.GRADO as Grado_Toxicidad, TT.TITULO as Tipo_Toxicidad,e.SEMANA, e.ECOG," +
                            "e.LEUCOCITOS,e.COMENTARIOS_LEUCOCITOS, e.NEUTROFILOS, e.MONOCITOS, e.EOSINOFILOS, e.LINFOCITOS," +
                            "e.PLAQUETAS, e.HB, e.LDH, e.OTRA_ALTERACION, e.CAMBIO_MED_DOMICILIO, e.COMENTARIOS_CAMBIO, " +
                            "e.INFECCION_O_ANTIBIOTICOS, e.SUSPENSION, e.RETRASO, e.REDUCCION_DOSIS, e.DOSIS_BRAF, e.DOSIS_MEK," +
                            "e.MEJORA_CLINICA_OBJ, e.MEJORA_COMENTARIOS, e.FECHA_EXTRACCION " +
                            "from MELANOMA.PACIENTES p, MELANOMA.EVALUACIONES e  " +
                            "JOIN MELANOMA.TOXICIDAD_EN_EVALUACION TE on e.ID_EVALUACION = TE.ID_EVALUACION " +
                            "JOIN MELANOMA.TIPOS_TOXICIDAD TT on TE.ID_TIPO_TOXIC = TT.ID_TIPO_TOXIC " +
                            "where p.CODIGO_PACIENTE=? " +
                            "ORDER BY p.CODIGO_PACIENTE";
            }


            int code = Integer.parseInt(patient_code.trim());
            stmt = conn.prepareStatement(sql_query);
            stmt.setInt(1, code);
            rs = stmt.executeQuery();

            ResultSetMetaData rsmd = rs.getMetaData();

            System.out.println("No of columns in the table:"
                    + rsmd.getColumnCount());

            // Get encrypted key of the user for data encryption
            Database db = new Database();
            String encrypted_key = db.get_encrypted_salt(id_user);


            PacienteDao pacienteDao = new PacienteDao();
            List<Map<String,Object>> evalutions = new ArrayList<>();

            // For each row in OracleDB (Evaluaciones for patient) we create a new Evaluation in Evaluations[] MongoDB
            while (rs.next()) {
                Map<String, Object> eval_info = new LinkedHashMap<>();
                Map<Object, Object> eval_info_type = new LinkedHashMap<>();
                List<String> type = new ArrayList<>();

                for (int i = 1; i <= rsmd.getColumnCount(); i++) {
                    String cname = rsmd.getColumnName(i);
                    if (rs.getString(i) != null) {
                        type.add(casting_oracle_type_to_mongodb(rsmd.getColumnTypeName(i)));
                        String value = rs.getString(i);
                        if (rsmd.getColumnTypeName(i).equalsIgnoreCase("DATE"))
                        {
                            String [] date = rs.getString(i).split("-");
                            String day = date[2].split(" ")[0];
                            String months = date[1];
                            String year = date[0];
                            value = year+"-"+months+"-"+day;
                        }
                        // Data encryption before inserting in MongoDB
                        String encrypt = encryptionDB.encrypt_field(value, encrypted_key);
                        eval_info.put(cname, encrypt);
                    }
                }
                eval_info_type.put(eval_info, type);
                Map<String, Object> castingFields = pacienteDao.castingFieldsPatient(eval_info_type);
                // Add evaluations
                evalutions.add(castingFields);
            }
            patient_code = encryptionDB.encrypt_field(patient_code,encrypted_key);
            insert_evaluations_foreach_patient(id_user,patient_code,evalutions,oracle_query);
        } catch (Exception e) {
            e.printStackTrace();

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private void insert_evaluations_foreach_patient(String id_user, String patient_code,List<Map<String,Object>> evaluations, String oracle_query)
    {
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
            DB database = Database.DatabaseConnection().getDB(props.getProperty("mongodb.dbname"));
            DBCollection collectionUser = database.getCollection(props.getProperty("mongodb.dbcollection"));
            BasicDBObject mongo_query = new BasicDBObject();
            mongo_query.put("_id", new ObjectId(id_user));
            mongo_query.put("Patients" + "._patientInformation.CODIGO_PACIENTE.Value", patient_code);

            for(Map<String,Object> eval: evaluations ) {
                switch (oracle_query) {
                    case "Location":
                        collectionUser.update(mongo_query, new BasicDBObject("$push", new BasicDBObject("Patients.$._patientInformation.LOCALIZACIONES_RESPUESTA", eval)));
                        break;
                    case "evaluations":
                        collectionUser.update(mongo_query, new BasicDBObject("$push", new BasicDBObject("Patients.$._patientInformation.EVALUACIONES", eval)));
                }
            }

        }catch (Exception e)
        {
            e.printStackTrace();
        }
    }


    private String casting_oracle_type_to_mongodb(String type) {
        switch (type) {
            case "VARCHAR2":
                type = "String";
                break;
            case "NUMBER":
                type = "Integer";
                break;
            case "DATE":
                type = "Date";
                break;
            case "boolean":
                type = "Boolean";

        }
        return type;
    }

    private void design_form_db_transformation(String id_user)
    {
        User user = new User();
        user.setId(id_user);
        PacienteDao pacienteDao = new PacienteDao();
        // First we take all the keys of all the patients of a given user
        Map<String,Object> fields = pacienteDao.find_fields_keys(id_user);
        Map<String,Object> key_fields = new LinkedHashMap<>();
        for (Map.Entry<String, Object> entry: fields.entrySet()) {
            Map<String, Object> entry2 = (Map<String, Object>) entry.getValue();
            for (Map.Entry<String, Object> entry3 : entry2.entrySet()) {
                if(entry3.getKey().equalsIgnoreCase("Type"))
                {
                    key_fields.put(entry.getKey(),entry3.getValue());
                }
            }
        }

        // Then we create a Form with these keys
        List<String> deleteFields = new ArrayList<>();
        pacienteDao.design_form(key_fields,user, deleteFields);
    }

    // READ DATA FROM CSV AND INSERT IT IN MONGODB IN SUITABLE FORMAT
    private void insert_patients_csv_transformation(String pathToCsv, String id_user)
    {
        BufferedReader br = null;
        String line = "";
        String cvsSplitBy = ";";
        EncryptionDB encryptionDB = new EncryptionDB();
        PacienteDao pacienteDao = new PacienteDao();
        Paciente paciente = new Paciente();
        List<String> type = new ArrayList<>();

        // Get encrypted key of the user for data encryption
        Database db = new Database();
        String encrypted_key = db.get_encrypted_salt(id_user);

        try {
            br = new BufferedReader(new FileReader(pathToCsv));
            String [] header = br.readLine().split(cvsSplitBy);
            while ((line = br.readLine()) != null) {
                // use separator
                String[] column = line.split(cvsSplitBy);

                Map<String,Object> patient_fields = new LinkedHashMap<>();
                Map<Object, Object> patient_info_type = new LinkedHashMap<>();

                for(int i =0; i<header.length; i++)
                {
                    String encrypted_value = encryptionDB.encrypt_field(column[i],encrypted_key);
                    patient_fields.put(header[i],encrypted_value);
                    type.add("String");
                }
                patient_info_type.put(patient_fields,type);
                Map<String,Object> castingFields = pacienteDao.castingFieldsPatient(patient_info_type);
                paciente.setParameters(castingFields);

                // For each patient insert in MongoDB
                insert_patient_in_mongodb(id_user, paciente);
            }

        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }

    }

    public static void main(String[] args) throws Exception {

//        /* JAVA WORKFLOW FOR ORACLEDB TRANSLATION TO MONGODB */
        String iduser = "5dd53b19f534772c8292a6cd";
        int id_usuario_oracle = 1000;
//        // Delete patient list if you encounter any patient in the given user (optional)
//        PacienteDao pacienteDao = new PacienteDao();
//        pacienteDao.delete_patients_array(iduser);
//
//        // Find the list of patients in OracleDB and translate to a suitable format for MongoDB
        TransformationDB oracleConnection = new TransformationDB();
//        oracleConnection.insert_patients_oracle_db_transformation(iduser,id_usuario_oracle);
//        // Design the form with all the key fields of the patient list
//        oracleConnection.design_form_db_transformation(iduser);

        /* JAVA WORKFLOW FOR CSV TRANSLATION TO MONGODB */
//        oracleConnection.insert_patients_csv_transformation("/home/antonio/Idea_Projects/melanoma/Files/clinicalInfo.csv","5dd2c60ef534772c8292a6c9");
//        oracleConnection.design_form_db_transformation("5dd2c60ef534772c8292a6c9");

        /*Insert Evaluations for each patient */
        String oracle_query = "evaluations";

        oracleConnection.get_all_patients_code(iduser,oracle_query);

    }
}