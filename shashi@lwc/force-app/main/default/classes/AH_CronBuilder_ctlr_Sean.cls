/****************************************************************************************
Name            : AH_CronBuilder_ctlr Class
Author          : Sean Harris
Created Date    : 02/20/2020
Last Mod Date   : 02/20/2020
Last Mod By     : Sean Harris
NICC Reference  : 
Description     : 

Format
======
A cron expression is a string comprised of 6 or 7 fields separated by white space. 
Fields can contain any of the allowed values, along with various combinations of the allowed special characters for that field. 

The fields are as follows:

Field Name Mandatory Allowed Values Allowed Special Characters
Seconds YES 0-59 , - * /
Minutes YES 0-59 , - * /
Hours YES 0-23 , - * /
Day of month YES 1-31 , - * ? / L W
Month YES 1-12 or JAN-DEC , - * /
Day of week YES 1-7 or SUN-SAT , - * ? / L #
Year NO empty, 1970-2099 , - * /

So cron expressions can be as simple as this: * * * * ? *
or more complex, like this: 0/5 14,18,3-39,52 * ? JAN,MAR,SEP MON-FRI 2002-2010

Special Characters
==================
* ("all values") - used to select all values within a field. For example, "" in the minute field means *"every minute".

? ("no specific value") - useful when you need to specify something in one of the two fields in which the character is allowed, but not the other. 
For example, if I want my trigger to fire on a particular day of the month (say, the 10th), but don’t care what day of the week that happens to be, 
I would put "10" in the day-of-month field, and "?" in the day-of-week field. See the examples below for clarification.

- - used to specify ranges. For example, "10-12" in the hour field means "the hours 10, 11 and 12".

, - used to specify additional values. For example, "MON,WED,FRI" in the day-of-week field means "the days Monday, Wednesday, and Friday".

/ - used to specify increments. For example, "0/15" in the seconds field means "the seconds 0, 15, 30, and 45". 
And "5/15" in the seconds field means "the seconds 5, 20, 35, and 50". 
You can also specify ‘/’ after the ‘’ character - in this case ‘’ is equivalent to having ‘0’ before the ‘/’. 
‘1/3’ in the day-of-month field means "fire every 3 days starting on the first day of the month".

L ("last") - has different meaning in each of the two fields in which it is allowed. 
For example, the value "L" in the day-of-month field means "the last day of the month" - day 31 for January, day 28 for February on non-leap years. 
If used in the day-of-week field by itself, it simply means "7" or "SAT". But if used in the day-of-week field after another value, 
it means "the last xxx day of the month" - for example "6L" means "the last friday of the month". 
You can also specify an offset from the last day of the month, such as "L-3" which would mean the third-to-last day of the calendar month. 
When using the ‘L’ option, it is important not to specify lists, or ranges of values, as you’ll get confusing/unexpected results.

W ("weekday") - used to specify the weekday (Monday-Friday) nearest the given day. 
As an example, if you were to specify "15W" as the value for the day-of-month field, 
the meaning is: "the nearest weekday to the 15th of the month". So if the 15th is a Saturday, the trigger will fire on Friday the 14th. 
If the 15th is a Sunday, the trigger will fire on Monday the 16th. If the 15th is a Tuesday, then it will fire on Tuesday the 15th. 
However if you specify "1W" as the value for day-of-month, and the 1st is a Saturday, the trigger will fire on Monday the 3rd, 
as it will not ‘jump’ over the boundary of a month’s days. The ‘W’ character can only be specified when the day-of-month is a single day, 
not a range or list of days.

The 'L' and 'W' characters can also be combined in the day-of-month field to yield 'LW', which translates to *"last weekday of the month"*.
# - used to specify "the nth" XXX day of the month. For example, the value of "6#3" in the day-of-week field means "the third Friday of the month" 
(day 6 = Friday and "#3" = the 3rd one in the month). Other examples: "2#1" = the first Monday of the month and "4#5" = the fifth Wednesday of the month. 
Note that if you specify "#5" and there is not 5 of the given day-of-week in the month, then no firing will occur that month.

The legal characters and the names of months and days of the week are not case sensitive. MON is the same as mon.

****************************************************************************************/

public class AH_CronBuilder_ctlr_Sean 
{
    public ComponentData cData {get;set;}
   
    // COLLECTIONS
    public List<SelectOption> lstFrequency {get; set;} 
    public List<SelectOption> lstStartTimes {get; set;} 
    public List<SelectOption> lstDays {get; set;} 
    public List<SelectOption> lstNthDays {get; set;} 
    public List<SelectOption> lstDaysofWeek {get; set;} 

    // STRINGS
    public String strSelFrequency {get; set;}
    public String strSelStartTime {get; set;}
    public String strSelDay {get; set;}
    public String strSelNthDay {get; set;}
    public String strSelDayofWeek {get; set;}
    public String strStartDate {get; set;}
    public String strEndDate {get; set;}
    public String strCronExpression {get; set;} 
    public String strCronString {get; set;} 
    
    // BOOLEANS
    public boolean bSunday {get; set;} 
    public boolean bMonday {get; set;} 
    public boolean bTuesday {get; set;} 
    public boolean bWednesday {get; set;} 
    public boolean bThursday {get; set;} 
    public boolean bFriday {get; set;} 
    public boolean bSaturday {get; set;} 
    public boolean bByDayOfWeek {get; set;}  
    public boolean bByOnDay {get; set;} 
    public boolean bByOnNthDay {get; set;}     

    
    public AH_CronBuilder_ctlr_Sean() 
    {
        initForm();
    }
    
    private void initForm()
    {
        
        lstFrequency = new List<SelectOption>(); 
        lstFrequency.add(new SelectOption('Weekly', 'Weekly'));
        lstFrequency.add(new SelectOption('Monthly', 'Monthly'));
        strSelFrequency = 'Weekly';
        
        bByDayOfWeek = true;
        bByOnDay = true;
        bByOnNthDay = false;
        
        bSunday = false;
        bMonday = false;
        bTuesday = false;
        bWednesday = false;
        bThursday = false; 
        bFriday = false;
        bSaturday = false;  

        lstStartTimes = new List<SelectOption>();        
        lstStartTimes.add(new SelectOption('--None--', '--None--'));
        lstStartTimes.add(new SelectOption('0 0 0', '12:00 AM'));
        lstStartTimes.add(new SelectOption('0 15 0', '12:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 0', '12:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 0', '12:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 1', '1:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 1', '1:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 1', '1:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 1', '1:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 2', '2:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 2', '2:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 2', '2:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 2', '2:45 AM'));   
        
        lstStartTimes.add(new SelectOption('0 0 3', '3:00 AM'));
        lstStartTimes.add(new SelectOption('0 15 3', '3:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 3', '3:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 3', '3:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 4', '4:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 4', '4:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 4', '4:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 4', '4:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 5', '5:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 5', '5:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 5', '5:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 5', '5:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 6', '6:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 6', '6:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 6', '6:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 6', '6:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 7', '7:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 7', '7:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 7', '7:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 7', '7:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 8', '8:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 8', '8:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 8', '8:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 8', '8:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 9', '9:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 9', '9:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 9', '9:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 9', '9:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 10', '10:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 10', '10:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 10', '10:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 10', '10:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 11', '11:00 AM')); 
        lstStartTimes.add(new SelectOption('0 15 11', '11:15 AM'));
        lstStartTimes.add(new SelectOption('0 30 11', '11:30 AM'));
        lstStartTimes.add(new SelectOption('0 45 11', '11:45 AM'));
        
        lstStartTimes.add(new SelectOption('0 0 12', '12:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 12', '12:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 12', '12:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 12', '12:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 13', '1:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 13', '1:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 13', '1:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 13', '1:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 14', '2:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 14', '2:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 14', '2:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 14', '2:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 15', '3:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 15', '3:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 15', '3:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 15', '3:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 16', '4:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 16', '4:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 16', '4:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 16', '4:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 17', '5:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 17', '5:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 17', '5:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 17', '5:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 18', '6:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 18', '6:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 18', '6:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 18', '6:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 19', '7:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 19', '7:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 19', '7:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 19', '7:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 20', '8:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 20', '8:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 20', '8:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 20', '8:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 21', '9:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 21', '9:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 21', '9:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 21', '9:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 22', '10:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 22', '10:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 22', '10:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 22', '10:45 PM'));
        
        lstStartTimes.add(new SelectOption('0 0 23', '11:00 PM')); 
        lstStartTimes.add(new SelectOption('0 15 23', '11:15 PM'));
        lstStartTimes.add(new SelectOption('0 30 23', '11:30 PM'));
        lstStartTimes.add(new SelectOption('0 45 23', '11:45 PM'));
        strSelStartTime = '--None--';
        
        lstDays = new List<SelectOption>();  
        lstDays.add(new SelectOption('1', '1'));
        lstDays.add(new SelectOption('2', '2'));
        lstDays.add(new SelectOption('3', '3'));
        lstDays.add(new SelectOption('4', '4'));
        lstDays.add(new SelectOption('5', '5'));
        lstDays.add(new SelectOption('6', '6'));
        lstDays.add(new SelectOption('7', '7'));
        lstDays.add(new SelectOption('8', '8'));
        lstDays.add(new SelectOption('9', '9'));
        lstDays.add(new SelectOption('10', '10'));
        lstDays.add(new SelectOption('11', '11'));
        lstDays.add(new SelectOption('12', '12'));
        lstDays.add(new SelectOption('13', '13'));
        lstDays.add(new SelectOption('14', '14'));
        lstDays.add(new SelectOption('15', '15'));
        lstDays.add(new SelectOption('16', '16'));
        lstDays.add(new SelectOption('17', '17'));
        lstDays.add(new SelectOption('18', '18'));
        lstDays.add(new SelectOption('19', '19'));
        lstDays.add(new SelectOption('20', '20'));
        lstDays.add(new SelectOption('21', '21'));
        lstDays.add(new SelectOption('22', '22'));
        lstDays.add(new SelectOption('23', '23'));
        lstDays.add(new SelectOption('24', '24'));
        lstDays.add(new SelectOption('25', '25'));
        lstDays.add(new SelectOption('26', '26'));
        lstDays.add(new SelectOption('27', '27'));
        lstDays.add(new SelectOption('28', '28'));
        lstDays.add(new SelectOption('29', '29'));
        lstDays.add(new SelectOption('30', '30'));
        lstDays.add(new SelectOption('31', '31'));
        lstDays.add(new SelectOption('L', 'last'));       
        strSelDay = '1';

        lstNthDays = new List<SelectOption>();  
        lstNthDays.add(new SelectOption('#1', 'the 1st'));
        lstNthDays.add(new SelectOption('#2', 'the 2nd'));
        lstNthDays.add(new SelectOption('#3', 'the 3rd'));
        lstNthDays.add(new SelectOption('#4', 'the 4th'));
        lstNthDays.add(new SelectOption('L', 'the Last'));
        strSelNthDay = '#1';
        
        lstDaysofWeek = new List<SelectOption>();  
        lstDaysofWeek.add(new SelectOption('SUN', 'Sunday'));
        lstDaysofWeek.add(new SelectOption('MON', 'Monday'));
        lstDaysofWeek.add(new SelectOption('TUE', 'Tuesday'));
        lstDaysofWeek.add(new SelectOption('WED', 'Wednesday'));
        lstDaysofWeek.add(new SelectOption('THR', 'Thursday'));
        lstDaysofWeek.add(new SelectOption('FRI', 'Friday'));
        lstDaysofWeek.add(new SelectOption('SAT', 'Saturday'));
        strSelDayofWeek = 'SUN';
        
    }
  
    public void changeFrequency()
    {
        if (bByDayOfWeek)
        {
            bByDayOfWeek = false;
        }
        else
        {
            bByDayOfWeek = true;
        }
    }
    
    public void changeDayMode1()
    {  

        if (bByOnDay)
        {
            bByOnNthDay = false;
        }
        else
        {
            bByOnNthDay = true;
        }        
    }
    
    public void changeDayMode2()
    {  

        if (bByOnNthDay)
        {
            bByOnDay = false;
        }
        else
        {
            bByOnDay = true;
        }        
    }
    
    public void generateCronExpression()
    {
		system.debug(' IN generateCronExpression...');
        // ===================================================================        
        // SECONDS, MINUTES, HOURS
        // ===================================================================
        
        system.debug('strSelStartTime : '+strSelStartTime );
        if (strSelStartTime == '--None--')
        {
            return  ;
        }
    
        // ===================================================================        
        // DAY OF MONTH
        // ===================================================================
		string strDoM = '*';
        
        if (!bByDayOfWeek)
        {
            if (bByOnDay)
            {
                strDoM = strSelDay;
            }
//            else
//            {
                
//            }
            
        }
        
        // ===================================================================        
        // MONTH
        // ===================================================================
        string strMonths = '*';
        string strDoW = '';
        
        if (!bByDayOfWeek)
        {
            if (bByOnDay)
            {
                strMonths = '1/1';
            }
            else
            {
                strDoM = '?';
                strMonths = '1/1';
                strDoW = strSelDayofWeek + strSelNthDay;
            }
            
        }
        
        // ===================================================================        
        // DAY OF WEEK
        // ===================================================================
        
        if (bByDayOfWeek)
        {
            
            strDoW = '';
            
            if (bSunday)
            {
                strDoW += 'SUN,';
            }
            if (bMonday)
            {
                strDoW += 'MON,';
            }
            if (bTuesday)
            {
                strDoW += 'TUE,';
            }
            if (bWednesday)
            {
                strDoW += 'WED,';
            }
            if (bThursday)
            {
                strDoW += 'THU,';
            }
            if (bFriday)
            {
                strDoW += 'FRI,';
            }
            if (bSaturday)
            {
                strDoW += 'SAT,';
            }        
            
            if (strDoW != '')
            {
                strDoW = (strDoW.mid(0, strDoW.length() - 1));
                strDoM = '?';
            }
            else
            {
                strDoW = '*';
            }
            
        }
        
        // ===================================================================        
        // YEAR  
        // ===================================================================
		string strYears = '*';
        

        // ===================================================================        
        // BUILD CRON EXPRESSION  
        // ===================================================================
        strCronExpression = strSelStartTime + ' ' + strDoM + ' ' + strMonths + ' ' + strDoW + ' ' + strYears; 
        
        strCronString = strCronExpression;
        
        system.debug(' strCronExpression = ' + strCronExpression); 
        cData.cronExpression = strCronString;
        
        
        
    }
    
}