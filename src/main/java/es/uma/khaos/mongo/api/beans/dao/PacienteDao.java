package es.uma.khaos.mongo.api.beans.dao;

import com.mongodb.*;
import com.mongodb.gridfs.GridFS;
import com.mongodb.gridfs.GridFSDBFile;
import com.mongodb.gridfs.GridFSInputFile;
import es.uma.khaos.mongo.api.beans.model.*;
import es.uma.khaos.mongo.api.beans.converter.PersonConverter;
import es.uma.khaos.mongo.api.beans.service.EncryptionDB;
import org.bson.types.ObjectId;

import java.io.File;
import java.util.*;
import java.util.Map.Entry;

import es.uma.khaos.mongo.api.beans.service.Database;

public class PacienteDao {

    public static String clinical_samples = "_clinicalSamples";
    public static String files = "_files";
    public static String form = "Form";
    public static String analysis = "Analysis";
    public static String filename = "filename";
    public static String sample_name = "sample_name";
    public static String metadata = "metadata";

    public static String upload_location_folder;
    public static String download_location_folder;

    private DBCollection collectionUser;
    private DB database;
    private String patients;
    private String patient_information;

    public PacienteDao() {
        try {
            Properties props = new Properties();
            props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));

            upload_location_folder = props.getProperty("scripts.Upload_location_folder");
            download_location_folder = props.getProperty("scripts.Download_location_folder");

            /* Establish Database Connection */
            this.database = Database.DatabaseConnection().getDB(props.getProperty("mongodb.dbname"));
            this.collectionUser = database.getCollection(props.getProperty("mongodb.dbcollection"));
            this.patients = "Patients";
            this.patient_information = "_patientInformation";
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void createUser(User user) {
        DBObject doc = PersonConverter.toDBObjectUser(user);
        this.collectionUser.insert(doc);
        ObjectId id = (ObjectId) doc.get("_id");
        user.setId(id.toString());
    }

    private GridFSInputFile createGridFS(String pathname, String nombre_archivo, String bucketName, Paciente paciente, User user, ObjectId objectId) {

        File Folder = new File(pathname + nombre_archivo);
        GridFS gfsFolder = new GridFS(database, bucketName);
        GridFSInputFile gfsFile = null;

        try {

            gfsFile = gfsFolder.createFile(Folder);
            gfsFile.setFilename(nombre_archivo);

            //Si entra en el if estaremos creando el paciente, en otro caso lo estamos actualizando
            if (paciente.getId() == null) {
                gfsFile.put("id_user", new ObjectId(user.getId()));
                gfsFile.put("id_paciente", objectId);
            } else {
                gfsFile.put("id_user", new ObjectId(user.getId()));
                gfsFile.put("id_paciente", new ObjectId(paciente.getId()));
            }

            gfsFile.save();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return gfsFile;

    }

    private List<DBObject> insertSample(User user, String nameSample, Paciente paciente, ObjectId objectId, Map<String, Object> metadataSamples, String pathname) {


        List<DBObject> docSamples = new ArrayList<>();

        try {

            if (!"".equals(nameSample)) {

                String bucketName = "Clinical_Samples";

                GridFSInputFile gfsFile = createGridFS(pathname, nameSample, bucketName, paciente, user, objectId);

                Muestras muestra = new Muestras();
                //muestra.setId_Muestra("");
                muestra.setNombre_Muestra(nameSample);
                muestra.setFecha_Muestra(gfsFile.getUploadDate());
                muestra.setMetadatos(metadataSamples);
                muestra.setGridFS(gfsFile);

                List<Muestras> muestras = new ArrayList<>();
                paciente.setMuestras(muestras);

                DBObject docmuestra = PersonConverter.toDBObjectMuestras(muestra);

                docSamples.add(docmuestra);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return docSamples;

    }

    private List<DBObject> insertFolders(String document, User user, Paciente paciente, ObjectId objectId, Map<String, Object> metadataDocument, String pathname) {

        List<DBObject> docFolders = new ArrayList<>();

        try {
            if (!"".equals(document)) {

                String bucketName = "Files";
                GridFSInputFile gfsFile = createGridFS(pathname, document, bucketName, paciente, user, objectId);

                Ficheros fichero = new Ficheros();
                fichero.setFilename(document);
                fichero.setMetadatos(metadataDocument);
                fichero.setGridFSInputFile(gfsFile);

                List<Ficheros> ficheros = new ArrayList<>();
                ficheros.add(fichero);

                paciente.setFicheros(ficheros);

                DBObject docFolder = PersonConverter.toDBObjectFicheros(fichero);

                docFolders.add(docFolder);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return docFolders;
    }

    public void deleteLocalFiles(String pathname) {
        File filepath = new File(pathname);
        File[] files = filepath.listFiles();

        assert files != null;
        if (files.length != 0) {
            for (File f : files) {
                if (f.isFile() && f.exists()) {
                    f.delete();
                }
            }
        }

    }

    public void createPatientByUser(Map<Object, Object> fields, Map<String, Object> metadataDocument, Map<String, Object> metadataSamples, User user, String document, String nameSample) {

        BasicDBObject query = (new BasicDBObject("_id", new ObjectId(user.getId())));
        List<Paciente> patientList = new ArrayList<>();
        Paciente paciente = new Paciente();

        try {
            Map<String, Object> castingFields = castingFieldsPatient(fields);
            paciente.setParameters(castingFields);
            ObjectId objectId = new ObjectId();

            //Convertimos las clases paciente y fichero a DBObject para introducirlas en MongoDB
            DBObject docPac = PersonConverter.toDBObjectPatient(paciente);
            patientList.add(paciente);

            //Llamamos a los métodos para insertar ficheros y muestras. Además declaramos el path donde se guardarán temporalmente
            String pathname = upload_location_folder;
            List<DBObject> docFolders = insertFolders(document, user, paciente, objectId, metadataDocument, pathname);
            List<DBObject> docSamples = insertSample(user, nameSample, paciente, objectId, metadataSamples, pathname);

            //Una vez insertados los ficheros en MongoDB los borro del directorio local
            deleteLocalFiles(pathname);

            docPac.put(files, docFolders);
            docPac.put("_id", objectId);
            docPac.put(clinical_samples, docSamples);

            collectionUser.update(query, new BasicDBObject("$push", new BasicDBObject(patients, docPac)));

            user.setPatientList(patientList);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void insertUpdatePatients(User user, String idP, Map<String, Object> metadataDocument, Map<String, Object> metadataSamples, Map<Object, Object> fields,
                                     List<String> deleteFields, String document, String nameSample, List<String> deleteFolders, List<String> deleteSamples) {

        //Busco por el ID de usuario y por el ID del paciente asociado a ese usuario
        BasicDBObject query = new BasicDBObject();
        query.put("_id", new ObjectId(user.getId()));
        query.put(patients + "._id", new ObjectId(idP));

        Paciente paciente = new Paciente();

        try {
            Map<String, Object> castingFields = castingFieldsPatient(fields);
            paciente.setParameters(castingFields);
            paciente.setId(idP);
            ObjectId objectId = new ObjectId();

            String pathname = upload_location_folder;
            List<DBObject> docFolders = insertFolders(document, user, paciente, objectId, metadataDocument, pathname);
            List<DBObject> docSamples = insertSample(user, nameSample, paciente, objectId, metadataSamples, pathname);

            //Una vez insertados los ficheros en MongoDB los borro del directorio local
            deleteLocalFiles(pathname);

            //Tengo que hacer las actualizaciones por separado ya que los ficheros se me borran en caso de que no los modifique
            update_patient_fields(castingFields, query);
            delete_patient_fields(deleteFields, query);
            update_files(docFolders, query);
            delete_files_from_mongodb(user.getId(), idP, deleteFolders);
            delete_samples_from_mongodb(user.getId(), idP, deleteSamples);
            update_samples(docSamples, query);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // Get form attributes to create a new patient
    public Map<String, Object> find_form_attributes(String id) {
        Map<String, Object> map = new LinkedHashMap<>();
        DBObject query = new BasicDBObject().append("_id", new ObjectId(id));
        DBObject data = collectionUser.findOne(query);

        // Retrieve form attributes
        assert data != null;
        DBObject getForm = (DBObject) data.get(form);

        if (getForm != null) {
            DBObject attributes = (DBObject) getForm.get("attributes");
            map.putAll(attributes.toMap());
        }
        return map;
    }


    /*This method return the list of patients of a given user*/
    private List<Paciente> find_all_patients(String id) {

        /*Retrieve information from User and crate the object with the model*/
        Paciente paciente = new Paciente();
        DBObject query = new BasicDBObject().append("_id", new ObjectId(id));
        DBObject data = collectionUser.findOne(query);

        /*Retrieve pacientes*/
        BasicDBList patients = (BasicDBList) data.get("Patients");
        List<Paciente> patientList = new ArrayList<Paciente>();

        /*Iterate over BasicBDList of patients*/
        for (Object patientObject : patients) {
            BasicDBObject patientAsDBObject = (BasicDBObject) patientObject;
            /*construct the map inside the patient object*/
            paciente = new Paciente(patientAsDBObject.getString("_id"), patientAsDBObject.toMap());
            patientList.add(paciente);
        }

        return patientList;
    }

    /*This method need the user id and the patient id and return a patient*/
    public User find_patient_by_id(String idUser, String idPatient) {
        BasicDBObject query = new BasicDBObject("_id", new ObjectId(idUser));

        BasicDBObject projection = new BasicDBObject(new BasicDBObject(patients,
                new BasicDBObject("$elemMatch", new BasicDBObject("_id", new ObjectId(idPatient)))));
        DBObject data = collectionUser.findOne(query, projection);
        DBObject data_user = collectionUser.findOne(query);
        /*Retrieve patients*/
        BasicDBList patients = (BasicDBList) data.get("Patients");
        List<Paciente> patientList = new ArrayList<>();

        Paciente paciente;
        for (Object patientObject : patients) {
            BasicDBObject patientAsDBObject = (BasicDBObject) patientObject;
            paciente = new Paciente(patientAsDBObject.getString("_id"), patientAsDBObject.toMap());
            patientList.add(paciente);
        }

        User user = new User();
        user.setSalt((String) data_user.get("EncryptKey"));
        user.setPatientList(patientList);

        /*Decrypt data before show it*/
        return field_decryption(user);
    }

    /*This method return all the fields keys of a given user*/
    public Map<String, Object> find_fields_keys(String user_id) {
        List<Paciente> ListPatients = find_all_patients(user_id);
        Map<String, Object> map = new LinkedHashMap<>();
        for (Paciente paciente : ListPatients) {
            Map<String, Object> parameters = paciente.getParameters();
            for (Entry<String, Object> entry : parameters.entrySet()) {
                if (entry.getKey().equals(patient_information)) {
                    Map<String, Object> entry2 = (Map<String, Object>) entry.getValue();
                    for (Entry<String, Object> entry3 : entry2.entrySet()) {
                        if (!(entry3.getValue() instanceof List)) // We don´t take array
                        {
                            map.put(entry3.getKey(), entry3.getValue());
                        }
                    }
                }
            }
        }
        return map;
    }

    /*This method return all the fields keys of the user files*/
    public Map<String, Object> find_fields_keys_files(String id) {
        return find_keys_metadata(id, files);
    }

    /*This method return all the fields keys of the user samples*/
    public Map<String, Object> find_fields_keys_samples(String id) {
        return find_keys_metadata(id, clinical_samples);
    }

    /*This method return all the metadata that the user' samples have in common to show as a label in the heatmap analysis*/
    public List<String> find_samples_metadata_common(String id) {
        Map<String, Object> mapSample = find_keys_metadata(id, clinical_samples);
        List<String> keysInCommon = new ArrayList<>();
        for (Entry<String, Object> entry : mapSample.entrySet()) {
            keysInCommon.add(entry.getKey());
        }
        return keysInCommon;
    }

    private Map<String, Object> find_keys_metadata(String id, String name) {
        List<Paciente> ListPatients = find_all_patients(id);
        Map<String, Object> mapMetadata = new LinkedHashMap<>();
        for (Paciente paciente : ListPatients) {
            Map<String, Object> parameters = paciente.getParameters();
            for (Entry<String, Object> entry : parameters.entrySet()) {
                if (entry.getKey().equals(name)) {
                    List<DBObject> MetadataList;
                    MetadataList = (List<DBObject>) entry.getValue();
                    if (MetadataList != null) {
                        for (DBObject Metadata : MetadataList) {
                            Map<String, Object> mappingFolder = Metadata.toMap();

                            for (Entry<String, Object> entry4 : mappingFolder.entrySet()) {
                                if (entry4.getKey().equals(metadata)) {
                                    Map<String, Object> entry5 = (Map<String, Object>) entry4.getValue();

                                    for (Entry<String, Object> entry6 : entry5.entrySet()) {
                                        mapMetadata.put(entry6.getKey(), entry6.getValue());
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        return mapMetadata;

    }

    /*This method return the user with all his patients*/
    public User find_user_all_patients(String id) {
        DBObject query = new BasicDBObject().append("_id", new ObjectId(id));
        DBObject data = collectionUser.findOne(query);
        assert data != null;
        User user = PersonConverter.toUser(data);

        List<Paciente> patientList = new ArrayList<Paciente>();

        patientList = find_all_patients(id);

        user.setPatientList(patientList);

        /*decrypt fields before show it*/
        return field_decryption(user);
    }


    /*This method return the user with all his patients that match the query parameter*/
    public User find_user_patient_by_parameter(String id, String kParameter, String vParameter) {
        User user = find_user_all_patients(id);
        /*call the method to check the kParameter and vParameter*/
        List<Paciente> patientListResults = find_patient_by_parameter(user.getPatientList(), kParameter, vParameter);
        user.setPatientList(patientListResults);
        return user;
    }

    /*This method return all the patients that match the query parameter*/
    private List<Paciente> find_patient_by_parameter(List<Paciente> patientList, String kParameter,
                                                     String vParameter) {

        List<Paciente> patientResult = new ArrayList<Paciente>();

        for (Paciente paciente : patientList) {

            Map<String, Object> parameters = paciente.getParameters();

            for (Entry<String, Object> entry : parameters.entrySet()) {

                if (entry.getKey().equals(patient_information)) {

                    Map<String, Object> entry2 = (Map<String, Object>) entry.getValue();

                    for (Entry<String, Object> entry3 : entry2.entrySet()) {
                        /* If patient parameter is not a List we can search for it */
                        if (!(entry3.getValue() instanceof List)) {
                            Map<String, Object> entry4 = (Map<String, Object>) entry3.getValue();
                            for (Entry<String, Object> entry5 : entry4.entrySet()) {
                                if (entry5.getKey().equals("Value")) {
                                    if ((entry3.getKey().equalsIgnoreCase(kParameter)) && (entry5.getValue().toString().equalsIgnoreCase(vParameter))) {
                                        patientResult.add(paciente);
                                    }
                                } else {
                                    if (entry5.getValue() instanceof Map) {
                                        Map<String, String> entry6 = (Map<String, String>) entry5.getValue();
                                        for (Entry<String, String> entry7 : entry6.entrySet()) {
                                            if (entry7.getKey().equals("Value")) {
                                                if ((entry5.getKey().equalsIgnoreCase(kParameter)) && (entry7.getValue().toString().equalsIgnoreCase(vParameter))) {
                                                    patientResult.add(paciente);
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                    }
                }
            }
        }

        return patientResult;
    }

    public void download_file_from_mongodb(String document, String type, String idUser, String idPatient) {
        try {
            //Establecemos conexión con MongoDB
            GridFS gfsFolder = new GridFS(database, type);

            DBObject query = new BasicDBObject("id_user", new ObjectId(idUser)).append("id_paciente", new ObjectId(idPatient)).append("filename", document);

            // Recuperamos el documento de la colección de Folder donde se encuentra el contenido del fichero
            GridFSDBFile FileOutput = gfsFolder.findOne(query);

            // Lo guardamos en el nuevo directorio
            FileOutput.writeTo(download_location_folder + document);

            //Lo borramos del directorio local

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void delete_patient_fields(List<String> deleteFields, BasicDBObject query) {
        for (String field : deleteFields) {
            collectionUser.update(query, new BasicDBObject("$unset", new BasicDBObject(patients + ".$." + patient_information + "." + field, " ")), true, false);
        }
    }

    private void update_patient_fields(Map<String, Object> fields, BasicDBObject query) {
        System.out.println(fields);
        collectionUser.update(query, new BasicDBObject("$set", new BasicDBObject(patients + ".$." + patient_information, fields)), true, false);
    }

    private void update_files(List<DBObject> docFolders, BasicDBObject query) {
        for (DBObject folder : docFolders) {
            collectionUser.update(query, new BasicDBObject("$push", new BasicDBObject(patients + ".$." + files, folder)));
        }
    }

    private void update_samples(List<DBObject> docSamples, BasicDBObject query) {
        for (DBObject sample : docSamples) {
            collectionUser.update(query, new BasicDBObject("$push", new BasicDBObject(patients + ".$." + clinical_samples, sample)));
        }
    }

    public void delete_patient(String idUser, String idP) {
        BasicDBObject query = new BasicDBObject("_id", new ObjectId(idUser));

        BasicDBObject fields = new BasicDBObject(patients,
                new BasicDBObject("_id", new ObjectId(idP)));
        BasicDBObject update = new BasicDBObject("$pull", fields);

        collectionUser.update(query, update);
    }

    //ATENCIÓN --> Tenemos dos métodos de borrar ficheros y Muestras: el primero borra los ficheros en la colección de User y el segundo
    //borra el fichero de la colección de Folder y Muestras donde se almacena el contenido del fichero.

    private void delete_files_from_mongodb(String idUser, String idPac, List<String> deleteFolders) {
        //Me devuelve un usuario pero la lista de pacientes solo tiene el paciente seleccionado
        BasicDBObject match = new BasicDBObject("_id", new ObjectId(idUser));
        match.put(patients + "._id", new ObjectId(idPac));

        for (String deleteFolder : deleteFolders) {
            //Declaramos el fichero que queremos seleccionar y lo cogemos por su filename
            BasicDBObject ficheroSpec = new BasicDBObject();
            ficheroSpec.put(filename, deleteFolder);

            //Borramos el fichero accediendo en dos arrays (pacientes y ficheros)
            BasicDBObject update = new BasicDBObject();
            update.put("$pull", new BasicDBObject(patients + ".$." + files, ficheroSpec));

            collectionUser.update(match, update, true, true);

        }
        delete_files_from_gridfs(idUser, idPac, deleteFolders);

    }

    private void delete_samples_from_mongodb(String idUser, String idPac, List<String> samplesList) {
        //Me devuelve un usuario pero la lista de pacientes solo tiene el paciente seleccionado
        BasicDBObject match = new BasicDBObject("_id", new ObjectId(idUser));
        match.put(patients + "._id", new ObjectId(idPac));

        for (String s : samplesList) {
            //Declaramos el fichero que queremos seleccionar y lo cogemos por su filename
            BasicDBObject muestraSpec = new BasicDBObject();
            muestraSpec.put(sample_name, s);

            BasicDBObject update = new BasicDBObject();
            update.put("$pull", new BasicDBObject(patients + ".$." + clinical_samples, muestraSpec));

            collectionUser.update(match, update, true, true);
        }
        delete_samples_from_gridfs(idUser, idPac, samplesList);

    }

    private void delete_files_from_gridfs(String idUser, String idPatient, List<String> folderList) {
        GridFS gfsFolder = new GridFS(database, "Files");

        for (String s : folderList) {
            DBObject query = new BasicDBObject("id_user", new ObjectId(idUser)).append("id_paciente", new ObjectId(idPatient)).append("filename", s);
            GridFSDBFile FileOutput = gfsFolder.findOne(query);
            gfsFolder.remove(FileOutput);

        }

    }

    private void delete_samples_from_gridfs(String idUser, String idPatient, List<String> sampleList) {
        GridFS gfsSample = new GridFS(database, "Clinical_Samples");

        for (String s : sampleList) {
            DBObject query = new BasicDBObject("id_user", new ObjectId(idUser)).append("id_paciente", new ObjectId(idPatient)).append("filename", s);
            GridFSDBFile FileOutput = gfsSample.findOne(query);
            gfsSample.remove(FileOutput);
        }

    }


    //Método para diseñar el formulario para insertar la información clínica de los pacientes
    public void design_form(Map<String, Object> fields, User user, List<String> deleteFields) {

        BasicDBObject query = new BasicDBObject();
        query.put("_id", new ObjectId(user.getId()));
        Form formulario = new Form();
        //Map<String, Object> castingFields = castingFieldsForm(fields);
        formulario.setForm_attributes(fields);

        //Convertimos las clase Form a DBObject para introducirla en MongoDB
        DBObject docForm = PersonConverter.toDBObjectForm(formulario);

        collectionUser.update(query, new BasicDBObject("$set", new BasicDBObject(form, docForm)), true, false);

        //Delete fields from form
        delete_fields_in_form(deleteFields, query);

        user.setForm(formulario);

    }

    //Método para eliminar campos del formulario
    private void delete_fields_in_form(List<String> delete_fields, BasicDBObject query) {

        for (String deleteField : delete_fields) {
            collectionUser.update(query, new BasicDBObject("$unset", new BasicDBObject(form + ".attributes." + deleteField, " ")), true, false);
        }

    }

    // Método para poner cada una de las entradas del tipo: Map<Key,<Value,Type>>
    // EJ: si insertamos una fecha: Map<Fecha nacimiento,<1995,Date>>
    public Map<String, Object> castingFieldsPatient(Map<Object, Object> fieldsType) {
        Map<String, Object> castingFields = new LinkedHashMap<>();
        Map<String, Object> subCastingFields = new LinkedHashMap<>();

        try {
            for (Entry<Object, Object> entry : fieldsType.entrySet()) {
                Map<String, Object> entry1 = (Map<String, Object>) entry.getKey();
                Object[] keys = entry1.keySet().toArray();
                Object[] values = entry1.values().toArray();
                List<String> types = (List<String>) entry.getValue();
                for (int i = 0; i < keys.length; i++) {
                    //Cada entry sera un Map del tipo: String<Name,type>
                    Map<Object, Object> field_map = new LinkedHashMap<>();
                    if (types.get(i).equals("BasicDBObject")) {
                        Map<Object, List<String>> entry2 = (Map<Object, List<String>>) values[i];
                        for (Entry<Object, List<String>> entry3 : entry2.entrySet()) {
                            Map<String, String> entry4 = (Map<String, String>) entry3.getKey();
                            Object[] subKeys = entry4.keySet().toArray();
                            Object[] subValues = entry4.values().toArray();
                            List<String> subtypes = entry3.getValue();
                            for (int j = 0; j < subKeys.length; j++) {
                                Map<Object, Object> subfield_map = new LinkedHashMap<>();
                                subfield_map.put("Value", (String) subValues[j]);
                                subfield_map.put("Type", subtypes.get(j));
                                subCastingFields.put((String) subKeys[j], subfield_map);
                                //subCastingFields.put((String) subKeys[j], castingVariablePatient(subtypes.get(j), (String) subValues[j]));
                            }
                        }
                        castingFields.put((String) keys[i], subCastingFields);
                    } else {
                        //castingFields.put((String) keys[i], castingVariablePatient(types.get(i), (String) values[i]));
                        field_map.put("Value", values[i]);
                        field_map.put("Type", (types.get(i)));
                        castingFields.put((String) keys[i], field_map);
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return castingFields;
    }

    //With this method we encrypt fields values before insert in the database
    public List<String> field_encryption(List<String> fields_list, String key_salt) {
        EncryptionDB encryptionDB = new EncryptionDB();
        List<String> fields_encrypt = new ArrayList<>();
        for (String field : fields_list) {
            String encrypt = encryptionDB.encrypt_field(field, key_salt);
            fields_encrypt.add(encrypt);
        }
        return fields_encrypt;
    }

    //This method we can decrypt fields values before showing in the use interface
    private User field_decryption(User user) {
        EncryptionDB encryptionDB = new EncryptionDB();
        List<Paciente> patients = user.getPatientList();
        for (Paciente patient : patients) {
            Map<String, Object> parameters = patient.getParameters();
            for (Entry<String, Object> entry : parameters.entrySet()) {
                if (entry.getKey().equals("_patientInformation")) {
                    Map<String, Object> entry2 = (Map<String, Object>) entry.getValue();

                    /* Si queremos insertar las evaluaciones del paciente como un array de evaluaciones */
                    for (Entry<String, Object> entry3 : entry2.entrySet()) {
                        if (entry3.getValue() instanceof List) //EVALUACIONES
                        {
                            for (Iterator it = ((List) entry3.getValue()).iterator(); it.hasNext(); ) {
                                Map<String, Object> evaluations_iterator = (Map<String, Object>) it.next();
                                for (Entry<String, Object> evaluations : evaluations_iterator.entrySet()) {

                                    System.out.println(evaluations.getValue());
                                    Map<String, Object> eval = (Map<String, Object>) evaluations.getValue();
                                    for (Entry<String, Object> entry_list : eval.entrySet()) {
                                        if (entry_list.getKey().equals("Value")) {
                                            String field_decryption = encryptionDB.decrypt_field((String) entry_list.getValue(), user.getSalt());
                                            eval.put("Value", field_decryption);
                                        }
                                    }
                                }
                            }
                        } else {
                            Map<String, Object> entry4 = (Map<String, Object>) entry3.getValue();
                            for (Entry<String, Object> entry5 : entry4.entrySet()) {
                                if (entry5.getValue() instanceof String) {
                                    if (entry5.getKey().equals("Value")) {
                                        String field_decryption = encryptionDB.decrypt_field((String) entry5.getValue(), user.getSalt());
                                        entry4.put("Value", field_decryption);
                                    }
                                } else {
                                    Map<String, Object> entry6 = (Map<String, Object>) entry5.getValue();
                                    for (Entry<String, Object> entry7 : entry6.entrySet()) {
                                        if (entry7.getKey().equals("Value")) {
                                            String subfield_decryption = encryptionDB.decrypt_field((String) entry7.getValue(), user.getSalt());
                                            entry6.put("Value", subfield_decryption);
                                        }
                                    }

                                }
                            }
                        }
                    }
                }
            }
        }
        user.setPatientList(patients);
        return user;
    }


    // Delete all the patients for a given user
    public void delete_patients_array(String user_id) {
        BasicDBObject query = new BasicDBObject();
        query.put("_id", new ObjectId(user_id));
        collectionUser.update(query, new BasicDBObject("$unset", new BasicDBObject("Patients", " ")), true, false);

    }

    public static void main(String[] args) {
//        PacienteDao pacienteDao = new PacienteDao();
//        User user = pacienteDao.find_user_all_patients("5dd53b19f534772c8292a6cd");
//        System.out.println(pacienteDao.find_fields_keys("5dd53b19f534772c8292a6cd"));
//        System.out.println(user.getPatientList());
//        pacienteDao.delete_patients_array("5dd53b19f534772c8292a6cd");

    }
}


