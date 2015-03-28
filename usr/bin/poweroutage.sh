#!/bin/bash

# Rasberry Pi Home Monitor Program - monitor your home with a rasberry pi
# Copyright (C) 2015 Jason K Holden

# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.


#To run this automatically, perform the following
# vi crontab -e
# 0 * * * * ~/poweroutage.sh

# Source the configuration file for the email address to use
# for notifications

if [ ! -f ./config.cfg ]; then
    echo "Failed to find config file: ./config.cfg"
    exit 1
fi

. ./config.cfg

# Do we have an email address
if [ -z ${email_addr} ]; then
    echo "No email address found!, aborting"
    exit 1
fi

ping -c 1 ifconfig.me
ip=`curl ifconfig.me`
cur_date=`date`


#temp_c=$(/opt/vc/bin/vcgencmd measure_temp)
temp_c=$(cat /sys/class/thermal/thermal_zone0/temp)
#temp_c=$(( temp_c / 1000.0))

temp_f=$(echo "puts [expr ${temp_c}/1000*1.8+32]" | tclsh)

#temp_f=$(( temp_c * 1.8 + 32))
echo "Power is on, public ip is ${ip}, temp=${temp_c}mC, ${temp_f}F" | mail -s "Power Status ${cur_date}" ${email_addr}
