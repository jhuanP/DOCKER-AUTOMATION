#!/bin/bash

echo "What is the Name of your docker img"

read imgName

echo "Are wanting to build docker image named $imgName?"

read confirmation
     
if [ $confirmation = yes ]
then
     docker build -t $imgName .
elif [ $confirmation = no ]
then
    echo "No image was built"
    exit
fi
 
echo "Do you want to create a swarm?"

read swarm

if [ $swarm = yes ]
then 
echo "What port do you want to run on? e.g 8080:80 is local host 8080 and Docker port 80"

read port

    docker swarm init
    docker run -d -it -p $port $imgName
elif [ $swarm = no ]
then 
echo "What port do you want to run on? e.g 8080:80 is local host 8080 and Docker port 80"

read port
    docker run -d -it -p $port $imgName
    echo "No swarm or service was created" 
    exit
fi

echo "Do you want to create a service?"

read service

    if [ $service = yes ]   
    then
    echo "You have selected to start a service"
    elif [ $service = no ]
    then
    echo "You have selected not to start a service, but your swarm is created"
    exit
    fi
    
    echo "Do you want any replicas?"
    read replicas
    if [ $replicas = yes ]
    then
    echo "How many replicas would you like?"
    read numReps
    docker service create --name $imgName --replicas "$numReps" $imgName
    echo "Service $imgName was created with $numReps replicas"

    elif [ $replicas = no ]
    then 
        docker service create --name $imgName $imgName
        echo "Service $imgName was started but no replicas were created"
    fi
       