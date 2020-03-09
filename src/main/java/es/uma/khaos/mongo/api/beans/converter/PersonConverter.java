package es.uma.khaos.mongo.api.beans.converter;

import com.mongodb.BasicDBObjectBuilder;
import com.mongodb.DBObject;
import es.uma.khaos.mongo.api.beans.model.*;
import org.bson.types.ObjectId;

import java.util.List;

public class PersonConverter {

    public static String name = "Name";
    public static String surname = "Surname";
    public static String email = "Email";
    public static String username = "Username";
    public static String password = "Password";
    public static String encrypt_key = "EncryptKey";
    public static String patients = "Patients";
    public static String patient_information = "_patientInformation";
    public static String clinical_samples = "_clinicalSamples";
    public static String files = "_files";
    public static String form = "Form";
    public static String analysis = "Analysis";
    public static String filename = "filename";
    public static String sample_name = "sample_name";
    public static String analysis_name = "analysis_name";
    public static String metadata = "metadata";
    public static String gridFS_sample = "gridFS_Sample";
    public static String gridFS_file = "gridFS_File";


    public static DBObject toDBObjectUser(User user) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append(name, user.getName())
                .append(surname, user.getSurname())
                .append(email, user.getEmail())
                .append(username, user.getUserName())
                .append(password, user.getPassword())
                .append(encrypt_key, user.getSalt())
                .append(patients, user.getPatientList())
                .append(form, user.getForm());

        if (user.getId() != null)
            builder = builder.append("_id", new ObjectId(user.getId()));
        return builder.get();
    }


    public static User toUser(DBObject doc) {
        User user = new User();
        ObjectId id = (ObjectId) doc.get("_id");
        user.setId(id.toString());
        user.setName((String) doc.get(name));
        user.setSurname((String) doc.get(surname));
        user.setEmail((String) doc.get(email));
        user.setUserName((String) doc.get(username));
        user.setPassword((String) doc.get(password));
        user.setSalt((String) doc.get(encrypt_key));
        user.setPatientList((List<Paciente>) doc.get(patients));
        user.setAnalysisList((List<Analysis>) doc.get(analysis));
        return user;
    }

    public static DBObject toDBObjectFicheros(Ficheros ficheros) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append(filename, ficheros.getFilename())
                .append(metadata, ficheros.getMetadatos())
                .append(gridFS_file, ficheros.getGridFSInputFile());
        return builder.get();
    }

    public static DBObject toDBObjectMuestras(Muestras muestras) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append(sample_name, muestras.getNombre_Muestra())
                .append(metadata, muestras.getMetadatos())
                .append("sample_date", muestras.getFecha_Muestra())
                .append(gridFS_sample, muestras.getGridFS());

        return builder.get();
    }


    public static DBObject toDBObjectPatient(Paciente paciente) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append("_id", new ObjectId())
                .append(patient_information, paciente.getParameters())
                .append(files, paciente.getFicheros());
        return builder.get();
    }

    public static DBObject toDBObjectForm(Form form) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append("_id", new ObjectId())
                .append("attributes", form.getForm_attributes());
        return builder.get();
    }

    public static DBObject toDBObjectAnalysis(Analysis analysis) {

        BasicDBObjectBuilder builder = BasicDBObjectBuilder.start()
                .append("_id", new ObjectId())
                .append(analysis_name, analysis.getName_analysis())
                .append("result", analysis.getResult());
        return builder.get();
    }


}
