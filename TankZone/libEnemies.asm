; create a random # of enemies and populate the arrays ,below
incasm "macroMath.asm"

create_enemies
                ; pick a random number
                ldx #5 ; decided by fair dice roll
                stx num_enemies

create_enemy  
                lda #1
                sta enemy_exists,x
                RND
                lda #$ff
                sta enemy_health,x

                ; pick a radius
                RND
                sta enemy_radius,x

                RND
                ; change to a random number between 0 and 3
                and #3
                clc
                adc #1 ; now 1-4...ignore type 5 for now.
                sta enemy_type,x

                RND
                ; can only go from 0 to 160, so if it's too big, truncate
                cmp #160
                bcc store_theta ;; blt
                lda #160
store_theta     sta enemy_theta,x

                dex
                bne create_enemy
                rts


num_enemies     byte 0
; whether this enemy exists
enemy_exists    dcb 10,0
; the theta is from 0 to $a0
enemy_theta     dcb 10,0
; the radius from -127 to +127
enemy_radius    dcb 10,0
; Equivalent x & y locations, maybe.
enemy_x         dcw 10,0
enemy_y         dcw 10,0
; Enumeration of enemy types
NONE=0
SQUARE_BLOCK=1
PYRAMID_BLOCK=2
TANK_ENEMY=3
UFO_ENEMY=4
TRIANGULAR_TANK_ENEMY=5
enemy_type      dcb 10,0
; Health level of enemy
enemy_health    dcb 10,0
