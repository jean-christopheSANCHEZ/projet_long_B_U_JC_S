#function : parse_file
    #parse a file (file in the path parameter) and call function
    #parameters : $path, $separator
function parse_file($path, $separator){
    Write-Output "Parsing file $path with $separator as a separator"
    $array = [System.Collections.ArrayList]@()
    $initialised_network = ""
    $current_network_name =""
    foreach($line in (Get-Content $path)){
        $nline = $line.Split($separator)
        $array.Add($nline)

        if($check_rt=$nline[1].Split(":")[0] -eq "rt"){
            Write-Host "Need a router between"$nline[1].Split(":")[1]"and"$nline[1].Split(":")[3]"the node (container)"$nline[1].Split(":")[2]"is used as a router"
            $tmp_rt_network = $nline[1].Split(":")[3]
            $tmp_rt_container = $nline[1].Split(":")[2]
            sleep -s 5
            docker network connect $tmp_rt_network $tmp_rt_container
        }else{
            #check if we need to create a new network or not
            $tmp_n_name = $nline[1].Split(":")[0]
            if($current_network_name -ne $tmp_n_name){
                if($initialised_network.Contains($tmp_n_name)){
                   Write-Host "network already exist"
                }else{
                   Write-Host "new network $tmp_n_name"
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
    #parameters : $command
function open_terminal($container_name, $command){
    $encoded2 = [Convert]::ToBase64String( [Text.Encoding]::Unicode.GetBytes($command))
    Start-Process powershell -Verb Runas -ArgumentList '-noExit','-encodedCommand',$encoded2
}

#function : create_containers
    #create new containers
    #parameters : $container_name, $image, $network, $ip, $number
function create_containers($container_name, $image, $network, $ip, $number){
    for($i =1; $i -le $number; $i++){
        $c_create_container = "echo $container_name$i IP:${ip}:$network; docker run --net $network --ip $ip -it --name $container_name$i $image"
        open_terminal $container_name$i $c_create_container
    }
}

#function : create_single_container
    #create new container
    #parameters : $container_name, $image, $network, $ip
function create_single_container($container_name, $image, $network, $ip){
    $c_create_container = "echo $container_name$i IP:${ip}:$network; docker run --net $network --ip $ip -it --name $container_name $image"
    open_terminal $container_name $c_create_container
}

#function : create_network
    #create new subnet
    #parameters : $name, $addr (with mask)
function create_network($name, $addr){
    $c_create_network = "docker network create --subnet=$addr $name"
    Invoke-Expression $c_create_network
}


#function : delete_containers
    #delete a number of containers
    #parameters : $name, $number
function delete_containers($name, $number){
    Write-Host "DELETE CONTAINERS"
    for($i=1; $i -le $number; $i++){
        $c_stop_all_container = "docker stop $name$i" 
        Invoke-Expression $c_stop_all_container
        $c_rm_all_container = "docker rm $name$i"
        Invoke-Expression $c_rm_all_container
    }
}


#function : delete_network
    #delete a network
    #parameters : $namen $number
function delete_network($name, $number){
    Write-Host "DELETE SUBNET"
    for($i=1; $i -le $number; $i++){
        $c_rm_all_subnet = "docker network rm $name$i"
        Invoke-Expression $c_rm_all_subnet
    }
}

#function : print container or network
    #print the list of all container or all etworks
    #parameters : $instruction
function print($instruction){
    If($instruction -eq "container"){
        $c_show_list = "docker ps -a" #show list of all containers
        $running_containers = & Invoke-Expression $c_show_list | Out-String
        Write-Host $running_containers
    }Elseif($instruction -eq "network"){
        $c_show_list = "docker network ls" #show list of network
        $running_network = & Invoke-Expression $c_show_list | Out-String
        Write-Host $running_network
    }Elseif($instruction -eq "all"){
        $c_show_list = "docker ps -a" #show list of all containers
        $running_containers = & Invoke-Expression $c_show_list | Out-String
        Write-Host $running_containers
        $c_show_list = "docker network ls" #show list of network
        $running_network = & Invoke-Expression $c_show_list | Out-String
        Write-Host $running_network
    }
}

#entry point of the script
#conditions for the script parameters

#CREATE CONTAINER MODE#
If($args[0] -eq "create"){
    Write-Host "Containers create mode"

    If($args.Count -eq 6){
        create_containers $args[1] $args[2] $args[3] $args[4] $args[5]
    }else{
        Write-Host "Wrong script call for create mode : .\containers.ps1 create container_name image network ip number_of_containers"
    }
}
#CREATE SUBNET MODE#
If($args[0] -eq "create_network"){
    Write-Host "Network create mode"
    If($args.Count -eq 3){
        create_network $args[1] $args[2]
    }else{
        Write-Host "Wrong script call for create_network mode : .\containers.ps1 create_network name addr"
    }
}
#DELETE MODE#
ElseIf($args[0] -eq "delete"){
    Write-Host "Delete mode"

    If($args.Count -eq 4){
        If($args[1] -eq "container"){
            delete_containers $args[2] $args[3]
        }Elseif($args[1] -eq "network"){
            delete_network $args[2] $args[3]
        }else{
            Write-Host "Wrong script call for delete mode : .\containers.ps1 delete mode name number"
        }
    }else{
        Write-Host "Wrong script call for delete mode : .\containers.ps1 delete mode name number"
    }
}
#PRINT MODE#
ElseIf($args[0] -eq "print"){
    Write-Host "Containers print mode"
    If($args.Count -eq 2){
        print $args[1]
    }else{
        Write-Host "Wrong script call for print mode : .\containers.ps1 print instruction"
    }
}
#PARSE FILE MODE#
ElseIf($args[0] -eq "parse"){
    Write-Host "Parse file mode"
    If($args.Count -eq 3){
        parse_file $args[1] $args[2]
    }else{
        Write-Host "Wrong script call for parse file mode : .\containers.ps1 parse file_path separator"
    }
}else{
    Write-Host "Invalid script command"
}
exit