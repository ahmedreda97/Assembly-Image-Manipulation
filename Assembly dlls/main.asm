include irvine32.inc
.data
RR SDWORD 30
GG SDWORD 59
BB SDWORD 11
divv sdword 100
nintensity SDWORD ?
window byte 10000 dup (?)
i Dword 0	;i
j Dword 0	;j
imax dword ?
imin sdword ?
jmax dword ?
jmin sdword ?
moves dword ?
cols dword ?
rows dword ?
newi dword ?
newj dword ?
filled dword 0


.code

Brightness PROC Redd : PTR SDWORD, Greenn : PTR SDWORD, Bluee : PTR SDWORD, Sizee : DWORD, Vl : SDWORD

pushad
mov ecx, Sizee
mov ebx, Vl
mov eax, Redd
mov esi, Bluee
mov edi, Greenn
L1 :
add SDWORD PTR[eax],ebx
add SDWORD PTR[esi], ebx
add SDWORD PTR[edi], ebx

cmp SDWORD PTR[eax], 255
jg R5
B4 :
cmp SDWORD PTR[esi], 255
jg B5
G4 :
cmp SDWORD PTR[edi], 255
jg G5
jmp done
R5 :
mov SDWORD PTR[eax], 255
jmp B4
B5 :
mov SDWORD PTR[esi], 255
jmp G4
G5 :
mov SDWORD PTR[edi], 255

done:
cmp SDWORD PTR[eax], 0
jl R1
B1 :
cmp SDWORD PTR[esi], 0
jl B2
G1 :
cmp SDWORD PTR[edi], 0
jl G2
jmp donee
R1 :
mov SDWORD PTR[eax], 0
jmp B1
B2 :
mov SDWORD PTR[esi], 0
jmp G1
G2 :
mov SDWORD PTR[edi], 0

donee :
	add eax, 4
	add esi, 4
	add edi, 4

	loop L1


	popad
	ret
	Brightness ENDP

GreyScale proc  Redd : PTR SDWORD, Greenn : PTR SDWORD, Bluee : PTR SDWORD, Sizee : DWORD
pushad
mov ecx,Sizee
mov ebx,Redd
mov esi,Greenn
mov edi,Bluee
	L1:
mov eax,[ebx]
mul RR
mov [ebx],eax

mov eax, [esi]
mul GG
mov[esi], eax

mov eax, [edi]
mul BB
mov[edi], eax

mov eax,[ebx]
add eax,[esi]
add eax,[edi]
idiv divv
mov [ebx],eax
mov [esi],eax
mov [edi],eax

add ebx, 4
add esi, 4
add edi, 4
loop L1
popad
	ret

	GreyScale ENDP



NoiseRemoval Proc array: Ptr byte , Sizee: Dword , N: Dword , M: Dword	, windowsize: dword	;N=Rows,M=Columns
pushad
mov esi,array
movzx eax,byte ptr[esi]
mov eax,windowsize
mov moves,eax
shr moves,1
mov eax,N
mov rows,eax
mov eax,M
mov cols,eax


mov ecx,rows
mov i,0
outerprocess:
	push ecx
	mov ecx,cols

	innerprocess:
	push ecx
	mov eax,i      ;cont adds the moves on the boundaries of the window to be bounded in the image
	mov imax,eax
	mov imin,eax
	mov eax,j
	mov jmin,eax
	mov jmax,eax

	mov eax,moves

	sub imin,eax
	cmp imin,0
	jge cont1
	mov imin,0

	cont1:
	sub jmin,eax
	cmp jmin,0
	jge cont2
	mov jmin,0

	cont2:
	add imax,eax
	mov edx,imax
	cmp edx,rows
	jb cont3
	mov edx,rows
	dec edx
	mov imax,edx

	cont3:
	add jmax,eax
	mov edx,jmax
	cmp edx,cols
	jb operation
	mov edx,cols
	dec edx
	mov jmax,edx

	operation:
	mov ebx,esi ; ebx is the cursor of the array

	mov eax,i
	sub eax,imin
	mul cols
	mov edx,j
	sub edx,jmin
	add eax,edx
	sub ebx,eax ; ebx is the first element to be taken
	
	mov eax,imin	;indices of the first element to be taken
	mov newi,eax
	mov eax,jmin
	mov newj,eax
;------------------------
		mov ecx,windowsize
		mov edi,offset window
		mov filled,0
		windowloop1:
		push ecx 
		mov ecx,windowsize
			windowloop2:

				mov eax,imin	;check the newi and newj to be inside the window
				cmp newi,eax
				jb done

				
				mov eax,imax
				cmp newi,eax
				ja done

				
				mov eax,jmin
				cmp newj,eax
				jb done

				mov eax,jmax
				cmp newj,eax
				ja done

				mov eax,0 ;correctttt
				mov al,byte ptr [ebx]
				mov byte ptr [edi],al
				inc ebx
				inc edi
				inc filled

				done:
				inc newj
			loop windowloop2
			pop ecx
			mov eax,cols
			dec eax
			sub eax,jmax
			add eax,jmin
			add ebx,eax
			mov eax,jmin
			mov newj,eax
			inc newi
		loop windowloop1
		
	mov eax,windowsize
	mul eax
	mov ecx,eax
	sub ecx,filled
	jz general
	samevalue:
				mov eax,0 ;correctttt
				mov al,byte ptr [esi]
				mov byte ptr [edi],al	
				inc edi
	loop samevalue
	general:
	mov eax,windowsize
	mul eax
	dec eax
	call BubbleSort
	inc eax
	shr eax,1
	mov edi,offset window
	mov dl,byte ptr[edi+eax]
	mov byte ptr[esi],dl
	mov al,byte ptr [esi]

	pop ecx


	inc j
	inc esi
	dec ecx
	jne innerprocess

	mov j,0
	inc i
	pop ecx
	dec ecx
jne outerprocess

popad
ret
NoiseRemoval Endp




BubbleSort Proc uses eax ecx esi
mov ecx,eax
outloop:
push ecx
mov esi,offset window
innerloop:
mov al,byte ptr[esi]
cmp al,byte ptr[esi+1]
jb less
xchg al,byte ptr[esi+1]
mov byte ptr [esi],al
less:
inc esi
loop innerloop
pop ecx
loop outloop
ret
BubbleSort Endp 

DllMain PROC hInstance:DWORD, fdwReason:DWORD, lpReserved:DWORD
mov eax, 1 
ret
DllMain ENDP
END DllMain