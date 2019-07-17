#!/bin/sh /etc/rc.common
START=95
SERVICE_USE_PID=1
SERVICE_WRITE_PID=1
SERVICE_DAEMONIZE=1

. /etc/misstar/scripts/MTbase

EXTRA_COMMANDS=" status  version dnsstatus dnsconfig"
EXTRA_HELP="        status  Get shadowsocks status
		dnsstatus  Get dns status
        version Get Misstar Tools Version"

wan_mode=`ifconfig | grep pppoe-wan | wc -l`
if [ "$wan_mode" = '1' ];then
	wanip=$(ifconfig pppoe-wan | grep "inet addr:" | cut -d: -f2 | awk '{print$1}')
else
	wanip=$(ifconfig eth0.2 | grep "inet addr:" | cut -d: -f2 | awk '{print$1}')
fi

#lanip=$(ifconfig br-lan | grep "inet addr:" | cut -d: -f2 | awk '{print$1}')
lanip=$(uci get network.lan.ipaddr)
redip=$lanip
CONFIG=/etc/misstar/applications/ss/config/shadowsocks.json
DNSCONF=/etc/misstar/applications/ss/config/dns2socks.conf

chnroute=/etc/misstar/applications/ss/config/chnroute.conf
chnroute_user=/etc/misstar/applications/ss/config/chnroute_customize.conf
iplist=/etc/misstar/applications/ss/config/iplist
APPPATH=/etc/misstar/applications/ss/bin/ss-redir
LOCALPATH=/etc/misstar/applications/ss/bin/ss-local
DNSPATH=/etc/misstar/applications/ss/bin/dns2socks
appname=misstar
ss_getconfig() {
	local_ip=0.0.0.0
	id=$(uci get $appname.ss.id)

	ss_server_ip=$(uci get $appname.$id.ss_server)

	#ss_server_ip=`nslookup $ss_server_ip | grep 'Address 1' | grep -v '127.0.0.1' | awk '{print $3}'`
	ss_server_port=$(uci get $appname.$id.ss_server_port)
	ss_server_password=$(uci get $appname.$id.ss_password)
	ss_server_method=$(uci get $appname.$id.ss_method)
	ssr_enable=$(uci get $appname.$id.ssr_enable)
	ssr_protocol=$(uci get $appname.$id.ssr_protocol)
	ssr_obfs=$(uci get $appname.$id.ssr_obfs)
	ssr_protocolparam=$(uci get $appname.$id.ssr_protocolparam)
	ssr_obfsparam=$(uci get $appname.$id.ssr_obfsparam)
	rm -rf $CONFIG
	
	if [ "$ssr_enable" = '0' ];then
		echo -e '{\n  "server":"'$ss_server_ip'",\n  "server_port":'$ss_server_port',\n  "local_port":'1081',\n  "local_address":"'$local_ip'",\n  "password":"'$ss_server_password'",\n  "timeout":600,\n  "method":"'$ss_server_method'"\n}' > $CONFIG
		echo -e '{\n  "server":"'$ss_server_ip'",\n  "server_port":'$ss_server_port',\n  "local_port":'1082',\n  "local_address":"'$local_ip'",\n  "password":"'$ss_server_password'",\n  "timeout":600,\n  "method":"'$ss_server_method'"\n}' > $DNSCONF
	fi	
	if [ "$ssr_enable" = '1' ];then
		APPPATH=/etc/misstar/applications/ss/bin/ssr-redir
		LOCALPATH=/etc/misstar/applications/ss/bin/ssr-local
		echo -e '{\n  "server":"'$ss_server_ip'",\n  "server_port":'$ss_server_port',\n  "local_port":'1081',\n  "local_address":"'$local_ip'",\n  "password":"'$ss_server_password'",\n  "timeout":600,\n  "method":"'$ss_server_method'",\n  "protocol":"'$ssr_protocol'",\n  "obfs":"'$ssr_obfs'",\n  "protocol_param":"'$ssr_protocolparam'",\n  "obfs_param":"'$ssr_obfsparam'"\n}' > $CONFIG
		echo -e '{\n  "server":"'$ss_server_ip'",\n  "server_port":'$ss_server_port',\n  "local_port":'1082',\n  "local_address":"'$local_ip'",\n  "password":"'$ss_server_password'",\n  "timeout":600,\n  "method":"'$ss_server_method'",\n  "protocol":"'$ssr_protocol'",\n  "obfs":"'$ssr_obfs'",\n  "protocol_param":"'$ssr_protocolparam'",\n  "obfs_param":"'$ssr_obfsparam'"\n}' > $DNSCONF
	fi

}

dnsconfig(){
	killall $DNSPATH
	killall pdnsd
	iptables -t nat -D PREROUTING -s $lanip/24 -p udp --dport 53 -j DNAT --to $redip -m comment --comment "misstar-dnsred" &> /dev/null
	MTlog 1 "Start DNS Process..."
	dns_mode=$(uci get misstar.ss.dns_mode)
	if [ "$dns_mode" = 'pdnsd' ];then
		/etc/misstar/applications/ss/script/pdnsd start
		if [ $? -eq 0 ];then
    		MTlog 1 "Done! DNS started with "$dns_mode" Mode."
		else 
   			MTlog 3 "DNS Process start failed,Exiting..."
    		exit
    	fi
	elif [ "$dns_mode" = 'dns2socks' ];then
		DNS_SERVER=$(uci get $appname.ss.dns_server)
		DNS_SERVER_PORT=$(uci get $appname.ss.dns_port)
		service_start $DNSPATH 127.0.0.1:1082 $DNS_SERVER:$DNS_SERVER_PORT 127.0.0.1:15353
		if [ $? -eq 0 ];then
    		MTlog 1 "Done! DNS started with "$dns_mode" Mode."
		else 
   			MTlog 3 "DNS Process start failed,Exiting..."
    		exit
		fi
	else
		MTlog 3 "Get DNS mode Error，Exiting..."
		exit	
	fi
	
	Dnsred=$(uci get $appname.ss.dns_red_enable)
	if [ "$Dnsred" == '1' ];then
		Dnsredid=$(uci get $appname.ss.dns_red_ip)
		if [ "$Dnsredid" != 'lanip' ];then
			redip=$Dnsredid
		fi
		iptables -t nat -I PREROUTING -s $lanip/24 -p udp --dport 53 -j DNAT --to $redip -m comment --comment "misstar-dnsred" &> /dev/null
	fi
}


get_jump_mode(){
	case "$1" in
		0)
			echo "-j"
		;;
		*)
			echo "-g"
		;;
	esac
}

get_action_chain() {
	case "$1" in
		0)
			echo "RETURN"
		;;
		1)
			echo "SHADOWSOCK"
		;;
	esac
}

start()
{
	vsftpd_enable=$(uci get misstar.ss.enable)
	if [ "$vsftpd_enable" = '0' ];then
		echo "service ss is disabeld!"
		exit
	fi
	
	AreadyRunning=$(ps | grep ss-redir | grep -v grep | wc -l)
	if [ "$AreadyRunning" != '0' ];then
		echo "SS is aleady running,Exit..."
		exit
	fi
	ss_getconfig
	insmod ipt_REDIRECT 2>/dev/null
	chmod +x /etc/misstar/applications/ss/bin/ss-redir	
	chmod +x /etc/misstar/applications/ss/bin/ss-local
	
    service_start $LOCALPATH -c $DNSCONF

	dnsconfig
    
    #创建CHAIN
    MTlog 1 "Add iptables rules... "
	iptables -t nat -N SHADOWSOCKS
	iptables -t nat -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
	iptables -t nat -A SHADOWSOCKS -d $lanip/24 -j RETURN
	iptables -t nat -A SHADOWSOCKS -d $wanip/16 -j RETURN
	iptables -t nat -A SHADOWSOCKS -d $ss_server_ip -j RETURN
	
	iptables -t nat -N SHADOWSOCK
	    
	# lan access control
	cat /etc/misstar/applications/ss/config/LanCon.conf | awk -F ',' '{print $1}' | while read line
	do
		mac=$line
		proxy_mode=$(cat /etc/misstar/applications/ss/config/LanCon.conf | grep $line | awk -F ',' '{print $4}')
		iptables -t nat -A SHADOWSOCKS  -m mac --mac-source $mac $(get_jump_mode $proxy_mode) $(get_action_chain $proxy_mode)
	done
	
	
	# default acl mode
	ss_acl_default_mode=$(uci get misstar.ss.ss_acl_default_mode)
	[ -z "$ss_acl_default_mode" ] && ( ss_acl_default_mode=1;mt_set misstar.ss.ss_acl_default_mode=1)
	iptables -t nat -A SHADOWSOCKS -p tcp -j $(get_action_chain $ss_acl_default_mode)
	
	id=$(uci get $appname.ss.id)
	ss_mode=$(uci get $appname.$id.ss_mode)
	case $ss_mode in
		"gfwlist")
			/etc/misstar/applications/ss/script/pacupdate &> /dev/null && mv /tmp/list.txt /etc/misstar/applications/ss/config/pac.conf 
			service_start $APPPATH -b 0.0.0.0 -c $CONFIG
			if [ $? -eq 0 ];then
    			MTlog 1 "Start Shadowsocks as GFWlist Mode. Done"
			else 
   				MTlog 3 "Shadowsocks Process start failed,Exiting..."
   			 	exit
			fi
			start_ss_rules_gfwlist
			;;
		"whitelist")
			service_start $APPPATH -b 0.0.0.0 -c $CONFIG
			if [ $? -eq 0 ];then
    			MTlog 1 "Start Shadowsocks as whitelist Mode. Done"
			else 
   				MTlog 3 "Shadowsocks Process start failed,Exiting..."
   			 	exit
			fi
			start_ss_rules_whitelist
			;;
		"gamemode")
			service_start $APPPATH -b 0.0.0.0 -u -c $CONFIG
			if [ $? -eq 0 ];then
    			MTlog 1 "Start Shadowsocks as Game Mode. Done"
			else 
   				MTlog 3 "Shadowsocks Process start failed,Exiting..."
   			 	exit
			fi
			start_ss_rules_whitelist
			start_ss_udp
			;;
		"wholemode")
			service_start $APPPATH -b 0.0.0.0 -c $CONFIG
			if [ $? -eq 0 ];then
    			MTlog 1 "Start Shadowsocks as Whole Mode. Done"
			else 
   				MTlog 3 "Shadowsocks Process start failed,Exiting..."
   			 	exit
			fi
			start_ss_rules
			;;
	esac
	
	#apply iptables
	#全局模式
	ss_mode=$(uci get $appname.$id.ss_mode)
	iptablenu=$(iptables -t nat -L PREROUTING | awk '/KOOLPROXY/{print NR}')
	if [ '$iptablenu' != '' ];then
		iptablenu=`expr $iptablenu - 2`
	else
		iptablenu=2
	fi
	[ "$ss_mode" == "wholemode" ] ||[ "$ss_mode" == "whitelist" ] || [ "$ss_mode" == "gamemode" ] && iptables -t nat -I PREROUTING $iptablenu -p tcp -j SHADOWSOCKS
	# ipset 黑名单模式
	[ "$ss_mode" == "gfwlist" ] && iptables -t nat -I PREROUTING 2 -p tcp -m set --match-set gfwlist dst -j SHADOWSOCKS
	
	
	#ln -s /etc/misstar/applications/ss/config/pac.conf /tmp/etc/dnsmasq.d/
	
	
	#ipset
	cat /etc/misstar/applications/ss/config/pac_customize.conf /etc/misstar/applications/ss/config/pac.conf | while read line
	do
		echo "server=/.$line/127.0.0.1#15353" >> /tmp/etc/dnsmasq.d/pac_customize.conf
		echo "ipset=/.$line/gfwlist" >> /tmp/etc/dnsmasq.d/pac_customize.conf
	done
	
	/etc/init.d/dnsmasq restart
}

start_ss_rules_whitelist()
{	
	sed -e "s/^/-A nogfwnet &/g" -e "1 i\-N nogfwnet hash:net" $chnroute | ipset -R -!
	sed -e "s/^/-A nogfwnet &/g" -e "1 i\-N nogfwnet hash:net" $chnroute_user | ipset -R -!
	iptables -t nat -A SHADOWSOCK -p tcp -m set ! --match-set nogfwnet dst -j REDIRECT --to-ports 1081
	#iptables -t nat -A PREROUTING -s $lanip/24 -p udp --dport 53 -j DNAT --to $lanip
	MTlog 1 "Done!"
}

start_ss_rules()
{
	iptables -t nat -A SHADOWSOCK -p tcp -j REDIRECT --to-ports 1081
	MTlog 1 "Done!"
}

start_ss_rules_gfwlist()
{
	MTlog 1 "Add iptables rules... "
	ipset -N gfwlist iphash -!
	iptables -t nat -A SHADOWSOCK -p tcp -m set --match-set gfwlist dst -j REDIRECT --to-port 1081
	MTlog 1 "Done!"
}

start_ss_udp()
{
	MTlog 1 "Add iptables UDP rules... "
	ip rule add fwmark 0x01/0x01 table 300
	ip route add local 0.0.0.0/0 dev lo table 300
	iptables -t mangle -N SHADOWSOCKS
	iptables -t mangle -A SHADOWSOCKS -d 0.0.0.0/8 -j RETURN
	iptables -t mangle -A SHADOWSOCKS -d 127.0.0.1/16 -j RETURN
	iptables -t mangle -A SHADOWSOCKS -d $lanip/16 -j RETURN
	iptables -t mangle -A SHADOWSOCKS -d $wanip/16 -j RETURN
	iptables -t mangle -A SHADOWSOCKS -d $ss_server_ip -j RETURN
	iptables -t mangle -A PREROUTING -p udp -j SHADOWSOCKS
	iptables -t mangle -A SHADOWSOCKS -p udp -m set ! --match-set nogfwnet dst -j TPROXY --on-port 1081 --tproxy-mark 0x01/0x01
	MTlog 1 "Done!"
	
	
	chmod -x /opt/filetunnel/stunserver
	killall -9 stunserver
}

stop() 
{
	MTlog 1 "Stopping ss service..."
	# Client Mode
	#service_stop /usr/bin/ss-local
	# Proxy Mode
	killall ss-redir
	killall ss-local
	killall ssr-redir
	killall ssr-local
	killall dns2socks
	killall pdnsd
	# Tunnel
	#service_stop /usr/bin/ss-tunnel
	stop_ss_rules
	MTlog 1 "Done!"
}

stop_ss_rules()
{	
	MTlog 1 "Delete iptables rules... "
	iptables -t nat -S | grep -E 'SHADOWSOCK|SHADOWSOCKS'| sed 's/-A/iptables -t nat -D/g'|sed 1,2d > clean.sh && chmod 777 clean.sh && ./clean.sh && rm clean.sh
	ip rule del fwmark 0x01/0x01 table 300 &> /dev/null
	ip route del local 0.0.0.0/0 dev lo table 300 &> /dev/null
	iptables -t mangle -D PREROUTING -p udp -j SHADOWSOCKS &> /dev/null
	iptables -t nat -D PREROUTING -p tcp -j SHADOWSOCKS &> /dev/null
	iptables -t mangle -F SHADOWSOCKS &> /dev/null
	iptables -t mangle -X SHADOWSOCKS &> /dev/null
	iptables -t nat -F SHADOWSOCK &> /dev/null
	iptables -t nat -X SHADOWSOCK &> /dev/null
	iptables -t nat -F SHADOWSOCKS &> /dev/null
	iptables -t nat -X SHADOWSOCKS &> /dev/null
	ipset destroy nogfwnet &> /dev/null
	ipset destroy gfwlist &> /dev/null
	iptables -t nat -D PREROUTING -s $lanip/24 -p udp --dport 53 -j DNAT --to $redip -m comment --comment "misstar-dnsred" &> /dev/null
	MTlog 1 "Done!"
	MTlog 1 "Remove Cache files..."
	rm -rf /tmp/etc/dnsmasq.d/pac_customize.conf
	/etc/init.d/dnsmasq restart
	MTlog 1 "Done!"
	chmod +x /opt/filetunnel/stunserver
	rm -rf $CONFIG
	rm -rf $DNSCONF
}

status()
{
	status=`ps | grep -E "ss-redir|ssr-redir" | grep bin | grep -v 'grep'  | grep -v script | grep -v '{' | wc -l`
	if [ "$status" == "1" ];then   #进程存在，已运行
		id=$(uci get misstar.ss.id)
		DNS_PORT=1082
		http_status=`curl  -s -w %{http_code} https://www.google.com.hk/images/branding/googlelogo/1x/googlelogo_color_116x41dp.png -k -o /dev/null --socks5-hostname 127.0.0.1:1082`
		if [ "$http_status" == "200" ];then
			echo -e "2\c"   #翻墙正常
		else
			echo -e "3\c"   
		fi
	else
		echo -e "1\c"
	fi
}

dnsstatus()
{
	status=`resolveip www.youtube.com | wc -l`
	if [ "$status" == "0" ]; then
		echo -e "0\c"
	elif [ "$status" == "1" ]; then
		ip=`resolveip www.youtube.com`
		result=`cat $iplist | grep $ip`
		if [ "$result" == "1" ];then
			echo -e "0\c"
		else
			echo -e "1\c"
		fi
	else
		echo -e "1\c"
	fi
}

restart() 
{
	MTlog 1 "Restarting ss service..."
	stop
	sleep 3
	start
}

