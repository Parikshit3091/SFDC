public class TestInterface {
  public static string getType(Object o) {
    if(o==null) return '';              // we can't say much about null with our current techniques
    if(o instanceof SObject)            return ((SObject)o).getSObjectType().getDescribe().getName()+''; 
    if(o instanceof Boolean)            return 'Boolean';
    if(o instanceof Id)                 return 'Id';
    if(o instanceof String)             return 'String';
    if(o instanceof Blob)               return 'Blob';
    if(o instanceof Date)               return 'Date';
    if(o instanceof Datetime)           return 'Datetime';
    if(o instanceof Time)               return 'Time';
    if(o instanceof String)             return 'String';
    if(o instanceof Integer)            return 'Integer';
    if(o instanceof Long)               return 'Long';
    if(o instanceof Decimal)            return 'Decimal';  // we can't distinguish between decimal and double
    if(o instanceof Double)             return 'Double';   // we can't distinguish between decimal and double
    if(o instanceof List<object>)       return 'List';
    return 'Object';                    // actually we can't detect maps and sets and maps
  }
}