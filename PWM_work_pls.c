#include "pwm_work_pls.h"
#include "system.h"

int main(void)
{
   alt_u32 period, pulse_width;
   alt_u8 enable = 0;
   IOWR(PWM_CUSTOM_0_BASE, 2, enable);

   while(1) {

	   // read enable from SW17
	   enable = (IORD(SLIDER_SWITCHES_BASE, 0)&0x20000)?1:0;

	   //read from switches to determine pulse width
	   pulse_width = IORD(SLIDER_SWITCHES_BASE, 0)&0xFF;

	   //set the PWM period
	   period = (IORD(SLIDER_SWITCHES_BASE,0)&0xFF00) >> 8;

	   //output the period to the PWM
	   IOWR(PWM_CUSTOM_0_BASE, PWM_PERIOD_REG, period);
	   alt_u32 test_period = IORD(PWM_CUSTOM_0_BASE, PWM_PERIOD_REG);

	   //output the pulse width value to the PWM
	   IOWR(PWM_CUSTOM_0_BASE, PWM_PULSE_WIDTH_REG, pulse_width);
	   alt_u32 test_pw = IORD(PWM_CUSTOM_0_BASE, PWM_PULSE_WIDTH_REG);
       if ((test_pw == pulse_width) && (test_period == period)) {

    	   IOWR(PWM_CUSTOM_0_BASE, PWM_ENABLE_REG, enable);
       }

   }

    return 0;
}
