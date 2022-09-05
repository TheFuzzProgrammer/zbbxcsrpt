#!/bin/bash

$(clear)

$(export https_proxy=http://10.130.1.196:9090/)

$(export http_proxy=http://10.130.1.196:9090/)

if [[rpm -qa | grep zabbix]]
    then
        $(yum remove zabbix-agent -y)
    else 
        if [[which zabbix_agentd]]
            then
                agentd=$(which zabbix_agentd)
                $(mv -f $agentd zabbix_agentd.bkp)
        fi
fi

if [[ls /run | grep zabbix]]
    then
        $(mv .* .bkp)
else
    $(mkdir /run/zabbix)
    $(chmod 700 /run/zabbix)
fi

if [[ !$(rpm -Uvh $1/linux-packages/rh6.rpm) ]]
    then
    $(yum clean all)
    $(yum install zabbix-agent)
    $(service zabbix-agent restart)
    $(chkconfig --level 35 zabbix-agent on)
    echo "Running zabbix conf setup"
    $(./setZabbixPARAMS.sh)
    $(rm rh6.rpm && clear)                     
else
    echo "unable to write the file, or host error"
fi
