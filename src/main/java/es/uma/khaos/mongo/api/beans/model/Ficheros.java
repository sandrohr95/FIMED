package es.uma.khaos.mongo.api.beans.model;

import com.mongodb.gridfs.GridFSInputFile;
import java.util.Map;

public class Ficheros {

    private String filename;
    public Map<String,Object> metadatos;
    private GridFSInputFile gridFS;


    public String getFilename() {
        return filename;
    }

    public void setFilename(String filename) {
        this.filename = filename;
    }

    public Map<String, Object> getMetadatos() {
        return metadatos;
    }

    public void setMetadatos(Map<String, Object> metadatos) {
        this.metadatos = metadatos;
    }

    public GridFSInputFile getGridFSInputFile() {
        return gridFS;
    }

    public void setGridFSInputFile(GridFSInputFile gridFSInputFile) {
        this.gridFS = gridFSInputFile;
    }

    @Override
    public String toString() {
        return "Ficheros{" +
                "filename='" + filename + '\'' +
                ", metadatos=" + metadatos +
                ", gridFSInputFile=" + gridFS +
                '}';
    }
}