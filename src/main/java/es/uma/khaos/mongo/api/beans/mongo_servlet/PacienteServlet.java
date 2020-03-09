package es.uma.khaos.mongo.api.beans.mongo_servlet;

import es.uma.khaos.mongo.api.beans.dao.PacienteDao;
import es.uma.khaos.mongo.api.beans.model.StandardResponse;
import es.uma.khaos.mongo.api.beans.model.ErrorResponse;
import es.uma.khaos.mongo.api.beans.model.Paciente;
import es.uma.khaos.mongo.api.beans.resources.AbstractResource;
import es.uma.khaos.mongo.api.beans.exceptions.PythonException;

import java.io.*;
import java.text.NumberFormat;
import java.util.*;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.*;
import javax.ws.rs.core.*;


import es.uma.khaos.mongo.api.beans.response.ResponseBuilder;
import org.apache.log4j.Logger;
import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;

import javax.servlet.http.HttpSession;

import es.uma.khaos.mongo.api.beans.model.User;
import es.uma.khaos.mongo.api.beans.service.Database;
import es.uma.khaos.mongo.api.beans.service.Encrypt;


@Path("/")
public class PacienteServlet extends AbstractResource {

    private final String dendrogramCommand = "run-Dendrogram.sh";
    private final String clusterHeatmapCommand = "run-Mongoclustermaps.sh";
    private final String geneRegNetworkCommand = "run-MongoGRN.sh";

//	private static final String Upload_location_folder = "/home/antonio/Documents/Uploads/";
//	private static final String Download_location_folder = "/home/antonio/Documents/Downloads/";

    private static final String Upload_location_folder = "/root/App/uploadfiles/";
    private static final String Download_location_folder = "/root/App/downloadfiles/";

    @Context
    private ServletContext context;

    @POST
    @Path("/login")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response loginPost(@FormDataParam("password") String psw, @FormDataParam("username") String username,
                              @Context HttpHeaders headers, @Context UriInfo uriInfo, @Context HttpSession session,
                              @Context HttpServletRequest request) {
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");
        ResponseBuilder errorNotFilled = getResponseBuilder(headers, "/errorNotFilled.jsp");

        try {

            if (username == null || psw == null || username.equals("") || psw.equals("")) {

                return internalServerError(errorNotFilled);

            } else {

                boolean isUserFound = Database.searchUserInDb(username, psw);
                if (isUserFound) {
                    ResponseBuilder builder = getResponseBuilder(headers, "/home.jsp");// To
                    return createRespondeIntro(builder, errorBuilder, uriInfo);

                } else {
                    return Response
                            .ok("error_message: You are not an authorised user. Please check with administrator.")
                            .build();
                }

            }
        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    // Create Response
    private Response createRespondeIntro(ResponseBuilder builder, ResponseBuilder errorBuilder, UriInfo uriInfo) {

        try {

            Object o = new StandardResponse(Response.Status.CREATED, "");
            return builder.buildCreatedResponse(o);

        } catch (Exception e) {
            e.printStackTrace();

            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }

    }

    @POST
    @Path("/register")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response registerPost(@FormDataParam("name") String name, @FormDataParam("apellidos") String apellidos,
                                 @FormDataParam("email") String email, @FormDataParam("username") String username,
                                 @FormDataParam("password") String psw, @Context HttpHeaders headers, @Context UriInfo uriInfo) {

        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");
        ResponseBuilder registerNotFilled = getResponseBuilder(headers, "/errorRegisterNotFilled.jsp");
        ResponseBuilder errorExistUsername = getResponseBuilder(headers, "/errorExistUsername.jsp");
        ArrayList<Paciente> pacientes = new ArrayList<Paciente>();

        try {

            if ((name.equals("") || name == null) || (email.equals("") || email == null)
                    || (apellidos.equals("") || apellidos == null) || (username.equals("") || username == null)
                    || (psw.equals("") || psw == null)) {

                return internalServerError(registerNotFilled);

            } else {

                User user = new User();
                user.setName(name);
                user.setSurname(apellidos);
                user.setEmail(email);
                user.setUserName(username);

                //User password Encryption
                Encrypt encrypt = new Encrypt();
                String salt = encrypt.getSalt(32);
                String password = encrypt.generateSecurePassword(psw, salt);
                user.setSalt(salt);
                user.setPassword(password);
                user.setPatientList(pacientes);

                boolean repetedUsername = Database.searchUsername(username);
                if (repetedUsername) {
                    return internalServerError(errorExistUsername);
                } else {
                    ResponseBuilder builder = getResponseBuilder(headers, "/registrationCompleted.jsp");
                    return createResponseRegister(user, builder, errorBuilder, uriInfo);
                }

            }
        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    // Create Response
    private Response createResponseRegister(User user, ResponseBuilder builder, ResponseBuilder errorBuilder,
                                            UriInfo uriInfo) {
        try {
            if (user == null) {

                return errorBuilder
                        .buildResponse(new ErrorResponse(Response.Status.EXPECTATION_FAILED, "Something has failed."));
            } else {

                PacienteDao pacienteDao = new PacienteDao();
                pacienteDao.createUser(user);
                Object o = new StandardResponse(Response.Status.CREATED, "");
                return builder.buildCreatedResponse(o);

            }

        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    private void writeToFile(InputStream fichero,
                             String uploadedFileLocation) {
        try {
            FileOutputStream out = new FileOutputStream(new File(
                    uploadedFileLocation));
            int read = 0;
            byte[] bytes = new byte[1024];

            out = new FileOutputStream(new File(uploadedFileLocation));
            while ((read = fichero.read(bytes)) != -1) {
                out.write(bytes, 0, read);
            }
            out.close();
        } catch (IOException e) {

            e.printStackTrace();
        }
    }

    @POST
    @Path("/formDesign")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response insertField(
            @FormDataParam("id") String id,
            @FormDataParam("keys") List<String> keys,
            @FormDataParam("values") List<String> values,
            @FormDataParam("subkeys1") List<String> subkeys1,
            @FormDataParam("subsubkeys1") List<String> subsubkeys1,
            @FormDataParam("subsubvalues1") List<String> subsubvalues1,
            @FormDataParam("subkeys2") List<String> subkeys2,
            @FormDataParam("subsubkeys2") List<String> subsubkeys2,
            @FormDataParam("subsubvalues2") List<String> subsubvalues2,
            @FormDataParam("deletefields") List<String> deletefields,
            @FormDataParam("typeForm") String typeForm,
            @Context HttpHeaders headers,
            @Context UriInfo uriInfo) {

        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");
        ResponseBuilder idNotExist = getResponseBuilder(headers, "/idNotExistForm.jsp");
        ResponseBuilder builder = getResponseBuilder(headers,"");

        if(typeForm.equals("design"))
        {
            builder = getResponseBuilder(headers, "/designFormResponse.jsp");

        }else if(typeForm.equals("update"))
        {
            builder = getResponseBuilder(headers, "/updateFormResponse.jsp");
        }
        try {

            boolean findId = Database.searchID(id);

            if (findId) {

                User user = Database.searchUserDbById(id);
                return formDesign(user, builder, errorBuilder, keys, values, subkeys1,
                        subsubkeys1, subsubvalues1, subkeys2,
                        subsubkeys2, subsubvalues2,deletefields);

            } else {

                return internalServerError(idNotExist);
            }

        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    private Response formDesign(User user, ResponseBuilder builder, ResponseBuilder errorBuilder,
                                List<String> keys, List<String> values, List<String> subkeys1, List<String> subsubkeys1,
                                List<String> subsubvalues1, List<String> subkeys2, List<String> subsubkeys2, List<String> subsubvalues2,List<String> deleteFields) {
        try {
            if (user == null) {

                return errorBuilder
                        .buildResponse(new ErrorResponse(Response.Status.EXPECTATION_FAILED, "Something has failed."));

            } else {

                Map<String, Object> parameters = createMap(keys,values);
                Map<String, Object> subparameters1 = createSubMap(subkeys1, createMap(subsubkeys1,subsubvalues1));
                Map<String, Object> subparameters2 = createSubMap(subkeys2, createMap(subsubkeys2,subsubvalues2));

                parameters.putAll(subparameters1);
                parameters.putAll(subparameters2);

                PacienteDao pacienteDao = new PacienteDao();
                pacienteDao.design_form(parameters, user,deleteFields);

                Object o = new StandardResponse(Response.Status.CREATED, "");
                return builder.buildCreatedResponse(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    @POST
    @Path("/crearPaciente")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response insertField(
            @FormDataParam("id") String id,
            @FormDataParam("id_pac") String id_pac,
            @FormDataParam("keys") List<String> keys,
            @FormDataParam("values") List<String> values,
            @FormDataParam("keystype") List<String> keystype,
            @FormDataParam("subkeystype") List<String> subkeystype,
            @FormDataParam("subkeys1") List<String> subkeys1,
            @FormDataParam("subsubkeys1") List<String> subsubkeys1,
            @FormDataParam("subsubvalues1") List<String> subsubvalues1,
            @FormDataParam("subsubkeys1type") List<String> subsubkeys1type,
            @FormDataParam("subkeys2") List<String> subkeys2,
            @FormDataParam("subsubkeys2") List<String> subsubkeys2,
            @FormDataParam("subsubvalues2") List<String> subsubvalues2,
            @FormDataParam("subsubkeys2type") List<String> subsubkeys2type,
            @FormDataParam("MetadataKey") List<String> metadatakey,
            @FormDataParam("Metadatavalue") List<String> metadatavalue,
            @FormDataParam("MetaSampleKey") List<String> metasamplekey,
            @FormDataParam("MetaSamplevalue") List<String> metasamplevalue,
            @FormDataParam("deletefields") List<String> deletefields,
            @FormDataParam("deleteficheros") List<String> deleteficheros,
            @FormDataParam("deletemuestras") List<String> deletemuestras,
            @FormDataParam("fichero") final InputStream fichero,
            @FormDataParam("fichero") final FormDataContentDisposition fileDetails,
            @FormDataParam("muestra") final InputStream muestra,
            @FormDataParam("muestra") final FormDataContentDisposition sampledetails,
            @Context HttpHeaders headers,
            @Context UriInfo uriInfo) {

        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");
        ResponseBuilder errorNotFilledInsert = getResponseBuilder(headers, "/errorNotFilledInserted.jsp");
        ResponseBuilder idNotExist = getResponseBuilder(headers, "/idNotExistForm.jsp");
        ResponseBuilder builder = getResponseBuilder(headers, "/createPatientResponse.jsp");

        try {

            String samplename = sampledetails.getFileName();
            String filename = fileDetails.getFileName();
            String uploadedFileLocation = Upload_location_folder + filename;
            String uploadedMuestraLocation = Upload_location_folder + samplename;

            // Guardamos los ficheros y muestras en un directorio local
            if (!"".equals(filename)) {
                writeToFile(fichero, uploadedFileLocation);
            }

            if (!"".equals(samplename)) {
                writeToFile(muestra, uploadedMuestraLocation);
            }

            if (Arrays.asList(keys).equals("") && Arrays.asList(values).equals("") || Arrays.asList(keys).isEmpty()) {

                return internalServerError(errorNotFilledInsert);

            } else {

                boolean findId = Database.searchID(id);

                if (findId) {

                    User user = Database.searchUserDbById(id);
                    return createResponseSubInsertUpdate(user, id_pac, builder, errorBuilder, uriInfo, keys, values, keystype,subkeystype, subkeys1,
                            subsubkeys1, subsubvalues1, subsubkeys1type, subkeys2,
                            subsubkeys2, subsubvalues2, subsubkeys2type, filename, samplename, metadatakey, metadatavalue, deletefields, deleteficheros, deletemuestras, metasamplekey, metasamplevalue);

                } else {

                    return internalServerError(idNotExist);
                }
            }
        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }


    private Response createResponseSubInsertUpdate(User user, String id_pac, ResponseBuilder builder, ResponseBuilder errorBuilder,
                                                   UriInfo uriInfo, List<String> keys, List<String> values, List<String> keys_type,List<String> sub_keys_type, List<String> sub_keys1,
                                                   List<String> sub_sub_keys1, List<String> sub_sub_values1, List<String> sub_keys_type1, List<String> sub_keys2, List<String> sub_sub_keys2,
                                                   List<String> sub_sub_values2, List<String> sub_keys_type2, String filename, String sample_name, List<String> metadata_file_key,
                                                   List<String> metadata_file_value, List<String> delete_fields, List<String> delete_files, List<String> delete_samples,
                                                   List<String> metadata_sample_key, List<String> metadata_sample_value) {

        try {

            if (user == null) {

                return errorBuilder
                        .buildResponse(new ErrorResponse(Response.Status.EXPECTATION_FAILED, "Something has failed."));

            } else {
                PacienteDao pacienteDao = new PacienteDao();
                Database database = new Database();

                //Here we should find the encrypt salt of the user by the ID
                String encrypt_key = database.get_encrypted_salt(user.getId());
                //Encrypt data Fields before insert in the database
                List<String> encrypt_values = pacienteDao.field_encryption(values,encrypt_key);
                List<String> encrypt_sub_values1 = pacienteDao.field_encryption(sub_sub_values1,encrypt_key);
                List<String> encrypt_sub_values2 = pacienteDao.field_encryption(sub_sub_values2,encrypt_key);
               // List<String> encrypt_metadata_file = pacienteDao.field_encryption(metadata_file_value,"WPZGS5TYJGr9MtcsGOOTUlMw");
               // List<String> encrypt_metadata_sample = pacienteDao.field_encryption(metadata_sample_value,"WPZGS5TYJGr9MtcsGOOTUlMw");

                // create Map with simple fields
                Map<String, Object> parameters = createMap(keys,encrypt_values);

                // This Map store Map fields and the list of types values
                Map<Object, Object> parametersType = new LinkedHashMap<>();

                Map<String, Object> sub_parameters1 = createMap(sub_sub_keys1, encrypt_sub_values1);
                Map<String, Object> sub_parameters2 = createMap(sub_sub_keys2, encrypt_sub_values2);

                parameters.putAll(createSubMapType(sub_keys1, sub_parameters1, sub_keys_type1));
                parameters.putAll(createSubMapType(sub_keys2, sub_parameters2, sub_keys_type2));

                keys_type.addAll(sub_keys_type);
                parametersType.put(parameters,keys_type);

                Map<String, Object> MetadataDocument = MetadataMap(metadata_file_key, metadata_file_value);
                Map<String, Object> MetadataSamples = MetadataMap(metadata_sample_key, metadata_sample_value);

                if (id_pac == null || "".equals(id_pac)) {
                    pacienteDao.createPatientByUser(parametersType, MetadataDocument, MetadataSamples, user, filename, sample_name);
                } else {
                    pacienteDao.insertUpdatePatients(user, id_pac, MetadataDocument, MetadataSamples, parametersType, delete_fields, filename, sample_name, delete_files, delete_samples);
                }

                Object o = new StandardResponse(Response.Status.CREATED, "");
                return builder.buildCreatedResponse(o);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    // Method to create Map from list of keys and values
    private Map<String, Object> createMap(List<String> keys, List<String> values)
    {
        Map<String, Object> parameters = new LinkedHashMap<>();
        Iterator<String> iteratorSubSubKey = keys.iterator();
        Iterator<String> iteratorSubSubValues = values.iterator();

        while (iteratorSubSubKey.hasNext() && iteratorSubSubValues.hasNext()) {

            parameters.put(iteratorSubSubKey.next(), iteratorSubSubValues.next());
        }

        return parameters;
    }

    private Map<String, Object> createSubMap(List<String> subkeys, Map<String, Object> parameters) {

        Map<String, Object> compoundField = new LinkedHashMap<>();

        Iterator<String> iteratorSubkeys = subkeys.iterator();

        while (iteratorSubkeys.hasNext()) {

            compoundField.put(iteratorSubkeys.next(), parameters);
        }
        return compoundField;
    }

    // create a compound field and indicate a list of types
    private Map<String, Object> createSubMapType(List<String> subkeys, Map<String, Object> parameters , List<String> subkeystype) {

        Map<String, Object> compoundField = new LinkedHashMap<>();
        Map<Object, Object> parametersType = new LinkedHashMap<>();

        Iterator<String> iteratorSubkeys = subkeys.iterator();
        parametersType.put(parameters,subkeystype);

        while (iteratorSubkeys.hasNext()) {

            compoundField.put(iteratorSubkeys.next(), parametersType);
        }
        return compoundField;
    }

    private Map<String, Object> MetadataMap(List<String> metadatakey, List<String> metadatavalue) {
        Iterator<String> iteratormetadatakey = metadatakey.iterator();
        Iterator<String> iteratormetadavalue = metadatavalue.iterator();
        Map<String, Object> MetadataDocument = new HashMap<>();

        while (iteratormetadatakey.hasNext() && iteratormetadavalue.hasNext()) {

            MetadataDocument.put(iteratormetadatakey.next(), iteratormetadavalue.next());

        }

        return MetadataDocument;
    }

    @GET
    @Path("/deletePatient")
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response deletePatient(@QueryParam("id") String id_user, @QueryParam("id_pac") String id_pac,
                                  @Context HttpHeaders headers, @Context UriInfo uriInfo) {

        ResponseBuilder builder = getResponseBuilder(headers, "/deleteResponse.jsp");
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");

        return CreateResponseDeletePatient(id_user, id_pac, builder, errorBuilder, uriInfo);
    }

    private Response CreateResponseDeletePatient(String id_user, String id_pac, ResponseBuilder builder, ResponseBuilder errorBuilder,
                                                 UriInfo uriInfo) {
        try {

            if (id_user == null) {

                return errorBuilder
                        .buildResponse(new ErrorResponse(Response.Status.EXPECTATION_FAILED, "Something has failed."));
            } else {
                PacienteDao pacienteDao = new PacienteDao();
                pacienteDao.delete_patient(id_user, id_pac);

                Object o = new StandardResponse(Response.Status.CREATED, "");
                return builder.buildCreatedResponse(o);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    @GET
    @Path("/download")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response downloadFilebyPath(@QueryParam("id") String id_user, @QueryParam("id_pac") String id_pac, @QueryParam("filename") String fileName,
                                       @Context HttpHeaders headers,
                                       @Context UriInfo uriInfo) {
        ResponseBuilder builder = getResponseBuilder(headers, "/createPatientResponse.jsp");
        String type = "Files";

        return download(id_user, id_pac, fileName, type, headers, uriInfo, builder);
    }

    @GET
    @Path("/downloadSample")
    @Produces(MediaType.APPLICATION_OCTET_STREAM)
    public Response downloadSamplebyPath(@QueryParam("idUser") String id_user, @QueryParam("idPaciente") String id_pac, @QueryParam("Sample") String fileName,
                                         @Context HttpHeaders headers,
                                         @Context UriInfo uriInfo) {
        ResponseBuilder builder = getResponseBuilder(headers, "/createPatientResponse.jsp");

        String type = "Clinical_Samples";

        return download(id_user, id_pac, fileName, type, headers, uriInfo, builder);

    }

    private Response download(String id_user, String id_pac, String fileName, String type, HttpHeaders headers, UriInfo uriInfo, ResponseBuilder builder) {

        Logger logger = Logger.getLogger(PacienteServlet.class);

        String FILE_FOLDER = Download_location_folder;
        String fileLocation = FILE_FOLDER + fileName;

        PacienteDao pacienteDao = new PacienteDao();
        //Borramos archivos previamente descargados en nuestro directorio local
        pacienteDao.deleteLocalFiles(FILE_FOLDER);
        //Primero descargamos el documento de Mongo a un directorio Local
        pacienteDao.download_file_from_mongodb(fileName, type, id_user, id_pac);

        Response response = null;
        NumberFormat myFormat = NumberFormat.getInstance();
        myFormat.setGroupingUsed(true);

        // Retrieve the file
        File file = new File(FILE_FOLDER + fileName);
        if (file.exists() && file.isFile()) {
            builder.buildResponse(file);
            //En el caso que exista el documento en el directorio lo descargaremos

            return Response.ok(file).build();

        } else {
            logger.error(String.format("Inside downloadFile==> FILE NOT FOUND: fileName: %s",
                    fileName));

            response = Response.status(404).
                    entity("FILE NOT FOUND: " + fileLocation).
                    type("text/plain").
                    build();
            return response;
        }
    }

    @POST
    @Path("/pacientByParameter")
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response PacienteByParameter(
            @QueryParam("id") String id,
            @QueryParam("kparameter") String kparameter,
            @QueryParam("vparameter") String vparameter,
            @Context HttpHeaders headers,
            @Context UriInfo uriInfo,
            @Context HttpServletResponse response) {

        ResponseBuilder errorId = getResponseBuilder(headers, "/errorResponseId.jsp");
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResonse.jsp");
        ResponseBuilder errorNotFilledInsert = getResponseBuilder(headers, "/errorNotFilledInserted.jsp");
        ResponseBuilder errorBuilderPacient = getResponseBuilder(headers, "/errorBuilderPacient.jsp");

        try {
            if ((kparameter == null || "".equals(kparameter))
                    || (vparameter == null || "".equals(vparameter))) {
                return internalServerError(errorNotFilledInsert);

            } else {
                ResponseBuilder builder = getResponseBuilder(headers, "/pacientes.jsp");
                return getPacientByParameterResponse(id, kparameter, vparameter, builder, errorBuilderPacient, errorId, errorBuilder, uriInfo, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    private Response getPacientByParameterResponse(String id, String kparameter, String vparameter,
                                                   ResponseBuilder builder, ResponseBuilder errorBuilderPacient, ResponseBuilder errorBuilder, ResponseBuilder errorId, UriInfo uriInfo, HttpServletResponse response) {

        try {
            if (id == null) {

                return internalServerError(errorId);

            } else {

                PacienteDao pacienteDao = new PacienteDao();
                User user = pacienteDao.find_user_patient_by_parameter(id, kparameter, vparameter);
                System.out.println(user);

                if (user.getPatientList().isEmpty()) {

                    return internalServerError(errorBuilderPacient);
                }

                return builder.buildResponse(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    @POST
    @Path("/AllPacientes")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response AllPacientes(@FormDataParam("id") String id,
                                 @Context HttpHeaders headers, @Context UriInfo uriInfo) {
        ResponseBuilder errorId = getResponseBuilder(headers, "/errorResponseId.jsp");
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResonse.jsp");

        ResponseBuilder IdNotExist = getResponseBuilder(headers, "/IdNotExist.jsp");

        try {
            ResponseBuilder builder = getResponseBuilder(headers, "/pacientes.jsp");
            return getAllPacientesResponse(id, builder, errorId, errorBuilder, uriInfo);

        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    private Response getAllPacientesResponse(String id, ResponseBuilder builder, ResponseBuilder errorBuilder, ResponseBuilder errorId, UriInfo uriInfo) {

        try {
            if (id == null) {

                return internalServerError(errorId);

            } else {

                PacienteDao pacienteDao = new PacienteDao();

                User user = pacienteDao.find_user_all_patients(id);
                return builder.buildResponse(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }

    @GET
    @Path("/PacienteByID")
    @Consumes(MediaType.MULTIPART_FORM_DATA)
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response PacienteByID(
            @QueryParam("id") String id,
            @QueryParam("idP") String idP,
            @Context HttpHeaders headers, @Context UriInfo uriInfo) {

        ResponseBuilder errorId = getResponseBuilder(headers, "/errorResponseId.jsp");
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResonse.jsp");
        ResponseBuilder errorBuilderPacient = getResponseBuilder(headers, "/errorBuilderPacient.jsp");
        ResponseBuilder errorNotFilledInsert = getResponseBuilder(headers, "/errorNotFilledInserted.jsp");


        try {
            if (idP == null || "".equals(idP)) {
                return internalServerError(errorNotFilledInsert);

            } else {

                // Search idP in the database para ver si existe
                ResponseBuilder builder = getResponseBuilder(headers, "/pacientes.jsp");
                return getPacienteByIDResponse(id, idP, builder, errorId, errorBuilder, errorBuilderPacient,
                        uriInfo);

            }
        } catch (Exception e) {

            e.printStackTrace();
            return internalServerError(errorBuilder);
        }
    }

    private Response getPacienteByIDResponse(String id, String idP, ResponseBuilder builder,
                                             ResponseBuilder errorBuilder, ResponseBuilder errorId, ResponseBuilder errorBuilderPacient, UriInfo uriInfo) {
        try {

            if (id == null) {

                return internalServerError(errorId);

            } else {

                PacienteDao pacienteDao = new PacienteDao();
                try {
                    User user = pacienteDao.find_patient_by_id(id, idP);
                    return builder.buildResponse(user);

                } catch (Exception e) {
                    e.printStackTrace();
                    return internalServerError(errorBuilderPacient);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }
    }
///////////////////////////// ANALYSIS PAGE //////////////////////////////////
    
    @GET
    @Path("/service/dendrogramHeatmap")
    @Produces({MediaType.TEXT_PLAIN})
    public Response dendrogram(
            @QueryParam(value = "id[]") List<String> ids,
            @QueryParam(value = "label[]") List<String> labels,
            @QueryParam(value = "percentage") double percentage,
            @QueryParam(value = "name_analysis") String name_analysis,
            @Context HttpServletRequest request,
            @Context HttpHeaders headers) throws Exception {

        System.out.println("PARÁMETROS DENDROGRAM");
        System.out.println(ids);
        System.out.println(labels);
        System.out.println(percentage);

        Properties props = new Properties();
        props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
        String scriptDirectory = props.getProperty("scripts.directory");

        System.out.println(scriptDirectory + dendrogramCommand);

        String[] cmd = new String[]{
                scriptDirectory + dendrogramCommand,
                formatStringListToPython(ids).replaceAll(" ", ""),
                formatStringListToPython(labels).replaceAll(" ", ""),
                String.format(Locale.US, "%.2f", percentage)
        };

        return getPythonGeneratedHTML(cmd,name_analysis, request, headers);
    }

    @GET
    @Path("/service/cluster_heatmap")
    @Produces({MediaType.TEXT_PLAIN})
    public Response getHeatmap(
            @QueryParam(value = "id[]") List<String> ids,
            @QueryParam(value = "label[]") List<String> labels,
            @QueryParam(value = "percentage") double percentage,
            @QueryParam(value = "name_analysis") String name_analysis,
            @Context HttpServletRequest request,
            @Context HttpHeaders headers) throws Exception {

        System.out.println("PARÁMETROS");
        System.out.println(ids);
        System.out.println(labels);
        System.out.println(percentage);
        System.out.println(name_analysis);

        Properties props = new Properties();
        props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
        String scriptDirectory = props.getProperty("scripts.directory");

        System.out.println(scriptDirectory + clusterHeatmapCommand);

        String[] cmd = new String[]{
                scriptDirectory + clusterHeatmapCommand,
                formatStringListToPython(ids).replaceAll(" ", ""),
                formatStringListToPython(labels).replaceAll(" ", ""),
                String.format(Locale.US, "%.2f", percentage)
        };


        return getPythonGeneratedHTML(cmd,name_analysis, request, headers);

    }

    @GET
    @Path("/service/gene_regulatory_network")
    @Produces({MediaType.TEXT_PLAIN})
    public Response getGeneRegNetwork(
            @QueryParam(value = "id[]") List<String> ids,
            @QueryParam(value = "label[]") List<String> labels,
            @QueryParam(value = "percentage1") double percentage1,
            @QueryParam(value = "max_links") double maxLinks,
            @QueryParam(value = "configuration") int configuration,
            @QueryParam(value = "name_analysis") String name_analysis,
            @Context HttpServletRequest request,
            @Context HttpHeaders headers) throws Exception {

        System.out.println("PARÁMETROS1");
        System.out.println(ids);
        System.out.println(labels);
        System.out.println(percentage1);
        System.out.println(maxLinks);
        System.out.println(configuration);
        //FIJAMOS LA CONFIGURACION DE LA RED A GRNBOOST2 POR AHORA
        //int network = 2;

        Properties props = new Properties();
        props.load(Thread.currentThread().getContextClassLoader().getResourceAsStream("mongodb.properties"));
        String scriptDirectory = props.getProperty("scripts.directory");

        System.out.println(scriptDirectory + geneRegNetworkCommand);

        String[] cmd = new String[]{
                scriptDirectory + geneRegNetworkCommand,
                formatStringListToPython(ids).replaceAll(" ", ""),
                formatStringListToPython(labels).replaceAll(" ", ""),
                String.format(Locale.US, "%.2f", percentage1),
                String.valueOf(maxLinks),
                String.valueOf(configuration)
//                String.valueOf(network)
        };
        return getPythonGeneratedHTML(cmd,name_analysis, request, headers);
    }

    private Response getPythonGeneratedHTML(String[] cmd, String name_analysis, HttpServletRequest request, HttpHeaders headers) {

        HttpSession session = request.getSession();
        String idUser = (String) session.getAttribute("userId");

        try {

            String htmlpath = executeCommand(cmd, headers);

            if (!"".equals(name_analysis) && name_analysis != null && name_analysis.length() != 0 && !"".equals(htmlpath) && htmlpath != null)
            {
                Database database =  new Database();
                database.saveAnalysis(idUser, htmlpath, name_analysis);
            }
            System.out.println("HTMLPATH: " + htmlpath);
            return Response.ok(htmlpath).build();

        } catch (Exception e) {
            e.printStackTrace();
            return Response.serverError().build();

        }
    }

    private String executeCommand(String[] command, HttpHeaders headers) throws IOException, PythonException {

        int lines = 0;
        String line, ret = "";
        Process p = Runtime.getRuntime().exec(command);

        BufferedReader stdInput = new BufferedReader(new InputStreamReader(
                p.getInputStream()));

        BufferedReader stdError = new BufferedReader(new InputStreamReader(
                p.getErrorStream()));

        ret = stdInput.readLine();

        while ((line = stdInput.readLine()) != null) {
            ret += "\n" + line;
            lines++;
        }
        System.out.println(ret);
        System.out.println("COMMAND ERROR:");
        while ((line = stdError.readLine()) != null) {
            System.out.println(line);
        }
        stdError.close();
        stdInput.close();

        return ret;
    }

    private String formatStringListToPython(List<String> list) {
        return list.toString().replaceAll("\\[", "\\[\'").replaceAll("\\]", "\'\\]").replaceAll(", ", "\', \'");
    }


    @GET
    @Path("/delete_analysis")
    @Produces({MediaType.TEXT_HTML, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
    public Response delete_analysis(@QueryParam("id") String id_user, @QueryParam("id_analysis") String id_analysis,
                                  @Context HttpHeaders headers, @Context UriInfo uriInfo) {

        ResponseBuilder builder = getResponseBuilder(headers, "/deleteAnalysisResponse.jsp");
        ResponseBuilder errorBuilder = getResponseBuilder(headers, "/errorResponse.jsp");


        return createResponse_delete_analysis(id_user, id_analysis, builder, errorBuilder, uriInfo);
    }

    private Response createResponse_delete_analysis(String id_user, String id_analysis, ResponseBuilder builder, ResponseBuilder errorBuilder,
                                                 UriInfo uriInfo) {
        try {

            if (id_user == null) {

                return errorBuilder
                        .buildResponse(new ErrorResponse(Response.Status.EXPECTATION_FAILED, "Something has failed."));

            } else {

                Database database = new Database();
                database.delete_analysis(id_user,id_analysis);

                Object o = new StandardResponse(Response.Status.CREATED, "");
                return builder.buildCreatedResponse(o);

            }
        } catch (Exception e) {
            e.printStackTrace();
            return errorBuilder.buildResponse(
                    new ErrorResponse(Response.Status.NOT_ACCEPTABLE, "Please, contact with the administrator."));
        }

    }


}





