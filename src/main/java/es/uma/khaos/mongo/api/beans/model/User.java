package es.uma.khaos.mongo.api.beans.model;

import java.util.List;

public class User {

    private String id;
    private String name;
    private String surname;
    private String email;
    private String userName;
    private String password;
    private String salt;
    private List<Paciente> patientList;
    private List<Analysis> analysisList;
    private Form form;


    public User(String id, String name, String surname, String email, String userName, String password,
                List<Paciente> patientList) {
        super();
        this.id = id;
        this.name = name;
        this.surname = surname;
        this.email = email;
        this.userName = userName;
        this.password = password;
        this.patientList = patientList;
    }

    public User() {
        super();
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSurname() {
        return surname;
    }

    public void setSurname(String surname) {
        this.surname = surname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt;
    }

    public List<Paciente> getPatientList() {
        return patientList;
    }

    public void setPatientList(List<Paciente> patientList) {
        this.patientList = patientList;
    }

    public List<Analysis> getAnalysisList() {
        return analysisList;
    }

    public void setAnalysisList(List<Analysis> analysisList) {
        this.analysisList = analysisList;
    }

    public Form getForm() {
        return form;
    }

    public void setForm(Form form) {
        this.form = form;
    }



    @Override
    public String toString() {
        return "User [id=" + id + ", name=" + name + ", surname=" + surname + ", email=" + email + ", userName="
                + userName + ", password=" + password + ", patientList=" + patientList + "]";
    }

}

