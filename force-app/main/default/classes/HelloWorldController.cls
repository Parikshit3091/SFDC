public class HelloWorldController {

    public Map<String, integer> sum(integer i1, integer i2){
		integer i = i1;
		integer j = i2;
		integer k = i + j;
        Map<String, integer> keysMap = new Map<String, integer>();
        keysMap.put('abc', k);
		return keysMap;
	}


	public void result(){
		Map<String, integer> k = sum(10,20);
		System.debug('k ##' + k.get('abc'));
		
		
	}
}