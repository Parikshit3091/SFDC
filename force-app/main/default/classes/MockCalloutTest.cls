@isTest
global class MockCalloutTest implements HttpCalloutMock{

    global HttpResponse respond(HttpRequest req){
        
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('animals')){
            res.setStatusCode(200);
            System.debug('executing mock');
            res.setBody('{"animals":["majestic badger","fluffy bunny","scary bear","chicken"]}');
        }
        return res;
    }
}