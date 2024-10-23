; 10 SYS4096

*=$0801

        BYTE    $0B, $08, $0A, $00, $9E, $34, $30, $39, $36, $00, $00, $00

*=$1000

Start
        JSR INIT
        JSR LEFT_RIGHT
        JSR TOP_DOWN
        JSR RIGHT_LEFT
        JSR DOWN_TOP
        RTS
INIT
        LDA #$00
        STA 251
        LDA #$04
        STA 252 ; store 1024 at address 251, 252
        LDA #$28
        STA 253 ; x
        LDA #$18
        STA 254 ; Y
        LDY #$00
        LDA #'+'
        RTS

LEFT_RIGHT
                     ; horizontal left to right
        LDX 253        
CLEARLINE
        STA (251),Y
        INY
        DEX
        BNE CLEARLINE

        DEC 253 ; x=x-1
        LDA 251 
        ADC 253 ; a=a+x
        BCC NEXT1
        CLC ; carry bit not reset before the next adc
        INC 252
NEXT1
        STA 251
        RTS

TOP_DOWN
                ; vertical top down
        LDX 254
NEXT2
        LDA #'+'
        STA (251),Y
        LDA 251
        ADC #40 ; 1 line below
        BCC NEXT3
        CLC
        INC 252
NEXT3
        STA 251
        DEX
        BNE NEXT2
        
        DEC 254 ; y=y-1
        DEC 251 ; 
        BCC NO_CARRY3
        CLC
        DEC 252
NO_CARRY3
        RTS

RIGHT_LEFT
                ; horizontal right to left.
        LDY #$0 
        LDX 253
NEXT4
        LDA #'+'
        STA (251),Y
        DEC 251
        BCC NO_CARRY4
        CLC
        DEC 252
NO_CARRY4
        DEX        
        BNE NEXT4
        DEC 253 ; x=x-1
        LDA 251
        SEC ; set the carry bit, because not -1 is substracted
        SBC #39
        BCS NO_CARRY5
        CLC
        DEC 252
NO_CARRY5
        STA 251
        RTS

DOWN_TOP
                ; vertical bottom top
        LDX 254
NEXT5
        LDA #'+'
        STA (251),Y
        LDA 251
        SEC
        SBC #40
        BCS NO_CARRY6
        CLC
        DEC 252
NO_CARRY6
        STA 251
        DEX
        BNE NEXT5
        DEC 254
        RTS
