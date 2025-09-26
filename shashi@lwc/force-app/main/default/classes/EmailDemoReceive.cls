global class EmailDemoReceive implements Messaging.InboundEmailHandler {
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        System.debug('in emailService....');
        
        try{ 
            if (result.success = true) {
                System.debug('Success');
                System.debug('Subject : ' + email.subject);
                System.debug('ccAddresses : ' + email.ccAddresses);
                System.debug('ccAddresses : ' + email.ccAddresses);
                
                Note note = new Note();
                note.Title = email.fromName + ' (' + DateTime.now() + ')';
                note.Body = email.plainTextBody;
                System.debug('Body : ' + note);
                
            }
        } catch (Exception e) {
            result.success = false;
            result.message = 'Oops, I failed.';
        }
       
        return result;
    }
}