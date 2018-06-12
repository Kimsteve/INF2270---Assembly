.globl _sprinter
.globl sprinter
.extern _my_ftoa

# Navn: sprinter.
# Synopsis: simplified sprinf function.
# C-signatur: char *sprinter(char *res, char *format, ...)
# Register: al is being moved, -8(%ebp) to hold return value.

sprinter:
_sprinter:    #source  destination
		pushl %ebp				# Save old %ebp
		movl  %esp, %ebp		# set %ebp as frame pointer.
     	
		movl   8(%ebp), %ecx  	# first par
		movl   12(%ebp), %edx	# second.
		leal   16(%ebp), %ebx   # third param 
        movl   $0,  -8(%ebp)    #using a local variable to get hold of our return value
        addl   $-8,  %esp       #taking %esp to the right position-> simce i used -8(%ebp) as my local variable

copyLoopStart: 
		movb (%edx), %al        #move edx(the second parameter to al)
		incl %edx               #++ edx index
		cmpb $37, %al          	#check if al== %  
		je  checknext 			 #if above is true jump to checknext to anylize the char that follows
		movb %al, (%ecx)    	#til = AL
		incl %ecx               #++
		cmpb $0, %al         
		je returnTheValue       # 0 = end jump returnthevalue
        incl -8(%ebp)			# increase return value
		jne  copyLoopStart  		#if al !=0 contin' looping	


returnTheValue: 
		movl -8(%ebp), %eax	# til
        movl %ebp, %esp
        popl  %ebp      # restore %ebp frame pointer
		ret   			# return   

 #checking the specific char that follow % 
 # jmp to their respective function
checknext:
			movb (%edx), %al	#
			incl  %edx	              #increse edx      
			cmpb $37, %al             #if al== %
			je checkPercentage
			cmpb $99, %al             #if al ==c
			je checkchar
			cmpb $100, %al            #if al==d
			je checkDecimal
			cmpb $115, %al            # if al==s
			je checkString
			cmpb $102, %al            #al==f
			je checkDouble
            cmpb $120, %al	      #if al == x
            je	checkHex



checkchar:  

			movb (%ebx), %al         #get al of ebx
			addl $4, %ebx            #add ebx by 4 for later parameters  
			movb %al, (%ecx)         # to ecx
			incl %ecx
            incl -8(%ebp)            #++ return value   
			jmp copyLoopStart	     # back to copyLoopStart	

checkPercentage:                      # if al==%                     
			movb $37, %al	          #37 to al for display
			movb %al, (%ecx)
			incl %ecx
            incl -8(%ebp)             #++ return value 
			jmp copyLoopStart		


checkDecimal: 					
						
			pushl %edx	              # save the content of edx from previous operations
			movl $0, %esi             # esi is the counter   
			movl $10, %edi            # the divisor   
			movl (%ebx), %eax         # get the dividend from the param
			addl $4, %ebx             # for the next parameter
            jmp checkSign

#check the sign of the param
#by shifting 
#Specification count  31

checkSign:
            pushl	%eax             # save the original value 
            shrl	$31, %eax        #shift right >> 31 
            cmpl	$0, %eax         # check if eax ==0 
            popl	%eax             # restore the original value of eax 

            je  signPositive         #if 0=< eax   
            jne signNegative         #if 0> eax


signPositive:

            movl $0, %edx           #set edx to 0
			divl %edi               # divide by 10
            jmp checkEax            # check the other content of eax 

# convert # by twos compliment 
# and then jmp to positive sign loop
# the number is treated as positive
			
signNegative:
            decl	%eax           # decrease by 1      
            notl	%eax           #each bit 'NOT ' here
            movb	$45, (%ecx)    #
            incl	%ecx
            incl -8(%ebp)
            jmp	    signPositive   #continue as if the number was positive

# check the remaining content of eax in this loop to get all numbers		
checkEax:
            cmpl $0, %eax      #found the last decimal that is when eax==0
            je saveToStack        # eax==0
            pushl %edx         #save the content of edx
            incl %esi          #++ esi
            movl $0, %edx      #clear edx
            divl %edi           #devide by 10 
            jmp checkEax        # loop

#save the values of edx to stack
saveToStack:
                pushl %edx         #save the last edx
                incl %esi          #++ esi
                #incl -8(%ebp)
                jmp getFromStack         #

# get from stack
# add 48 - ascii- for display
# update exc register

getFromStack:
                cmpl $0, %esi    #check if counter is 0
                je revertEdx     # if so revert to edx to its original value
                decl %esi        # counter esi--
                popl %edx        # get edx from stack 
                addb $48, %dl    # add 48 to enable display. ascii 0==48 or '0'
                movb %dl, (%ecx) # update ecx register
                incl %ecx        #ecx ++ 
                incl -8(%ebp)    # update return value
                jmp getFromStack  #loop until counter, esi==0

# this reverts edx to its original value before any operations
revertEdx: 
        popl %edx
        jmp copyLoopStart  #jmp to this loop
	

checkString:
             
                movl (%ebx), %esi        # mov value to esi
                addl $4, %ebx            #later param
                movb (%esi), %al         # 
                incl %esi                # esi ++
                cmpb $0, %al             #check if got the last
                je copyLoopStart         # if so jump to copyLoopStart
                movb %al, (%ecx)         #otherwise update ecx
                incl %ecx                # ecx ++
                incl -8(%ebp)            #update return value
                jmp readnext 


#asl long as al != null loop to get all the char in the string
readnext:  									

            movb (%esi), %al      
            incl %esi             #esi++
            cmpb $0, %al          #check if end of string is reached
            je copyLoopStart      #jmp to this loop if last reached
            movb %al,  (%ecx)     #update ecx
            incl %ecx             #ecx++
            incl -8(%ebp)         #update return value 
            jmp readnext          #loop


#Hexdecimal
#base value 16
#


checkHex:
            pushl %edx	         #save value of edx
			movl $0, %esi        # esi acts as counter=0
			movl $16, %edi       # base value stored in edi  
			movl (%ebx), %eax    # move param to eax for manipulation
			addl $4, %ebx        # for the next parameter
			
			movl $0, %edx       #edx will hold the remainder while quotient remain in eax
			divl %edi           # divide base 16
            jmp checkHexEax     #check next content of eax

checkHexEax:
            cmpl $0, %eax       #eax ==0 last value reached  
            je pushEdxHex      #if so jump to save edx
            pushl %edx         #save the remainder to stack
            incl %esi          #esi++ counter
            movl $0, %edx      #clear edx for the next operation
            divl %edi          #divide by base 16 --(edi)
            jmp checkHexEax    #loop

#get edx from stack and prepare for display
getEdxHex:

            cmpl $0, %esi       #check if got the last edx from stack by checking if the count ==0
            je revertEdx        # jmp to reverting the original edx
            decl %esi           #esle decrease count and
            popl %edx           #get edx from stack
            cmpl	$10, %edx   #check if edx==10 
            jl IntHex           #if less go to integer hex
            jge CharHex         #else char hex


pushEdxHex:
            pushl %edx         #save the last content of edx to stack
            incl %esi          #increase the count
            jmp getEdxHex         #jmp


#integer Hex for display
IntHex:

            addb $48, %dl     #add ascii start value
            movb %dl, (%ecx)  #update ecx
            incl %ecx         #ecx++
            incl -8(%ebp)     #update return value 
            jmp getEdxHex     # jmp to loop thro stack to get edx       

#char Hex for display
 CharHex:
            subb $10, %dl       # -10 for val a-f
            addb $97, %dl       # ascii a ==97. 
            movb %dl, (%ecx)    #update ecx
            incl %ecx           #ecx ++
            incl -8(%ebp)       #update return value
            jmp getEdxHex       #loop 


checkDouble:
          
            movl (%ebx), %esi   
			addl $4, %ebx  #update the ebx for use of the Next possible parameter
            
            pushl %esi     #second arguement(double f)
            pushl %ecx     #first arguement (char *s) buffer.
        
           	call _my_ftoa         #my_ftoa(char *s, double f)

            #remove parameters 
            popl  %esi
            popl  %ecx 
        
            movl %eax, %ecx  # return value from my_ftoa is stored in eax 
            incl %ecx
            incl -8(%ebp)
			jmp copyLoopStart
            #jmp checkDouble



