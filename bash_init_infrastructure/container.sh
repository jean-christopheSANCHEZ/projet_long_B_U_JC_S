#!/bin/bash


#function : parse_file
    #parse a file (file in the path parameter) and call function
    #parameters : $path, $separator
function parse_file(){
    echo "Parsing file $1 with $2 as a separator"
    file="$1"
    separator="$2"
    declare -A element=( ['node']="test1" ['net']="ip:lol" ['img']="alpine" ['tmp']="tempon" )
    list_network=""
    while IFS= read -r line
    do
	element["tmp"]=${line#*/}
	element["node"]=${line%"${element["tmp"]}"}
	element["img"]=${line#*/*/}
        element["net"]=${element["tmp"]%"${element["img"]}"}
	#removing / from elements
	element["node"]=$(echo ${element["node"]} | sed 's/\///g')
	echo  "node="${element["node"]}
	element["net"]=$(echo ${element["net"]} | sed 's/\///g')
	echo  "net="${element["net"]}
	echo "img="${element["img"]}
	ip=${element["net"]#*:}
	echo $ip
	network=$(echo ${element["net"]%$ip} | sed 's/\://g')
	if [[ "$network" == "rt" ]]
	then
	    echo "need a router"
	else
	    if [[ "$list_network" == *"$network"*  ]]
	    then
	        echo $network" : network already exist"
            else
	        echo "Need to create a new network "$network
	        list_network="$list_network$network"
	        net_tmp=$(echo ${ip%?})
    	        end_addr_net="0/24"
	        net_ip_w_mask=$(echo $net_tmp$end_addr_net)
	        create_network $network $net_ip_w_mask 
	    fi
	    create_single_container ${element["node"]} ${element["img"]} $network $ip
	fi

    done < "$file"
}

#function : open_terminal
    #open a terminal in the current container
    #parameters : $container_name, $image, $number
function open_terminal(){
    xterm -hold -e "$1" &
}

#function : create_containers
    #create new containers
    #parameters : $container_name, $image, $network, $ip, $number
function create_containers(){
    for ((i =1; i <= $5; i++))
    do
        c_create_container="echo $1$i IP:${4}:$3; docker run --net $3 --ip $4 -it --name $1$i $2"
        open_terminal "$c_create_container"
    done
}


#function : create_single_container
    #create new container
    #parameters : $container_name, $image, $network, $ip
function create_single_container(){
    c_create_container="echo $1 IP:${4}:$3; docker run --net $3 --ip $4 -it --name $1 $2"
    open_terminal "$c_create_container"
}


#function : create_network
    #Create a network
    #parameters : $name $addr with mask
function create_network(){
    echo "CREATE NETWORK"
    docker network create --subnet=$2 $1
}

#function : delete_containers
    #delete a number of containers
    #parameters : $name, $number
function delete_containers(){
    echo "DELETE CONTAINERS"
    for ((i=1; i <= $2; i++))
    do
        docker stop $1$i
        docker rm $1$i
    done
}

#function : delete_network
    #delete a network
    #parameters : $namen $number
function delete_network(){
    echo "DELETE SUBNET"
    for((i=1; i <= $2; i++))
    do
        docker network rm $1$i
    done
}


#function : print container or network
    #print the list of all container or all etworks
    #parameters : $instruction
function print(){
    if [[ $1 == "container" ]]
    then
        docker ps -a #show list of all containers
    elif [[ $1 == "network" ]]
    then
        docker network ls #show list of network
    elif [[ $1 == "all" ]]
    then
        docker ps -a #show list of all containers
        echo ""
        docker network ls #show list of network
    fi
}

#entry point of the script
#conditions for the script parameters

#CREATE CONTAINER MODE#
if [[ $1 == "create" ]]
then
    echo "Containers create mode"

    if [[ $# == 6 ]]
    then
        create_containers $2 $3 $4 $5 $6
    else
        echo "Wrong script call for create mode : ./containers.sh create container_name image network ip number_of_containers"
    fi
#CREATE SUBNET MODE#
elif [[ $1 == "create_network" ]]
then
    echo "Network create mode"
    if [[ $# == 3 ]]
    then
        create_network $2 $3
    else
        echo "Wrong script call for create_network mode : ./containers.sh create_network name addr"
    fi
#DELETE MODE#
elif [[ $1 == "delete" ]]
then
    echo "Delete mode"
    if [[ $# == 4 ]]
    then
        if [[ $2 == "container" ]]
        then
            delete_containers $3 $4
        elif [[ $2 == "network" ]]
        then
            delete_network $3 $4
        else
            echo "Wrong script call for delete mode : ./containers.sh delete mode name number"
        fi
    else
        echo "Wrong script call for delete mode : ./containers.sh delete mode name number"
    fi
#PRINT MODE#
elif [[ $1 == "print" ]]
then
    echo "Containers print mode"
    if [[ $# == 2 ]]
    then
        print $2
    else
        echo "Wrong script call for print mode : ./containers.sh print instruction"
    fi
#PARSE FILE MODE#
elif [[ $1 == "parse" ]]
then
    echo "Parse file mode"
    if [[ $# == 3 ]]
    then
        parse_file $2 $3
    else
        echo "Wrong script call for parse file mode : ./containers.sh parse file_path separator"
    fi
else
    echo "Invalid script command"
fi
exit
