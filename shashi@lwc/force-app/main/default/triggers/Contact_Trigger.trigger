trigger Contact_Trigger on Contact (after insert, before update) {

    if (trigger.isBefore)
    {
        system.debug('m in trigger.isBefore...');
    }
    
    if (trigger.isAfter)
    {
        system.debug('m in trigger.isAfter...');
    }
    
    if (Trigger.isAfter && Trigger.isinsert)
    {
      system.debug('Trigger.isAfter && Trigger.isinsert');
    }
}