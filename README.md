# RHEOMETER
EPICS Driver developed by Mariano Ruiz, zma@ornl.gov

RHEOMETER Anton Paar



Rheometer

from Wikipedia--A rheometer is a laboratory device used to measure the way in which a liquid, suspension or slurry flows in response to applied forces. It is used for those fluids which cannot be defined by a single value of viscosity and therefore require more parameters to be set and measured than is the case for a viscometer. It measures the rheology of the fluid.

Auxiliary Input


To use the TTL signals programatically, we used custom hardware.

rheomter hardware box

The hardware consists of a an ICP model 7002. It has a relay control to trigger 5V TTL level signal to the rheometer on RL0 pins. It also has two analog inputs on pin pairs Vin0 and Vin1. This analog inputs can be used by configuring the rheometer software to output X variable from it as a voltage.

Originally the ICP was configured for Mod-bus RTU and the Dcon windows utility was used to change it to DCON. To do this, the moxa needs to be configured as Real COM mode so the Dcon utility discovers the module. The Final settings for the ICP are 9600-8-1-N, DCON protocol RS-485 address 1. The ICP needs to be on INIT mode for the changes to take effect. There is a switch on the bottom of it to enable init Mode.

Once the ICP is configured, we can set the moxa back to TCP/IP server mode and send a telnet command with ascii string $01M + CRLF

bash-4.1$ telnet 10.112.9.27 4001
Trying 10.112.9.27...
Connected to 10.112.9.27.
Escape character is '^]'.
$01M
017002

The connector for the 5v triggering is part number Digi-Key CP-2070-ND 7 pin connector.

The power supply used on the hardware is dual output 12V and 5V. 5V is used to feed the relay Voltage to be triggered by the ICP. 12V is used to power the moxas and ICP.

Two Moxas are used:

Moxa 5150 for ICP as RS485
Port1 	TCP IP server Mode Port 4001 RS485 	9600-8-N-1 No Flow control	ICP Communications

Moxa 5410 4 port 232.
Port1 	Real COM MODE 	38400-8-N-1-XonXoff?	Windows RheoPlus? software uses this port to communicate. Must be mapped on windows machine Null Modem Serial Cable
Port2 	TCP IP server Mode Port 4002 	38400-8-N-1	Tx Spy port for RheoPlus?
Port3 	TCP IP server Mode Port 4003 	38400-8-N-1	Rx Spy port for RheoPlus?
Port4 	disabled 	If this moxa supported 232 and 485 it could be used to communicate to the ICP

Communication parameters

The system can communicate using 232 or TCP/IP.

RS-232
baud 38400
Databits 8
Stopbits 1
Partity None
Handshake XonXoff

ICP Commands

Read analog modules. #AAN AA is the address. In this case 01. N is the channel in this case 0 and 1

#010   Read Analog Channel0
#011   Read Analog Channel1

SET relay 1    
@01DO01    ON
@01DO00    OFF

READ Status of DO and Relays. 
@01DI

The rheometer hardware will bit for the relay response is the fourth bit starting from zero. 
@01DI
0100100  Shows relay1 on
0100000  Shows relay1 off



Rheometer Software


In regards to your questioning on setting up the Event Control you will first need to have the expert settings enabled for the measurement. To set this up first open Rheoplus and then bring the measurement window to the front (click on the red box with a lightning bolt on the tool bar). In the top toolbar you will see a drop down for Measurement. From there click on General Data. This will open a new window which you will then need to change the input mode from Standard to Expert mode and click okay. Afterwards go to the Measurement and double click in the first Interval. A new window will open and you will then need to highlight the option called interval in the left hand side of this window. With this highlighted you will now see a button to enable the Event Control. This will allow you to make the changes as you have observed in the document that was provided to you.


How I would set it up is first go to Tool/Setup/Device? & Accessories. A new window should appear in which you will then click on the tab called Accessories. Next click on the Install button. You can select Rheometer Controller from the Accessory Groups. I believe what you will need to install is the trigger-LCR meter. Once this is installed click okay. You can then highlight this accessory and then copy it. This will then allow you to make the changes per the screen shots you were provided. Once the accessory is created you will click okay until you get to the grey screen of Rheoplus and then click on the Control Panel and go to Configuration and add this accessory. When you then open the workbook in the future you should be able to set the Event Controller as provided. I hope this information helps and if you have any additional questions please let me know.

Trigger Test Script for RheoPlus? This attach file has a workbook setup for triggering. ​https://trac.sns.gov/trac/slowcontrols/attachment/wiki/Rheometer/triggertemplate.ort It can be downloaded and tested with rheoplus. This was made with MCR302. On Event Control we can see the script to sync with triggers.

TCP/IP

External IO

From the Vendor: The Anton Paar GmbH, MCR501 rheometer cannot interface with programs like C++, VB or C#. Therefore, we do not provide with any drivers to interface or command reference.

Sample run using serial spy cables for the commands sent to the Rheometer

rheometerRx_1152015_338PM.txt
#VERS[?]→
#VERS[?]→
#DATA[?]→
:GETC["VALUES[?]"]→
:DEVC["KSETMOT[3]"]→
:DEVC["KTHERMO[2,0,73.15,473.15,0,0,0,1,9600,n,8,1,n]"]→
:DEVC["KMISC[0,0.00165,0,1,0,0.59,0.23,2,0,0,0,0,0,0,0,0,0,0,0,0,26423,1,2,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0]"]→
:PROG["US200-Test",TEST[(PART[(NUMB[2,LAST],DTIM[60,60,REL]),(),(),(),(SRAT[1,100],DIST[1,0]),(),(),,(DAPT[STRE[1,??T]],DAPT[SRAT[1,??T]],DAPT[STRA[1,??T]],DAPT[TEMP[2,??T]],DAPT[FORC[1,??T]],DAPT[DIST[1,??T]],DAPT[VELO[1,??T]],DAPT[DGAP[1,??T]],DAPT[TIMA[1,??T]],DAPT[TIMP[1,??T]],GSTR[STAT[1,??T]],DAPT[EXCE[1,??T]],DAPT[ETRQ[1,??T]]),(GENP[0,(IFDT[EX])],SETV[0,(IFST[IN,(16)])]),()])],EXIT[()],CANC[()]];→
:MDEF[?]→
:GETC["VALUES[?]"]→
:DEVC["KHSETNF[250,10,5,1,10250,10,5,1,125250,10,5,1,125350,10,5,1]"]→
:RUN[]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
:STAT[?]→
#VERS[?]→

Sample response using serial spy cables for the commands sent from the Rheometer to vendor software

rheometerTx_1152015_338PM.txt#VERS["Anton Paar Germany GmbH,MCR501,03.40,10.02.09,80851806,PDCL,02.00,<MAIN-Firmware IOP, Version 03.40, 10.02.09, 09:19:16.00>, < MAIN-Firmware DSP, Version 03.40, 10.02.09, 09:18:40.00>, <Peltier, Version 01.0, 23.07.2004, 00:00:00.00>, <Normalforce, Version 01.00, 01.10.1998, 00:00:00.00>,<MS1(20458):PP50/TI,Version 01.00, 03.08.2002, 16:04:56.78>,<TU1( 81646500 ):P-PTD200,Version 01.00, 03.08.2002, 16:04:56.78>,<TruGap, Version 01.11, 00.00.0000, 00:00:00.00>,<LAN(00-0d-d9-01-0d-eb), Version 02.01,00.00.00,00:00>"]
#VERS["Anton Paar Germany GmbH,MCR501,03.40,10.02.09,80851806,PDCL,02.00,<MAIN-Firmware IOP, Version 03.40, 10.02.09, 09:19:16.00>, < MAIN-Firmware DSP, Version 03.40, 10.02.09, 09:18:40.00>, <Peltier, Version 01.0, 23.07.2004, 00:00:00.00>, <Normalforce, Version 01.00, 01.10.1998, 00:00:00.00>,<MS1(20458):PP50/TI,Version 01.00, 03.08.2002, 16:04:56.78>,<TU1( 81646500 ):P-PTD200,Version 01.00, 03.08.2002, 16:04:56.78>,<TruGap, Version 01.11, 00.00.0000, 00:00:00.00>,<LAN(00-0d-d9-01-0d-eb), Version 02.01,00.00.00,00:00>"]
#DATA["1,PP50/TI-SN20458,1,10000,10000,100000,156989,40813657,0,0,0,100,794130,0,P-PTD200-SN81646500,22000,768,2,250,10000,500,11,6,3,0,3,0"]
:GETC["VALUES[-3.155,0.557,1,298.75,-0.06,298.75,,,1,0,0.0006]"]:DEVC["KSETMOT[]"]
:DEVC["KTHERMO[]"]
:DEVC["KMISC[]"]
:PROG["",TEST[( PART[ ( ),( ),( ),( ),( ),( ),( ),( ),( ),( ),( ) ] )],EXIT[( )],CANC[()]]  
:MDEF[( PART[ ( DAPT[ STRE[ 1 , ??T ] ] , DAPT[ SRAT[ 1 , ??T ] ] , DAPT[ STRA[ 1 , ??T ] ] , DAPT[ TEMP[ 2 , ??T ] ] , DAPT[ FORC[ 1 , ??T ] ] , DAPT[ DIST[ 1 , ??T ] ] , DAPT[ VELO[ 1 , ??T ] ] , DAPT[ DGAP[ 1 , ??T ] ] , DAPT[ TIMA[ 1 , ??T ] ] , DAPT[ TIMP[ 1 , ??T ] ] , GSTR[ STAT[ 1 , ??T ] ] , DAPT[ EXCE[ 1 , ??T ] ] , DAPT[ ETRQ[ 1 , ??T ] ] ) ] )]
:GETC["VALUES[-3.155,0.557,1,298.75,-0.06,298.75,,,1,0,0.0006]"]:DEVC["KHSETNF[]"]
:RUN[]
:PART[1,0]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:MEAS[1,1,+6.0000003E+01,+1.1900000E+00,15000,(),(+4.3453818E+03,+9.8027557E+01,+4.3931479E+03,+2.9878280E+02,+7.0902090E+00,+5.5173279E-04,+1.5608308E-07,+2.8996595E-04,+4.4997009E+01,0,"GMi,Dy_auto",+9.9357658E+01,+1.0646881E-01)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:STAT[(12)]
:MEAS[2,1,+1.2000000E+02,+1.5000000E-02,15000,(),(+3.5781718E+03,+1.0220417E+02,+1.0600343E+04,+2.9882443E+02,+6.6679253E+00,+5.5638277E-04,+1.1969581E-06,+2.1394590E-03,+1.0499700E+02,+6.0000980E+01,"GMi,Dy_auto",+2.3411238E+02,+8.7670946E-02)] 
:PART[0,+1.2000100E+02] 
#VERS["Anton Paar Germany GmbH,MCR501,03.40,10.02.09,80851806,PDCL,02.00,<MAIN-Firmware IOP, Version 03.40, 10.02.09, 09:19:16.00>, < MAIN-Firmware DSP, Version 03.40, 10.02.09, 09:18:40.00>, <Peltier, Version 01.0, 23.07.2004, 00:00:00.00>, <Normalforce, Version 01.00, 01.10.1998, 00:00:00.00>,<MS1(20458):PP50/TI,Version 01.00, 03.08.2002, 16:04:56.78>,<TU1( 81646500 ):P-PTD200,Version 01.00, 03.08.2002, 16:04:56.78>,<TruGap, Version 01.11, 00.00.0000, 00:00:00.00>,<LAN(00-0d-d9-01-0d-eb), Version 02.01,00.00.00,00:00>"]
#VERS["Anton Paar Germany GmbH,MCR501,03.40,10.02.09,80851806,PDCL,02.00,<MAIN-Firmware IOP, Version 03.40, 10.02.09, 09:19:16.00>, < MAIN-Firmware DSP, Version 03.40, 10.02.09, 09:18:40.00>, <Peltier, Version 01.0, 23.07.2004, 00:00:00.00>, <Normalforce, Version 01.00, 01.10.1998, 00:00:00.00>,<MS1(20458):PP50/TI,Version 01.00, 03.08.2002, 16:04:56.78>,<TU1( 81646500 ):P-PTD200,Version 01.00, 03.08.2002, 16:04:56.78>,<TruGap, Version 01.11, 00.00.0000, 00:00:00.00>,<LAN(00-0d-d9-01-0d-eb), Version 02.01,00.00.00,00:00>"]

Vendor Software Operation

During an experiment the vendor software does the following steps

1-Gets the version of the software and hardware. (for some reason it sends the request twice)
2-then it sends the Data command that contains serial numbers and other variables unknown
3-Sends a command :DEVC["KSETMOT[3]"]→
4-:DEVC["KTHERMO[2,0,73.15,473.15,0,0,0,1,9600,n,8,1,n]"]→  This includes serial baud rates and other variables to other hardware
5-:DEVC["KMISC[ ... It appears as if this command doesn't change between experiments.  
6-:PROG["US200-Test",TEST[(PART   this section sets the number of steps and how many seconds to wait in between among other unknown variables
7-:MDEF[?]→   unknown
8-:GETC["VALUES[-3.155,0   this command gest some variables from the hardware. We may be able to correlate some of them. 
9-:RUN[]  the program starts
10-:STAT[?]→ is sent continuously until we get a data point of :MEAS[1,1,+6.0000003E+   
11-:STAT [?]→ keeps sending and we get another point :MEAS[1,1,+6.0000003E
12-:PART[0,+1.2000100E+02] appears to end the program. 



 

The MEAS[1,1,### values contain what the user wants. We need to correlate the values

The user is requesting to pause and resume between workbooks and also to read the values on EPICs

Option1:If we determine how to pause resume, one option will be to let the vendor software do the calibration and setup and our software to do the start, pause, resume, stop and also send the values to EPICs.

Option2:figure out what the software is doing and do the calculations on EPICs. This is a big task since we don't have a communication manual or drivers.

Option3:If we can somehow do the start, stop, pause, and resume with the hardware inputs and the readings using the sniffer 232 cable. This will be the simplest but it is not likely to have that type of control at the hardware Aux Input.
Additional Information

Additional info and setups can be found on
128.219.164.43\Software_Vendor\Rheometer

Rheocompass is the new version

    We still dont have a proper communication interface for the Rheometer.

Complex and Non-Complex variables

Non-Complex variables are transferred from the rheometer to the software. Complex variables are obtained with calculations on the RheoCompass? Software from Non-Complex variables.

Using extra hardware, we can tap into the serial line and observe the non-complex variables like we have been doing. We can trigger the workbook switching by sending a Voltage High pulse using our hardware connected to the rheometer.

This tends to cause issues because the non-complex variables parsing depends on the experiment. We don’t have access to the rheology complex variables for our experiment from within our software. New rheometer will likely move away from serial interface. We need to have extra hardware to trigger the workbooks TTL. TTL triggering can be cumbersome causing double triggers if measuring time, script and averaging over are not set correctly.

Diagram on what we do to read Non-Complex variables and triggering.

What we would like to have

Last modified 7 weeks ago
Attachments (7)
Download in other formats:

    Plain Text 

Trac Powered

Powered by Trac 1.2.3
By Edgewall Software.

Visit the Trac open source project at
http://trac.edgewall.org/



EPICS Module ASYN drvAsynIPPortConfigure 
