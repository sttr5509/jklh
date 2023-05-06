
LOG_FILE=/home/connection.log

## CPU负载计算

function GetSysCPU 
{
CpuIdle=`vmstat 1 5 |sed -n '3,$p' | awk '{x = x + $15} END {print x/5}' | awk -F. '{print $1}'` 
CpuNum=`echo "100-$CpuIdle" | bc` 
echo $CpuNum 
}

ACCEPTIP=149.154.167.220

cpucheck=`GetSysCPU`
vps="香港【121】"

#设置警告阈值

#第一层
cpumaxl=20

#第二层
cpumaxll=50

#第三层
cpumaxlll=70

# >=20循环成立 执行if
while [ ${cpucheck} -gt $cpumaxl ]
do

    cpucheck=`GetSysCPU`
    #第三层防御判断>=70
    if [ ${cpucheck} -gt $cpumaxlll ];
    then
    #获取当前
    date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
    #请求发送TG消息
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a🚫🚫🚫开启第三层最终封锁防御!!!"
    #开启第三层防御封禁IP命令
    
    echo "目前CPU负载为$cpucheck%开启第三层防御最终封锁防御!!!"
    
    # 获取当前连接数超过1次的被封禁的IP和连接次数
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    
    # 遍历每个被封禁的IP，进行解封和记录
    for IP in $BANNED_IP; do
      # 将IP和连接次数写入日记文件
      echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(iptables -L INPUT -v -n | grep $IP | awk '{print $2}')" >> $LOG_FILE
      
      # 解封IP
      iptables -D INPUT -s $IP -j DROP
    done
    
    # 获取当前连接数超过1次的IP和连接次数
    TOP_IP=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | awk '{if($1>1) print $2}')
    
    # 遍历每个连接次数超过1次的IP，进行封禁和记录
    for IP in $TOP_IP; do
      # 将IP和连接次数写入日记文件
      echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(netstat -ntu | grep $IP | wc -l)" >> $LOG_FILE
      
      # 封禁IP
      iptables -A INPUT -s $IP -j DROP
      curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🚫🚫🚫第三层封禁的IP:$IP"
    done
    
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🚫🚫🚫第三层30秒后解除封禁"
    sleep 30
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    
    for IP in $BANNED_IP; do
        iptables -D INPUT -s $BANNED_IP -j DROP
    done
    
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🚫🚫🚫第三层防御结束"
    
    

    #第二层防御判断>=30
    elif [ ${cpucheck} -gt $cpumaxll ];
    then
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a⚠️⚠️⚠️开启第二层防御!!!"
    echo "目前CPU负载为$cpucheck%开启第二层防御!!!"
        
    # 获取当前连接数超过1次的被封禁的IP和连接次数
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    
    # 遍历每个被封禁的IP，进行解封和记录
    for IP in $BANNED_IP; do
      # 将IP和连接次数写入日记文件
      echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(iptables -L INPUT -v -n | grep $IP | awk '{print $2}')" >> $LOG_FILE
      
      # 解封IP
      iptables -D INPUT -s $IP -j DROP
    done
    
    # 获取当前连接数超过10次的IP和连接次数
    TOP_IP=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | awk '{if($1>10) print $2}')
    
    # 遍历每个连接次数超过1次的IP，进行封禁和记录
    for IP in $TOP_IP; do
      # 将IP和连接次数写入日记文件
      echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(netstat -ntu | grep $IP | wc -l)" >> $LOG_FILE
      
      # 封禁IP
      iptables -A INPUT -s $IP -j DROP
      curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}⚠️⚠️⚠️第二层被封禁的IP:$IP"
      
    done
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}⚠️⚠️⚠️第二层30秒后解除封禁"
    sleep 30
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    for IP in $BANNED_IP; do
        iptables -D INPUT -s $BANNED_IP -j DROP
    done
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}⚠️⚠️⚠️第二层防御结束"
    
    #第一层防御判断>=20
    elif [ ${cpucheck} -gt $cpumaxl ];
    then
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a🔒🔒🔒开启第一层防御!!!"
    echo "目前CPU负载为$cpucheck%开启第一层防御!!!"
    
    # 获取当前连接数超过1次的被封禁的IP和连接次数
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    
    # 遍历每个被封禁的IP，进行解封和记录
    for IP in $BANNED_IP; do
      # 将IP和连接次数写入日记文件
      echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(iptables -L INPUT -v -n | grep $IP | awk '{print $2}')" >> $LOG_FILE
      
      # 解封IP
      iptables -D INPUT -s $IP -j DROP
    done
    
    # 获取当前连接数超过20次的IP和连接次数
    TOP_IP=$(netstat -ntu | awk '{print $5}' | cut -d: -f1 | sort | uniq -c | awk '{if($1>20) print $2}')
    
    # 遍历每个连接次数超过1次的IP，进行封禁和记录
    for IP in $TOP_IP; do
      # 将IP和连接次数写入日记文件
        echo "$(date '+%Y-%m-%d %H:%M:%S') - IP: $IP, Connections: $(netstat -ntu | grep $IP | wc -l)" >> $LOG_FILE
      
      # 封禁IP
        iptables -A INPUT -s $IP -j DROP
        curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🔒🔒🔒第一层封禁的IP:$IP"
    done
    
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🔒🔒🔒第一层30秒后解除封禁"
    sleep 30
    BANNED_IP=$(iptables -L INPUT -v -n | awk '{print $8}' | grep -E '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | awk '{if($1>0) print $2}')
    
    for IP in $BANNED_IP; do
        iptables -D INPUT -s $BANNED_IP -j DROP
    done
    
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}🔒🔒🔒第一层防御结束"
    
    
    else
    
     sleep 5
    cpucheck=`GetSysCPU`
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a负载小于$cpumaxl%防御已关闭"
    #退出循环，防御关闭
    echo "cpu负载为$cpucheck%小于$cpumaxl%防御关闭"
    #清空所有规则
    iptables -F
    iptables -A INPUT -p all -s $ACCEPTIP -j ACCEPT
    break
fi
done

##监测坚果输出到本地以便后期查阅..
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
echo "${date}" "CPU负载正常，当前负载为$cpucheck%...">> $LOG_FILE