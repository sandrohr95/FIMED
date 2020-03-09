package es.uma.khaos.mongo.api.beans.service;

import java.io.BufferedReader;
import java.io.InputStreamReader;

public class MongoExport {

    public static void main(String[] args) {

        String db = "Agentes";
        String col = "Consumo_Total";
        String Host = "localhost";
        String Port = "27017";
        String fileName = "/home/khaosdev/Documentos/sample.json";
        String command_json = "mongoexport --host 192.168.43.98 --port 8084 --db Pacientes --collection Users --type=csv --fields pacientes.0._pacienteInformacion.Name,pacientes.0._pacienteInformacion.Code --out /home/khaosdev/Documentos/patients.csv";
        //String command_query = "mongoexport --host 192.168.43.98 --port 8084 --db Pacientes --collection Users --query '{"_id":ObjectId("5cd9483b1a7caa5253c0561f"),"pacientes._pacienteInformacion.Code":"11144"}' --out /home/khaosdev/Documentos/patients.json"
        String command = "mongoexport --host " + Host + " --port " + Port + " --db " + db + " --collection " + col + " --out " + fileName;

        try {
            System.out.println(command_json);
            Process process = Runtime.getRuntime().exec(command_json);
            int waitFor = process.waitFor();
            System.out.println("waitFor:: " + waitFor);
            BufferedReader success = new BufferedReader(new InputStreamReader(process.getInputStream()));
            BufferedReader error = new BufferedReader(new InputStreamReader(process.getErrorStream()));

            String s = "";
            while ((s = success.readLine()) != null) {
                System.out.println(s);
            }

            while ((s = error.readLine()) != null) {
                System.out.println("Std ERROR : " + s);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}


