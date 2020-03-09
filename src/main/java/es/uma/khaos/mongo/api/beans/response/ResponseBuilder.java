package es.uma.khaos.mongo.api.beans.response;

import javax.ws.rs.core.Response;

public interface ResponseBuilder {

	public Response buildResponse(Object o, Response.Status status);

	public Response buildResponse(Object o);

	public Response buildCreatedResponse(Object o);

}
