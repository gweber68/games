0CLS:POKE-902,PEEK(63795):F=.25+RND(1)/4:W=INT(4*RND(1)-1.5)/10:B%=6+24*RND(1)
1X=0:Y=1:C=0:?@280+B%,CHR$(27)"V�"SPACE$(9-E)"�":?@200,"S:"S:?"L:"5-L:?"W:"W
2C=C+F:?@C," ��":IFXTHEN?@OX+40*OY%," ":OX=X:OY%=Y:Y=Y+.3:X=X+W+F/5:GOTO6
4IFINKEY$=" "ANDX=0THENX=C+2:F=F*2:OX=0:OY%=0
5IFC>=37THEN?@37,"    ":C=0:GOTO2ELSE2
6IFY<7.01THEN?@INT(X)+40*FIX(Y),"�":GOTO4
7IFX>=B%+1ANDX<=B%+10-ETHEN?@98,"Hit!":CALL4811:S=S+10*(E+1):E=E-(E<8):GOTO0
8L=L+1:IFL<5THEN?@98,"MISS!":CALL4811:GOTO0ELSE?@95,"Game over"
