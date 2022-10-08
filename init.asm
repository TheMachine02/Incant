include	'header/include/ez80.inc'
; kernel header
include	'header/asm-errno.inc'
include	'header/asm-signal.inc'
include	'header/asm-boot.inc'
include	'header/asm-leaf.inc'
include	'header/asm-syscall.inc'

; wait pid option parameter
define	WNOHANG					1 shl 0
define	WUNTRACED				1 shl 1
define	WCONTINUED				1 shl 2

; exit flags
define	EXITED					1 shl 0
define	SIGNALED				1 shl 1
define	COREDUMP				1 shl 2

include	'crc.asm'

entry main

section '.text' executable
main:
; install signal handler for SIGCHLD
	ld	hl, SIGCHLD
	ld	de, handler_chld
	call	_signal
; now just wait (launch service, mount from /etc/fstab)
	jp	trap

handler_chld:
; we are pid 1, wait on all children to be reaped
	ld	hl, -1
	ld	de, 0
	ld	bc, WNOHANG
	or	a, a
	add	hl, bc
	sbc	hl, bc
	ret	z
	ld	bc, ECHILD
	or	a, a
	adc	hl, bc
	ret	z
	jr	handler_chld
