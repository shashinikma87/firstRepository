public class currencyConverterClass 
{
/*
    // Singleton, remember when first referenced, key = DatedConversionRate.id
    private static Map<ID,DatedConversionRate> dcrIdToDcrMap;                      
    
    //  ----------------------------------------
    //  convertToOrgCurrency - convert value in some ISO currency to org currency as of given date
    //  ----------------------------------------
    public static Decimal convertToOrgCurrency(String currencyIso, Decimal currencyVal, Date currencyDate) {
        Decimal res;
        if (currencyIso == null || currencyVal == null) {}
        else {
            if (dcrIdToDcrMap == null)              // build the map only once for life of the transaoction
                dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
            for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
                if (dcr.isoCode != currencyIso)                                         continue;   // look for a match in table against input currency
                if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  continue;   // not in the range of effective dates
                System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
                res =  currencyVal / dcr.conversionRate;
                break;  
            }
        }
        System.debug(LoggingLevel.INFO,'convertToOrgCurrency res= ' + res);
        return res;
    }
    
    //  ----------------------------------------
    //  convertFromOrgCurrency - convert value in org currency to some iso currency as of given date 
    //  ----------------------------------------
    public static Decimal convertFromOrgCurrency(String currencyIso, Decimal currencyVal, Date currencyDate) {
        Decimal res;
        if (currencyIso == null || currencyVal == null) {}
        else {
            if (dcrIdToDcrMap == null)              // build the map only once for life of the transaoction
                dcrIdToDcrMap = new Map<ID,DatedConversionRate> ([select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate]);
            for (DatedConversionRate dcr: dcrIdToDcrMap.values()) {
                if (dcr.isoCode != currencyIso)                                         continue;   // look for a match in table against input currency
                if (currencyDate < dcr.startDate || currencyDate >= dcr.nextStartDate)  continue;   // not in the range of effective dates
                System.debug(LoggingLevel.INFO,'Converting using dcr: ' + dcr);
                res =  currencyVal * dcr.conversionRate;
                break;  
            }
        }
        System.debug(LoggingLevel.INFO,'convertFromOrgCurrency res= ' + res);
        return res;
    }
*/
}