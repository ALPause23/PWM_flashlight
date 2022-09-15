#ifndef __PWM_H__
#define __PWM_H__

#include "common.h"

void PWM_Init(void);
void PWM_StateMachine(void);
void PWM_PulseWidth_Add(uint8_t value);
void PWM_PulseWidth_Sub(uint8_t value);
uint8_t PWM_Get_PulseWidth(void);
void PWM_WidthPercent_Set(uint8_t new_value);

#endif

