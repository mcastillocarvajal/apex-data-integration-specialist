public class ProjectCalloutServiceMockFailure implements HttpCalloutMock{
    //Implement http mock callout failure here 

    public HTTPResponse respond(HTTPRequest request) {
        // Create a fake response
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(500);
        response.setStatus('TRY AGAIN');
        return response; 
    }
 }
