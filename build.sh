# build a small demo init
#!/bin/bash
rm -rf bin
mkdir bin
fasmg init.asm bin/init
echo "include	'header/include/ez80.inc'" > init_ti.asm
echo "include	'header/include/tiformat.inc'" >> init_ti.asm
echo "format	ti executable archived 'INIT'" >> init_ti.asm
echo "file	'bin/init'" >> init_ti.asm
fasmg init_ti.asm bin/INIT.8xp
# cleanup
rm init_ti.asm
 
