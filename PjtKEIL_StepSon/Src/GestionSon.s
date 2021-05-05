	PRESERVE8
	THUMB   
		

; ====================== zone de r�servation de donn�es,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
		
SortieSon	dcw 0 ;16 bits
	EXPORT SortieSon
		
Index dcw 0

	
; ===============================================================================================
	
	EXPORT CallbackSon
	IMPORT Son
	IMPORT LongueurSon

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
; �crire le code ici	

	include ./Driver/DriverJeuLaser.inc

CallbackSon proc
		push {r4, lr} 

		; S'arrete quand on a parcouru l'ensemble du tableau
		ldr r1, =Index
		ldrsh r2, [r1]

		ldr r3, =LongueurSon
		ldr r4, [r3]

		cmp r2, r4
		beq Fin

		; SortieSon = Son[Index]
		ldr r3, =Son
		ldrsh r0,[r3, r2, lsl #1]
		add r0, #32768 ; mise � l'�chelle de SortieSon [-32 768 ; 32 767] -> [0 ; 65 535]
		mov r5, #92
		udiv r0, r5 ; [0 ; 65 535] -> [0 ; 712]
		ldr r4, =SortieSon
		strh r0, [r4]
		
		; Index ++
		add r2, #1 
		strh r2, [r1]

Fin
        ldr r4, =SortieSon
		ldrh r0, [r4]
		bl PWM_Set_Value_TIM3_Ch3
		pop {r4, pc}
		bx lr
		endp
			
StartSon proc
		push{lr}
		
		pop{pc}
		endp

	
	END	