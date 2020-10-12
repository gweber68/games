*=$0500

; copies from /1 to /2 until a 0 is found at /1
defm            COPY0
                LDY #0
@nextch         LDA /1,y
                beq @exitmac
                sta /2,y
                iny
                jmp @nextch
@exitmac
                endm

; copies up to 40 characters from /1 (offset in y) to /2
defm            COPY40
                tya      ; push y
                pha

                LDX #0
@nextch         LDA /1,y
                beq @start_over
                sta /2,x
                iny
                inx
                cpx #40
                beq @exitmac
                jmp @nextch 

@start_over     ldy #0  ; start from the beginning of the string
                jmp @nextch

@exitmac        pla     ; restore y
                tay
                endm


start
                COPY0 enemy, enemy_loc
                COPY0 radar1,radar1_loc
                COPY0 radar2,radar2_loc
                COPY0 radar3,radar3_loc
                COPY0 radar4,radar4_loc

                ldx #40
                lda #99
horizon_loop    STA hor_loc,x
                dex
                bne horizon_loop

                COPY0 bottom_ret1,bottom_ret1_loc
                COPY0 bottom_ret2,bottom_ret2_loc
                COPY0 bottom_ret3,bottom_ret3_loc

reset_bg        ldy #0

bg_loop         tya
                pha
                COPY40 bg0,bg_loc
                COPY40 bg1,bg_loc+40
                COPY40 bg2,bg_loc+80
                COPY40 bg3,bg_loc+120
                COPY40 bg4,bg_loc+160
                COPY40 bg5,bg_loc+200

                COPY0 top_ret1,top_ret1_loc
                COPY0 top_ret2,top_ret2_loc
                COPY0 top_ret3,top_ret3_loc

waiting         lda 151
                cmp #$ff
                bne akey
                pla
                tay
                jmp bg_loop
akey            cmp #48  ; 0 = reset
                bne maybe_left
                pla
                jmp reset_bg

maybe_left      cmp #74  ; j
                bne maybe_right
                pla
                tay
                dey
                cpy #$ff
                beq goto_end
                jmp bg_loop
goto_end        ldy #79
                jmp bg_loop
maybe_right     CMP #76 ; l
                bne waiting
                pla
                tay
                iny
                cpy #80
                beq done
                jmp bg_loop
                             
done            jmp reset_bg
                rts

hor_loc        = 32767+40*14

radar1_loc     = $8011
radar2_loc     = radar1_loc+41
radar3_loc     = radar1_loc+80
radar4_loc     = radar1_loc+162
radar1         byte $4d,$20,$5d,$20,$4e,0
radar2         byte $4d,$20,$4e,0
radar3         byte $40,$20,42,$20,$40,0
radar4         byte $5d, 0

; bottom reticle
bottom_ret1_loc = 32768+16*40+17
bottom_ret2_loc = bottom_ret1_loc+40
bottom_ret3_loc = bottom_ret2_loc+42
bottom_ret1    byte 101,$20,$20,$20,103,0
bottom_ret2    byte 99,99,$5D,99,99,0
bottom_ret3    byte $5d,0

; top reticle
top_ret1_loc   = 32768+9*40+19
top_ret2_loc   = top_ret1_loc+40-2
top_ret3_loc   = top_ret2_loc+40
top_ret1       byte $5D,0
top_ret2       byte 100,100,93,100,100,0
top_ret3       byte 101,$20,$20,$20,103,0

enemy_loc       = 32768
enemy           null 'enemy in range'

; backgrounds
bg_loc         =32768+8*40
bg0            null '.UI               .                                                     .     *'
bg1            null '.JK                             *             .                              .*'
bg2            null '.   NM     .                          W    NM    .             Q              *'
bg3            null '.  N  MNM               .  NMNM           N  MNM                  NMNM        *'
bg4            text '.',99,99,'   N  M     N',99,99,99,'M      N  M M',100,'      N',99,99,'   N  M     N',99,99,99,'M      N  M M',100,'      N',0
bg5            text '.    N    M   N     ',99,'M   N    M  M NM N     N    M   N     ',99,'M   N    M  M NM N*',0