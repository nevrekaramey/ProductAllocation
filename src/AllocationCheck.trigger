trigger AllocationCheck on ProductAllocation__c (after update) {

    Set<Id> childProductId = new Set<Id>();
    Set<Id> parentID = new Set<Id>();
    Set<Id> parentProductId = new Set<Id>();
    Map<Id, Double> values = new Map<Id, Double>();
    
    for(ProductAllocation__c pa : Trigger.new){
        parentID.add(pa.ParentProductId__c);
    }
    
    for(ProductAllocation__c pa : [SELECT ChildProductID__c, AllocationPercentage__c FROM ProductAllocation__c where ParentProductID__c IN: parentId])
    {
        childProductId.add(pa.ChildProductID__c);
        values.put(pa.ChildProductID__c , pa.AllocationPercentage__c);
    }
    
    Double sum = 0;
    
    for(Product2 p : [Select Id, IsActive from Product2 where Id IN: childProductId]){
        if(!p.IsActive){
            p.addError('One of the child product is InActive');
        }else{
            sum += values.get(p.Id);
            
            if(sum > 100){
                p.addError('Allocation Percentage is high');
            }
        }
    }
}