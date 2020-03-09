package es.uma.khaos.mongo.api.beans.model;
import java.util.Map;
import javax.xml.bind.annotation.XmlRootElement;


@XmlRootElement
public class Form {
    public Map<String, Object> getForm_attributes() {
        return form_attributes;
    }

    public void setForm_attributes(Map<String, Object> form_attributes) {
        this.form_attributes = form_attributes;
    }

    public Map<String, Object> form_attributes;
}
