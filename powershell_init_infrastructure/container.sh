#!/bin/bash


#function : parse_file
    #parse a file (file in the path parameter) and call function
    #parameters : $path, $separator
function parse_file(){
    echo "Parsing file $1 with $2 as a separator"
    $array = [System.Collections.ArrayList]@()
    $initialised_network = ""
    $current_network_name =""
    foreach($line in (Get-Content $1)){
        $nline = $line.Split($2)
        $array.Add($nline)

        if($check_rt=$nline[1].Split(":")[0] -eq "rt"){
            echo "Need a router between"$nline[1].Split(":")[1]"and"$nline[1].Split(":")[3]"the node (container)"$nline[1].Split(":")[2]"is used as a router"
            $tmp_rt_network = $nline[1].Split(":")[3]
            $tmp_rt_container = $nline[1].Split(":")[2]
            echo "docker network connect"$tmp_rt_network $tmp_rt_container
            #Invoke-Expression "docker network connect"$tmp_rt_network $tmp_rt_container
            echo "Router not done bug on the current version"
        }else{
            #check if we need to create a new network or not
            $tmp_n_name = $nline[1].Split(":")[0]
            if($current_network_name -ne $tmp_n_name){
                if($initialised_network.Contains($tmp_n_name)){
                   echo "network already exist"
                }else{
                   echo "new network $tmp_n_name"
                   $initialised_network = $initialised_network + $tmp_n_name
                   $current_network_name = $tmp_n_name
                   $tmp_n_addr = $nline[1].Split(":")[1].Split(".")[0] + "." + $nline[1].Split(":")[1].Split(".")[1] + "." + $nline[1].Split(":")[1].Split(".")[2] + "." + "0/24"
                   create_network $current_network_name $tmp_n_addr
                }
            }

            #create the container node
            create_single_container $nline[0] $nline[2] $nline[1].Split(":")[0] $nline[1].Split(":")[1]
        }
    }
}


#function : open_terminal
    #open a terminal in the current container
    #parameters : $container_name, $image, $number
function open_terminal(){
    xterm -hold -e $1 &
}

#function : create_containers
    #create new containers
    #parameters : $container_name, $image, $network, $ip, $number
function create_containers(){
    for ((i =1; i -le $5; i++))
    do
        $c_create_container = "echo $1$i IP:${4}:$3; docker run --net $3 --ip $4 -it --name $1$i $2"
        open_terminal $1$i $c_create_container
    done
}


#function : create_single_container
    #create new container
    #parameters : $container_name, $image, $network, $ip
function create_single_container(){
    $c_create_container = "echo $1$i IP:${4}:$3; docker run --net $3 --ip $4 -it --name $1 $2"
    open_terminal $1 $c_create_container
}


#function : delete_containers
    #delete a number of containers
    #parameters : $name, $number
function delete_containers(){
    echo "DELETE CONTAINERS"
    for ((i=1; i -le $2; i++))
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
    for((i=1; i -le $2; i++))
    do
        docker network rm $1$i
    done
}


#function : print container or network
    #print the list of all container or all etworks
    #parameters : $instruction
function print(){
    if [[ $1 -eq "container" ]]
    then
        docker ps -a #show list of all containers
    elif [[ $1 -eq "network" ]]
    then
        docker network ls #show list of network
    fi
}

#entry point of the script
#conditions for the script parameters

#CREATE CONTAINER MODE#
if [[ $1 -eq "create" ]]
then
    echo "Containers create mode"

    if [[ $# -eq 6 ]]
    then
        create_containers $2 $3 $4 $5 $6
    else
        echo "Wrong script call for create mode : .\containers.ps1 create container_name image network ip number_of_containers"
    fi
#CREATE SUBNET MODE#
elif [[ $1 -eq "create_network" ]]
then
    echo "Network create mode"
    if [[ $# -eq 3 ]]
    then
        create_network $2 $3
    else
        echo "Wrong script call for create_network mode : .\containers.ps1 create_network name addr"
    fi
#DELETE MODE#
elif [[ $1 -eq "delete" ]]
then
    echo "Delete mode"
    if [[ $# -eq 4 ]]
    then
        if [[ $2 -eq "container" ]]
        then
            delete_containers $3 $4
        elif [[ $2 -eq "network" ]]
        then
            delete_network $3 $4
        else
            echo "Wrong script call for delete mode : .\containers.ps1 delete mode name number"
        fi
    else
        echo "Wrong script call for delete mode : .\containers.ps1 delete mode name number"
    then
#PRINT MODE#
elif [[ $1 -eq "print" ]]
then
    echo "Containers print mode"
    if [[ $# -eq 2 ]]
    then
        print $2
    else
        echo "Wrong script call for print mode : .\containers.ps1 print instruction"
    fi
#PARSE FILE MODE#
elif [[ $1 -eq "parse" ]]
then
    echo "Parse file mode"
    if [[ $# -eq 3 ]]
    then
        parse_file $2 $3
    else
        echo "Wrong script call for parse file mode : .\containers.ps1 parse file_path separator"
    fi
else
    echo "Invalid script command"
fi
exit