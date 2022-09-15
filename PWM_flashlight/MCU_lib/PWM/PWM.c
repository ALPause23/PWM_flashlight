#include "PWM.h"
#include "AVR_gpio.h"


typedef enum
{
	DUTY_NORMAL = 0,
	DUTY_100_PERCENT = 1,
	DUTY_0_PERCENT = 2	
}PWM_STATE_MACHINE;


static uint8_t inited_flag = 0;
uint8_t signal_polarity = 0;
uint8_t interrupt_flag_polarity = 0;
uint8_t width_percent = 60;
PWM_STATE_MACHINE PWM_status_SM = DUTY_NORMAL; 
PWM_STATE_MACHINE PWM_last_status_SM = DUTY_0_PERCENT;


void PWM_DeInit(void);

void PWM_Init(void)
{
	if(inited_flag)
	{
		return;
	}
	
	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=0xFF
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	TCCR0A=(0<<COM0A1) | (1<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (0<<WGM00);
	TCCR0B=(0<<WGM02) | (0<<CS02) | (1<<CS01) | (1<<CS00);
	TCNT0=0x00;
	OCR0B=0x00;
	if(width_percent == 0xFF)
	{
		width_percent = 60;
	}
	OCR0A = 74;
	
	if(PWM_last_status_SM == DUTY_0_PERCENT)
	{
		signal_polarity = 0;
	}
	else if(PWM_last_status_SM == DUTY_100_PERCENT)
	{
		signal_polarity = 1;
	}
	
	// Timer/Counter 0 Interrupt(s) initialization
	TIMSK0=(0<<OCIE0B) | (1<<OCIE0A) | (0<<TOIE0);
	
	inited_flag = 1;
}

void PWM_DeInit(void)
{
	inited_flag = 0;
	
	interrupt_flag_polarity = 0;
	signal_polarity = 0;
	TIMSK0 &= ~(1<<OCIE0A);
	TCCR0A &= ~(1<<WGM01);
	TCCR0A &= ~(1<<WGM00);
	TCCR0A &= ~(1<<COM0A1);
	TCCR0A &= ~(1<<COM0A0);
	TCNT0=0x00;	
}

void PWM_StateMachine(void)
{
	if(width_percent == 0)
	{
		PWM_status_SM = DUTY_0_PERCENT;
	}
	else
	{
		if(width_percent == 100)
		{
			PWM_status_SM = DUTY_100_PERCENT;
		}
		else
		{
			PWM_status_SM = DUTY_NORMAL;
		}
	}
			
	switch(PWM_status_SM)
	{
		case DUTY_NORMAL:
		{
			PWM_Init();
			
			if(interrupt_flag_polarity)
			{
				if(signal_polarity == 1)
				{
					OCR0A = (width_percent * 74) / 100;
				}
				else
				{
					OCR0A = ((100 - width_percent) * 74) / 100;
				}
				interrupt_flag_polarity = 0;
			}
			
			break;
		}
		case DUTY_0_PERCENT:
		{
			PWM_DeInit();
			PORTB &= ~GPIO_Pin_1;
			break;
		}
		case DUTY_100_PERCENT:
		{
			PWM_DeInit();
			PORTB |= GPIO_Pin_1;
			break;
		}	
	}
	
}

void PWM_PulseWidth_Add(uint8_t value)
{
	width_percent += value;
}

void PWM_PulseWidth_Sub(uint8_t value)
{
	width_percent -= value;
}

void PWM_WidthPercent_Set(uint8_t new_value)
{
	width_percent = new_value;
}

uint8_t PWM_Get_PulseWidth(void)
{
	return width_percent;
}

interrupt [TIM0_COMPA] void PWM_tim0_CompA(void)
{
	signal_polarity ^= 0x01;
	
	interrupt_flag_polarity = 1;
}

