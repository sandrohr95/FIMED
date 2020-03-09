package es.uma.khaos.mongo.api.beans.model;

import javax.ws.rs.core.Response.Status;
import javax.xml.bind.annotation.XmlRootElement;

@XmlRootElement
public class StandardResponse {

	private Status statusCode;
	private String message;
	private String url;

	public StandardResponse() {
		super();
	}

	public StandardResponse(Status statusCode, String message) {
		super();
		this.statusCode = statusCode;
		this.message = message;
	}

	public StandardResponse(Status statusCode, String message, String url) {
		this(statusCode, message);
		this.url = url;
	}
	
	public Status getStatusCode() {
		return statusCode;
	}

	public String getMessage() {
		return message;
	}
	
	public String getUrl() {
		return url;
	}

	public void setStatusCode(Status statusCode) {
		this.statusCode = statusCode;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public void setUrl(String url) {
		this.url = url;
	}
	
}
