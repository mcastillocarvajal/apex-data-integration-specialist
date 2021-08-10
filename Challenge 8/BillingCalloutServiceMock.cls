
global class BillingCalloutServiceMock implements WebServiceMock {

    global void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        BillingServiceProxy.billProjectResponse_element res = new BillingServiceProxy.billProjectResponse_element();
        res.status = 'OK';
        res.put('response_x', res);
    }
}
