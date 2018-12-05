#########################################################################
# File Name: ADD_COLOR.sh
# Author: tanyueyun
# mail: 83357697@qq.com
# Created Time: 2016年11月19日 星期六 16时00分38秒
#########################################################################
#!/bin/sh

RES='\E[0m'
RED_COLOR='\E[1;31m'
GREEN_COLOR='\E[1;32m'
YELLOW_COLOR='\E[1;33m'
BLUE_COLOR='\E[1;34m'
PURPLR_COLOR='\E[1;35m'
SKY_BLUE_COLOR='\E[1;36m'
BLACK_COLOR='\E[30m'
WHITE_COLOR='\E[1;37m'

ADD_COLOR(){
    case `echo $1|tr "[A-Z]" "[a-z]"` in
        31) 
           shift
            echo -e "$RED_COLOR$* $RES"
            exit
            ;;  
        32)
            shift
            echo -e "$GREEN_COLOR$* $RES"
            exit
            ;; 

        33) 
            shift
            echo -e "$YELLOW_COLOR$* $RES"
            exit
            ;;  
        34)
            shift
            echo -e "$BLUE_COLOR$* $RES"
            exit
            ;; 
        35) 
            shift
            echo -e "$PURPLR_COLOR$* $RES"
            exit
            ;;  
        36)
            shift
            echo -e "$SKY_BLUE_COLOR$* $RES"
            exit
	    ;;
        30)
            shift
            echo -e "$BLACK_COLOR$* $RES"
            exit
            ;;
        37)
            shift
            echo -e "$WHITE_COLOR$* $RES"
            exit
    
    esac                        
                                            
}                                                       
                                                                    
#ADD_COLOR  $*
