#include <stdio.h>
#include "freertos/FreeRTOS.h"
#include "freertos/task.h" 
#include "driver/i2c_master.h"
#include "esp_log.h"
#include "TempSensorTC74.c"
#include "driver/ledc.h"


#define LEDC_TIMER_SPEED    LEDC_LOW_SPEED_MODE
#define LEDC_TIMER_BIT      LEDC_TIMER_13_BIT
#define LEDC_CHANNEL        LEDC_CHANNEL_0
#define LEDC_GPIO_PIN       4   // Change this to your LED GPIO pin

#define MIN_TEMP 20    // Minimum temperature value
#define MAX_TEMP 35  // Maximum temperature value
#define MIN_DUTY 0   // Minimum duty cycle for LEDC
#define MAX_DUTY 8191 // Maximum duty cycle for LEDC (13-bit)

uint32_t map(uint32_t value, uint32_t fromLow, uint32_t fromHigh, uint32_t toLow, uint32_t toHigh);


uint8_t sensorAddr = 0x49;  
int sdaPin = 0;     
int sclPin = 1; 
uint32_t clkSpeedHz = 50000;


void ledc_init(void) {
    ledc_timer_config_t ledc_timer = {
        .duty_resolution = LEDC_TIMER_BIT,
        .freq_hz = 5000,  // LEDC PWM frequency
        .speed_mode = LEDC_TIMER_SPEED,
        .timer_num = LEDC_TIMER_0
    };
    ledc_timer_config(&ledc_timer);

    ledc_channel_config_t ledc_channel = {
        .channel    = LEDC_CHANNEL,
        .duty       = 0,
        .gpio_num   = LEDC_GPIO_PIN,
        .speed_mode = LEDC_TIMER_SPEED,
        .timer_sel  = LEDC_TIMER_0
    };
    ledc_channel_config(&ledc_channel);
}

void app_main(void) {
    i2c_master_bus_handle_t i2cBusHandle;
    i2c_master_dev_handle_t i2cDevHandle;
    tc74_init(&i2cBusHandle, &i2cDevHandle, sensorAddr, sdaPin, sclPin, clkSpeedHz);

    tc74_wakeup(i2cDevHandle);

    ledc_init();

    uint8_t prevTemp = 0;

    while(1)
    {    
        uint8_t rxBuf[1];
        tc74_read_temp_after_temp(i2cDevHandle, rxBuf);

        // Convert temperature value to duty cycle
        uint32_t duty = map(rxBuf[0], MIN_TEMP, MAX_TEMP, MIN_DUTY, MAX_DUTY);

        // Set LED brightness
        ledc_set_duty(LEDC_TIMER_SPEED, LEDC_CHANNEL, duty);
        ledc_update_duty(LEDC_TIMER_SPEED, LEDC_CHANNEL);
    
        if (rxBuf[0] != prevTemp) {
            printf("\nTemperature: %d",rxBuf[0]);
            prevTemp = rxBuf[0]; // Update previous temperature value
        }

        // ESP_LOGI("i2cTempSens","Temperature: %d",rxBuf[0]);
        vTaskDelay(10);
    }
}


// Function to map a value from one range to another
uint32_t map(uint32_t value, uint32_t fromLow, uint32_t fromHigh, uint32_t toLow, uint32_t toHigh) {
    return (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow) + toLow;
}

