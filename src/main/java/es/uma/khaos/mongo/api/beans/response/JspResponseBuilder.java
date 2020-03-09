package es.uma.khaos.mongo.api.beans.response;

import javax.ws.rs.core.Response;
import org.glassfish.jersey.server.mvc.Viewable;

public class JspResponseBuilder implements ResponseBuilder {

	private String jspFile;

	public JspResponseBuilder(String jspFile) {
		this.jspFile = jspFile;
	}
	
	@Override
	public Response buildResponse(Object o) {
		return Response.ok(new Viewable(jspFile, o)).build();
	}

	@Override
	public Response buildResponse(Object o, Response.Status status) {
		return Response.status(status).entity(new Viewable(jspFile, o)).build();
	}

	@Override
	public Response buildCreatedResponse(Object o) {
		return Response.status(Response.Status.CREATED).entity(new Viewable(jspFile, o)).build();
	}

}
