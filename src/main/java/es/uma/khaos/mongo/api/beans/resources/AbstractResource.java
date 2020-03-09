package es.uma.khaos.mongo.api.beans.resources;

import java.util.List;

import javax.ws.rs.core.Application;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.*;
import es.uma.khaos.mongo.api.beans.response.*;
import es.uma.khaos.mongo.api.beans.model.ErrorResponse;
import es.uma.khaos.mongo.api.beans.response.JspResponseBuilder;
import es.uma.khaos.mongo.api.beans.response.PojoResponseBuilder;
import es.uma.khaos.mongo.api.beans.response.ResponseBuilder;

public class AbstractResource extends Application {

	protected ResponseBuilder getResponseBuilder(HttpHeaders headers, String jsp) {

		List<MediaType> acceptableTypes = headers.getAcceptableMediaTypes();
		if (acceptableTypes.contains(MediaType.TEXT_HTML_TYPE)) {
			return new JspResponseBuilder(jsp);
		} else {
			return new PojoResponseBuilder();
		}
	}

	protected Response internalServerError(ResponseBuilder builder) {

		return builder.buildResponse(new ErrorResponse(Response.Status.INTERNAL_SERVER_ERROR,
				"Internal server error. Please contact us for assistance."));

	}

}
