package es.uma.khaos.mongo.api.beans.model;

import java.util.List;
import java.util.Map;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement
public class Paciente {

	public String id;
    public Map<String, Object> parameters;
	public List<Ficheros> ficheros;
	public List<Muestras> muestras;

	public List<Ficheros> getFicheros() {
		return ficheros;
	}

	public void setFicheros(List<Ficheros> ficheros) {
		this.ficheros = ficheros;
	}

	public List<Muestras> getMuestras() {
		return muestras;
	}

	public void setMuestras(List<Muestras> muestras) {
		this.muestras = muestras;
	}

	public Paciente() {
		super();
	}

	public Paciente(String id, Map<String, Object> parameters) {
		super();
		this.id = id;
		this.parameters = parameters;
	}
	
	
	public Paciente(Map<String, Object> parameters) {
		super();
		this.parameters = parameters;
	}

	public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

	public Map<String, Object> getParameters() {
		return parameters;
	}

	public void setParameters(Map<String, Object> parameters) {
		this.parameters = parameters;
	}

	@Override
	public String toString() {
		return "Paciente{" +
				"id='" + id + '\'' +
				", parameters=" + parameters +
				", ficheros=" + ficheros +
				", muestras=" + muestras +
				'}';
	}
}