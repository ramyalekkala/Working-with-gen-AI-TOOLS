#!/bin/bash

# vm_health_check.sh

# Function to display VM health check
check_vm_health() {
    local cpu_usage=
    local memory_usage=
    local disk_usage=
    local health_status=""

    # Simulating the health check logic
    cpu_usage=$(echo "$(vmstat 1 2 | tail -n 1 | awk '{print $13}')")
    memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    disk_usage=$(df | grep /dev/sda1 | awk '{print $5}' | sed 's/%//')

    if [ $cpu_usage -lt 75 ] && [ $(echo "$memory_usage < 75" | bc) -eq 1 ] && [ $disk_usage -lt 75 ]; then
        health_status="Healthy"
    else
        health_status="Unhealthy"
    fi

    # Display formatted utilization report
    echo "VM Health Check Report:"
    echo "-----------------------------------"
    echo "CPU Utilization: ${cpu_usage}%"
    echo "Memory Utilization: ${memory_usage}%"
    echo "Disk Utilization: ${disk_usage}%"
    echo "Health Status: $health_status"
    echo "-----------------------------------"
}

# Main script execution
if [[ "$1" == "explain" ]]; then
    check_vm_health
else
    echo "Usage: ./vm_health_check.sh explain"
fi
