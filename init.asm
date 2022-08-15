include	'header/include/ez80.inc'
; kernel header
include	'header/asm-errno.inc'
include	'header/asm-signal.inc'
include	'header/asm-boot.inc'
include	'header/asm-leaf.inc'

entry main

section '.text' executable
main:
; install signal handler for SIGCHLD
	ld	hl, SIGCHLD
	ld	de, handler_chld
	syscall	_signal
; now just wait
.trap:
	ld	hl, 5*100
	syscall	_usleep
	jr	.trap	

handler_chld:
; we are pid 1, wait on all children to be reaped
	ld	hl, -1
	ld	bc, 0
	ld	de, WNOHANG
	call	_waitpid
	or	a, a
	add	hl, bc
	sbc	hl, bc
	ret	z
	ld	bc, ECHILD
	or	a, a
	adc	hl, bc
	ret	z
	jr	handler_chld