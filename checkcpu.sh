## CPU负载计算

function GetSysCPU 
{
CpuIdle=`vmstat 1 5 |sed -n '3,$p' | awk '{x = x + $15} END {print x/5}' | awk -F. '{print $1}'` 
CpuNum=`echo "100-$CpuIdle" | bc` 
echo $CpuNum 
}


cpucheck=`GetSysCPU`
vps=""

#设置警告阈值

#第一层
cpumaxl=25

#第二层
cpumaxll=50

#第三层
cpumaxlll=70

# >=20循环成立 执行if
while [ ${cpucheck} -gt $cpumaxl ]
do

    cpucheck=`GetSysCPU`
#第三层防御判断>=50
    if [ ${cpucheck} -gt $cpumaxlll ];
    then
    #获取当前
    date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
    #请求发送TG消息
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a🚫🚫🚫开启第三层最终封锁防御!!!"
    #开启第三层防御封禁IP命令
    
    echo "目前CPU负载为$cpucheck%开启第三层防御最终封锁防御!!!"
    ddos -d
    sleep 2
    ddos -k 1
    sleep 60
    ddos -s
    iptables -F
    sleep 2

    #第二层防御判断>=30
    elif [ ${cpucheck} -gt $cpumaxll ];
    then
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a⚠️⚠️⚠️开启第二层防御!!!"
    echo "目前CPU负载为$cpucheck%开启第二层防御!!!"
    ddos -d
    sleep 2
    ddos -k 5
    sleep 30
    ddos -s
    iptables -F
    sleep 2
    
    #第一层防御判断>=20
    elif [ ${cpucheck} -gt $cpumaxl ];
    then
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a🔒🔒🔒开启第一层防御!!!"
    echo "目前CPU负载为$cpucheck%开启第一层防御!!!"
    ddos -d
    sleep 2
    ddos -k 10
    sleep 15
    ddos -s
    iptables -F
    sleep 2
    
    else
    sleep 2
    cpucheck=`GetSysCPU`
    curl -X POST "https://api.telegram.org/bot6045626569:AAFZZpWPd5kgCuem9Cm08-YZpaYzyK4GfWA/sendMessage?chat_id=6241487193&text=👉👉👉${vps}CPU负载为$cpucheck%%0a负载小于$cpumaxl%防御已关闭"
    #退出循环，防御关闭
    echo "cpu负载为$cpucheck%小于$cpumaxl%防御关闭"
    ddos -s
    sleep 5
    break
fi
done

##监测坚果输出到本地以便后期查阅..
date=$(env LANG=en_US.UTF-8 date "+%e/%b/%Y/%R")
echo "${date}" "CPU负载正常，当前负载为$cpucheck%..."
