#!/bin/bash

# Script to check the health of a VM based on CPU, memory, and disk space utilization

# Function to check health status
check_health() {
    local cpu_util=$(awk -F" " '/^cpu / {printf "%d", ($2+$4)*100/($2+$4+$5)}' /proc/stat)
    local mem_util=$(free | grep Mem | awk '{printf "%d", $3/$2 * 100.0}')
    local disk_util=$(df / | grep / | awk '{printf "%d", $3/$2 * 100.0}')

    local health="healthy"

    # Determine health status
    if [ $cpu_util -gt 60 ] || [ $mem_util -gt 60 ] || [ $disk_util -gt 60 ]; then
        health="unhealthy"
    fi

    echo $health
}

# Function to explain health status
explain_health() {
    local cpu_util=$(awk -F" " '/^cpu / {printf "%d", ($2+$4)*100/($2+$4+$5)}' /proc/stat)
    local mem_util=$(free | grep Mem | awk '{printf "%d", $3/$2 * 100.0}')
    local disk_util=$(df / | grep / | awk '{printf "%d", $3/$2 * 100.0}')

    local explanation=

    if [ $cpu_util -gt 60 ]; then
        explanation="CPU utilization is at $cpu_util% which is above the healthy threshold."
    fi
    if [ $mem_util -gt 60 ]; then
        explanation+=" Memory utilization is at $mem_util% which is above the healthy threshold."
    fi
    if [ $disk_util -gt 60 ]; then
        explanation+=" Disk utilization is at $disk_util% which is above the healthy threshold."
    fi

    if [ -z "$explanation" ]; then
        echo "All parameters are within healthy limits."
    else
        echo $explanation
    fi
}

# Main script logic
health_status=$(check_health)

if [ "$1" == "explain" ]; then
    echo "Health status: $health_status"
    explain_health
else
    echo "Health status: $health_status"
fi
