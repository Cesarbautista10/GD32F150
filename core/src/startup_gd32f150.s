/* GCC startup. Vector order follows the included GigaDevice ARM startup. */
.syntax unified
.cpu cortex-m3
.thumb
.section .isr_vector,"a",%progbits
.global __Vectors
.type __Vectors,%object
__Vectors:
    .word _estack
    .word Reset_Handler
    .word NMI_Handler
    .word HardFault_Handler
    .word MemManage_Handler
    .word BusFault_Handler
    .word UsageFault_Handler
    .word 0
    .word 0
    .word 0
    .word 0
    .word SVC_Handler
    .word DebugMon_Handler
    .word 0
    .word PendSV_Handler
    .word SysTick_Handler
    .word WWDGT_IRQHandler
    .word LVD_IRQHandler
    .word RTC_IRQHandler
    .word FMC_IRQHandler
    .word RCU_IRQHandler
    .word EXTI0_1_IRQHandler
    .word EXTI2_3_IRQHandler
    .word EXTI4_15_IRQHandler
    .word TSI_IRQHandler
    .word DMA_Channel0_IRQHandler
    .word DMA_Channel1_2_IRQHandler
    .word DMA_Channel3_4_IRQHandler
    .word ADC_CMP_IRQHandler
    .word TIMER0_BRK_UP_TRG_COM_IRQHandler
    .word TIMER0_Channel_IRQHandler
    .word TIMER1_IRQHandler
    .word TIMER2_IRQHandler
    .word TIMER5_DAC_IRQHandler
    .word 0
    .word TIMER13_IRQHandler
    .word TIMER14_IRQHandler
    .word TIMER15_IRQHandler
    .word TIMER16_IRQHandler
    .word I2C0_EV_IRQHandler
    .word I2C1_EV_IRQHandler
    .word SPI0_IRQHandler
    .word SPI1_IRQHandler
    .word USART0_IRQHandler
    .word USART1_IRQHandler
    .word 0
    .word CEC_IRQHandler
    .word 0
    .word I2C0_ER_IRQHandler
    .word 0
    .word I2C1_ER_IRQHandler
    .word I2C2_EV_IRQHandler
    .word I2C2_ER_IRQHandler
    .word USBD_LP_IRQHandler
    .word USBD_HP_IRQHandler
    .word 0
    .word 0
    .word 0
    .word USBDWakeUp_IRQHandler
    .word CAN0_TX_IRQHandler
    .word CAN0_RX0_IRQHandler
    .word CAN0_RX1_IRQHandler
    .word CAN0_SCE_IRQHandler
    .word SLCD_IRQHandler
    .word DMA_Channel5_6_IRQHandler
    .word 0
    .word 0
    .word SPI2_IRQHandler
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word 0
    .word CAN1_TX_IRQHandler
    .word CAN1_RX0_IRQHandler
    .word CAN1_RX1_IRQHandler
    .word CAN1_SCE_IRQHandler
.size __Vectors, .-__Vectors

.section .text.Reset_Handler,"ax",%progbits
.global Reset_Handler
.type Reset_Handler,%function
.thumb_func
Reset_Handler:
    ldr r0, =_sidata
    ldr r1, =_sdata
    ldr r2, =_edata
1:
    cmp r1, r2
    bcs 2f
    ldr r3, [r0], #4
    str r3, [r1], #4
    b 1b
2:
    ldr r1, =_sbss
    ldr r2, =_ebss
    movs r3, #0
3:
    cmp r1, r2
    bcs 4f
    str r3, [r1], #4
    b 3b
4:
    bl SystemInit
    bl __libc_init_array
    bl main
    b .
.size Reset_Handler, .-Reset_Handler

.section .text.Default_Handler,"ax",%progbits
.type Default_Handler,%function
.thumb_func
Default_Handler:
    b .
.size Default_Handler, .-Default_Handler

.weak NMI_Handler
.thumb_set NMI_Handler, Default_Handler
.weak HardFault_Handler
.thumb_set HardFault_Handler, Default_Handler
.weak MemManage_Handler
.thumb_set MemManage_Handler, Default_Handler
.weak BusFault_Handler
.thumb_set BusFault_Handler, Default_Handler
.weak UsageFault_Handler
.thumb_set UsageFault_Handler, Default_Handler
.weak SVC_Handler
.thumb_set SVC_Handler, Default_Handler
.weak DebugMon_Handler
.thumb_set DebugMon_Handler, Default_Handler
.weak PendSV_Handler
.thumb_set PendSV_Handler, Default_Handler
.weak SysTick_Handler
.thumb_set SysTick_Handler, Default_Handler
.weak WWDGT_IRQHandler
.thumb_set WWDGT_IRQHandler, Default_Handler
.weak LVD_IRQHandler
.thumb_set LVD_IRQHandler, Default_Handler
.weak RTC_IRQHandler
.thumb_set RTC_IRQHandler, Default_Handler
.weak FMC_IRQHandler
.thumb_set FMC_IRQHandler, Default_Handler
.weak RCU_IRQHandler
.thumb_set RCU_IRQHandler, Default_Handler
.weak EXTI0_1_IRQHandler
.thumb_set EXTI0_1_IRQHandler, Default_Handler
.weak EXTI2_3_IRQHandler
.thumb_set EXTI2_3_IRQHandler, Default_Handler
.weak EXTI4_15_IRQHandler
.thumb_set EXTI4_15_IRQHandler, Default_Handler
.weak TSI_IRQHandler
.thumb_set TSI_IRQHandler, Default_Handler
.weak DMA_Channel0_IRQHandler
.thumb_set DMA_Channel0_IRQHandler, Default_Handler
.weak DMA_Channel1_2_IRQHandler
.thumb_set DMA_Channel1_2_IRQHandler, Default_Handler
.weak DMA_Channel3_4_IRQHandler
.thumb_set DMA_Channel3_4_IRQHandler, Default_Handler
.weak ADC_CMP_IRQHandler
.thumb_set ADC_CMP_IRQHandler, Default_Handler
.weak TIMER0_BRK_UP_TRG_COM_IRQHandler
.thumb_set TIMER0_BRK_UP_TRG_COM_IRQHandler, Default_Handler
.weak TIMER0_Channel_IRQHandler
.thumb_set TIMER0_Channel_IRQHandler, Default_Handler
.weak TIMER1_IRQHandler
.thumb_set TIMER1_IRQHandler, Default_Handler
.weak TIMER2_IRQHandler
.thumb_set TIMER2_IRQHandler, Default_Handler
.weak TIMER5_DAC_IRQHandler
.thumb_set TIMER5_DAC_IRQHandler, Default_Handler
.weak TIMER13_IRQHandler
.thumb_set TIMER13_IRQHandler, Default_Handler
.weak TIMER14_IRQHandler
.thumb_set TIMER14_IRQHandler, Default_Handler
.weak TIMER15_IRQHandler
.thumb_set TIMER15_IRQHandler, Default_Handler
.weak TIMER16_IRQHandler
.thumb_set TIMER16_IRQHandler, Default_Handler
.weak I2C0_EV_IRQHandler
.thumb_set I2C0_EV_IRQHandler, Default_Handler
.weak I2C1_EV_IRQHandler
.thumb_set I2C1_EV_IRQHandler, Default_Handler
.weak SPI0_IRQHandler
.thumb_set SPI0_IRQHandler, Default_Handler
.weak SPI1_IRQHandler
.thumb_set SPI1_IRQHandler, Default_Handler
.weak USART0_IRQHandler
.thumb_set USART0_IRQHandler, Default_Handler
.weak USART1_IRQHandler
.thumb_set USART1_IRQHandler, Default_Handler
.weak CEC_IRQHandler
.thumb_set CEC_IRQHandler, Default_Handler
.weak I2C0_ER_IRQHandler
.thumb_set I2C0_ER_IRQHandler, Default_Handler
.weak I2C1_ER_IRQHandler
.thumb_set I2C1_ER_IRQHandler, Default_Handler
.weak I2C2_EV_IRQHandler
.thumb_set I2C2_EV_IRQHandler, Default_Handler
.weak I2C2_ER_IRQHandler
.thumb_set I2C2_ER_IRQHandler, Default_Handler
.weak USBD_LP_IRQHandler
.thumb_set USBD_LP_IRQHandler, Default_Handler
.weak USBD_HP_IRQHandler
.thumb_set USBD_HP_IRQHandler, Default_Handler
.weak USBDWakeUp_IRQHandler
.thumb_set USBDWakeUp_IRQHandler, Default_Handler
.weak CAN0_TX_IRQHandler
.thumb_set CAN0_TX_IRQHandler, Default_Handler
.weak CAN0_RX0_IRQHandler
.thumb_set CAN0_RX0_IRQHandler, Default_Handler
.weak CAN0_RX1_IRQHandler
.thumb_set CAN0_RX1_IRQHandler, Default_Handler
.weak CAN0_SCE_IRQHandler
.thumb_set CAN0_SCE_IRQHandler, Default_Handler
.weak SLCD_IRQHandler
.thumb_set SLCD_IRQHandler, Default_Handler
.weak DMA_Channel5_6_IRQHandler
.thumb_set DMA_Channel5_6_IRQHandler, Default_Handler
.weak SPI2_IRQHandler
.thumb_set SPI2_IRQHandler, Default_Handler
.weak CAN1_TX_IRQHandler
.thumb_set CAN1_TX_IRQHandler, Default_Handler
.weak CAN1_RX0_IRQHandler
.thumb_set CAN1_RX0_IRQHandler, Default_Handler
.weak CAN1_RX1_IRQHandler
.thumb_set CAN1_RX1_IRQHandler, Default_Handler
.weak CAN1_SCE_IRQHandler
.thumb_set CAN1_SCE_IRQHandler, Default_Handler

.section .note.GNU-stack,"",%progbits
