[findTerminal]
SELECT * FROM sys_terminal WHERE terminalid=$P{terminalid} 

[findMacAddress]
SELECT * FROM sys_terminal WHERE macaddress=$P{macaddress} 