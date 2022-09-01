#define F_CPU 128000UL
#include <tiny13.h>
#include <io.h>
#include <delay.h>
#include <stdbool.h>
#include <stdint.h>



#define PB0   (1<<0)
#define PB1   (1<<1)
#define PB3   (1<<3)
#define PB4   (1<<4)
#define PB5   (1<<5)
#define PB6   (1<<6)
#define PB7   (1<<7)


#define WGM     (0x03) << 0 
#define COM_A   (0x02) << 6
#define COM_B   (0x02) << 4
#define CS      (0x03) << 0

uint8_t brightness_level_percent = 0;
uint8_t control_buttons_status = 0; // 0 - no used; 1 - brightnes up; 2 - brightnes down; 3 - pressing two buttons
uint8_t control_buttons_update = 0;


void initializationDefolt(void);
void PWM(void);
uint8_t Check_Button(void);
void Brightnes_Poll(void);

void EEPROM_write(unsigned int uiAddress, unsigned char ucData);
unsigned char EEPROM_read(unsigned int uiAddress);

void initializationDefolt(void)
{
	brightness_level_percent = EEPROM_read(0x00);
     // Declare your local variables here

    // Crystal Oscillator division factor: 1
    #pragma optsize-
    CLKPR=(1<<CLKPCE);
    CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
    #ifdef _OPTIMIZE_SIZE_
    #pragma optsize+
    #endif

    // Input/Output Ports initialization                                                  
    // Port B initialization
    // Function: Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
    DDRB=(0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (1<<DDB0);
    // State: Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
    PORTB=(0<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (0<<PORTB0);

    // Timer/Counter 0 initialization
    // Clock source: System Clock
    // Clock value: Timer 0 Stopped
    // Mode: Normal top=0xFF
    // OC0A output: Disconnected
    // OC0B output: Disconnected
    TCCR0A=(0<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (0<<WGM01) | (0<<WGM00);
    TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (0<<CS00);
    TCNT0=0x00;
    OCR0B=0x00;
	if(brightness_level_percent == 0xFF)
	{
		 brightness_level_percent = 60;
	}
    OCR0A = (brightness_level_percent * 0xFF) / 100;

    // Timer/Counter 0 Interrupt(s) initialization
    TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (0<<TOIE0);

    // External Interrupt(s) initialization
    // INT0: On
    // INT0 Mode: Falling Edge
    // Interrupt on any change on pins PCINT0-5: Off
    GIMSK=(1<<INT0) | (0<<PCIE);
    MCUCR=(1<<ISC01) | (0<<ISC00);
    GIFR=(1<<INTF0) | (0<<PCIF);

    // Analog Comparator initialization
    // Analog Comparator: Off
    // The Analog Comparator's positive input is
    // connected to the AIN0 pin
    // The Analog Comparator's negative input is
    // connected to the AIN1 pin
    ACSR=(1<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (0<<ACIE) | (0<<ACIS1) | (0<<ACIS0);
    ADCSRB=(0<<ACME);
    // Digital input buffer on AIN0: On
    // Digital input buffer on AIN1: On
    DIDR0=(0<<AIN0D) | (0<<AIN1D);

    // ADC initialization
    // ADC disabled
    ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);
}

void main()
{
    #asm("cli")
    initializationDefolt(); 
    #asm("sei") 
    PWM();
    while (1)
    {   
        Brightnes_Poll();
    }
}

void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
{
	while(EECR & (1<<EEPE));
	EEAR = uiAddress;
	EEDR = ucData;
	EECR |= (1<<EEMPE);
	EECR |= (1<<EEPE);
}

unsigned char EEPROM_read(unsigned int uiAddress)
{

	while(EECR & (1<<EEWE));
	EEAR = uiAddress;
	EECR |= (1<<EERE);
	return EEDR;
}

void Brightnes_Poll(void)
{
	if(control_buttons_update)
	{
		switch(control_buttons_status)
		{
			case 1:
			{
				if(brightness_level_percent > 20)
				{
					brightness_level_percent -= 20;
				}
				break;
			}
			case 2:
			{
				if(brightness_level_percent < 100)
				{
					brightness_level_percent += 20;
				}
				break;
			}
			case 3:
			{
				EEPROM_write(0x00, brightness_level_percent);
				break;
			}
			default:
			{
				control_buttons_status = 0;
				return;
			}
		}
		control_buttons_update = 0;
		control_buttons_status = 0;
		
		OCR0A = (brightness_level_percent * 0xFF) / 100;
	}
}

void PWM(void)
{
    TCCR0A = WGM | COM_A | COM_B;
    TCCR0B = CS;  
    //OCR0A = 0x10;
	//OCR0B = 0x0A;    
    return;
}

uint8_t Check_Button(void)
{
    if(((~PINB) & PB3) && ((~PINB) & PB4))
    {
        return 3;
    }
    else
    {
        if((~PINB) & PB3)
        {
            return 1;
        }
        else
        {
            if((~PINB) & PB4)
            {
                return 2;
            }
        }
    }
    return 0;
}

interrupt [EXT_INT0] void exterInt0(void)
{
	control_buttons_status = Check_Button();
	
	control_buttons_update++;
}

