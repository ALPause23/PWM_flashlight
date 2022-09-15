//#define F_CPU 4800000UL
//#define __AVR_ATtiny13__

#include <PWM.h>
#include <AVR_gpio.h>


uint8_t brightness_level_percent = 0;
uint8_t control_buttons_status = 0; /* 0 - no used; 1 - brightnes up; 2 - brightnes down; 3 - pressing two buttons */
uint8_t control_buttons_update = 0;


void initializationDefolt(void);
void EEPROM_write(unsigned int uiAddress, unsigned char ucData);
unsigned char EEPROM_read(unsigned int uiAddress);
void Brightnes_Poll(void);
uint8_t Check_Button(void);

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
    PORTB=(0<<PORTB5) | (1<<PORTB4) | (1<<PORTB3) | (0<<PORTB2) | (1<<PORTB1) | (1<<PORTB0);

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
	PWM_Init();
    #asm("sei") 

    while (1)
    {   
		Brightnes_Poll();
		PWM_StateMachine();
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
				if(PWM_Get_PulseWidth() > 20)
				{
					PWM_PulseWidth_Sub(20);
				}
				break;
			}
			case 2:
			{
				if(PWM_Get_PulseWidth() < 100)
				{
					PWM_PulseWidth_Add(20);
				}
				break;
			}
			case 3:
			{
				EEPROM_write(0x00, PWM_Get_PulseWidth());
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
		
		//OCR0A = (brightness_level_percent * 0xFF) / 100;
	}
}

uint8_t Check_Button(void)
{
    if(((~PINB) & GPIO_Pin_3) && ((~PINB) & GPIO_Pin_4))
    {
        return 3;
    }
    else
    {
        if((~PINB) & GPIO_Pin_3)
        {
            return 1;
        }
        else
        {
            if((~PINB) & GPIO_Pin_4)
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
	
	control_buttons_update = 1;
}



