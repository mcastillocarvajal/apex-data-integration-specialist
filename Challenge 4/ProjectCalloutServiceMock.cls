public class ProjectCalloutServiceMock implements HttpCalloutMock{
    //Implement http mock callout here

    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(201);
        response.setStatus('OK');
        return response; 
    }
 }
