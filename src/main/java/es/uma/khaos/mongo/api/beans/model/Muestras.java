package es.uma.khaos.mongo.api.beans.model;

import com.mongodb.gridfs.GridFSInputFile;

import java.util.Date;
import java.util.Map;


public class Muestras {

    public String id_Muestra;
    public String nombre_Muestra;
    public Date fecha_Muestra;
    public Map<String,Object> metadatos;
    public GridFSInputFile gridFS;

    public String getId_Muestra() {
        return id_Muestra;
    }

    public void setId_Muestra(String id_Muestra) {
        this.id_Muestra = id_Muestra;
    }

    public String getNombre_Muestra() {
        return nombre_Muestra;
    }

    public void setNombre_Muestra(String nombre_Muestra) {
        this.nombre_Muestra = nombre_Muestra;
    }

    public Date getFecha_Muestra() {
        return fecha_Muestra;
    }

    public void setFecha_Muestra(Date fecha_Muestra) {
        this.fecha_Muestra = fecha_Muestra;
    }

    public Map<String, Object> getMetadatos() {
        return metadatos;
    }

    public void setMetadatos(Map<String, Object> metadatos) {
        this.metadatos = metadatos;
    }

    public GridFSInputFile getGridFS() {
        return gridFS;
    }

    public void setGridFS(GridFSInputFile gridFS) {
        this.gridFS = gridFS;
    }

    @Override
    public String toString() {
        return "Muestras{" +
                "id_Muestra='" + id_Muestra + '\'' +
                ", nombre_Muestra='" + nombre_Muestra + '\'' +
                ", fecha_Muestra=" + fecha_Muestra +
                ", metadatos=" + metadatos +
                ", gridFS=" + gridFS +
                '}';
    }
}