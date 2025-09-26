public class currencyConverterClass_1 {

    public currencyConverterClass_1()
    {}
/*    
    public Double convertCurrencyWithApexCode(String oCurrency, String nCurrency, Double amount)
    {
        Double ipVal = amount;
        
        Set<String> isoCodes = new Set<String>();

        Map<String,Double> conversion_rates = new Map<String,Double>();

        isoCodes.add(oCurrency);

        isoCodes.add(nCurrency);

        // select id, isoCode, conversionrate, nextStartDate, startDate from DatedConversionRate where isoCode IN ('EUR', 'USD', 'INR', 'CNY') AND ( startDate > Today OR nextStartDate >= Today) order by startDate DESC
        // SELECT IsoCode,ConversionRate FROM CurrencyType WHERE IsoCode in: isoCodes
        
        for(DatedConversionRate curr: [select id, isoCode, conversionrate, nextStartDate, startDate 
                                from DatedConversionRate 
                                where IsoCode in: isoCodes AND ( startDate > Today OR nextStartDate >= Today) order by startDate DESC ])
        {          
		    conversion_rates.put(curr.IsoCode,curr.ConversionRate);        
        }

        //Convert incoming Opportuntiy Amount into USD…

        Double conversionRate = conversion_rates.get(oCurrency);

        amount = amount / conversionRate ;

        //convert amount as per new currency. 

        if(nCurrency != 'USD'){

            conversionRate = conversion_rates.get(nCurrency);
            amount = amount * conversionRate;
        }

        system.debug(ipVal +' in '+ oCurrency + ' is : '+amount +' in '+ nCurrency);
        return amount;
    }

//Double amt = converCurrencyWithApexCode (‘INR’,’USD’,5403.00);
*/
}