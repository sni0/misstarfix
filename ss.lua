api=arg[1]
data=arg[2]


local cjson = require "cjson"
local LuciUtil = require("luci.util")
local uci = require("luci.model.uci").cursor()


function get_ss()
    local result = {}
    local list = getSSList()
    local current = getSSInfo("interface")
    local version = uci:get("misstar","ss","version")
    
    local ss_acl_default_mode=uci:get("misstar","ss","ss_acl_default_mode")
    local LanCon={}
    local conf=LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | awk -F ',' '{print $1}'")
    local hostlist=string.split(conf,'\n')
    for i,v in pairs(hostlist) do 
      if hostlist[i] ~= '' then
         local item = {
         ["mac"] = LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | grep '"  ..hostlist[i]..  "' | awk -F ',' '{print $1}'"),
         ["name"] = LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | grep '"  ..hostlist[i]..  "' | awk -F ',' '{print $2}'"),
         ["ip"] = LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | grep '"  ..hostlist[i]..  "' | awk -F ',' '{print $3}'"),
         ["mode"] = tonumber(LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | grep '"  ..hostlist[i]..  "' | awk -F ',' '{print $4}'"))
     }
     table.insert(LanCon, item)
 end
end

result["LanCon"]=LanCon

result["ss_acl_default_mode"]=ss_acl_default_mode
result["code"] = 0
result["current"] = current
result["list"] = list
result["version"] = version
print(cjson.encode(result))
end

function getSSInfo(interface)
    local info = {
    proto = "",
    server = "",
    username = "",
    password = "",
    id = ""
}
local id = uci:get("misstar","ss","id")
local enable=uci:get("misstar","ss","enable")
if id then
    info.id = id
    info.enable = enable
end
return info
end


function getSSList()
    local result = {}
    uci:foreach("misstar", "ss",
        function(s)
            local item = {
            ["ss_server"] = s.ss_server,
            ["ss_name"] = s.ss_name,
            ["ss_server_port"] = s.ss_server_port,
            ["ss_mode"] = s.ss_mode,
            ["id"] = s.id
        }
        table.insert(result, item)
            -- result[s.id] = item
        end
        )
    return result
end

function getssdetail(data)
    local result = {}
    local ss_detail= {}
    data=cjson.decode(data)
    local id=data.id
    ss_detail.ss_name = uci:get("misstar",id,"ss_name")
    ss_detail.ss_method = uci:get("misstar",id,"ss_method")
    ss_detail.ssr_enable = uci:get("misstar",id,"ssr_enable")
    ss_detail.ssr_protocol = uci:get("misstar",id,"ssr_protocol")
    ss_detail.ssr_obfs = uci:get("misstar",id,"ssr_obfs")
    ss_detail.ss_server = uci:get("misstar",id,"ss_server")
    ss_detail.ss_server_port = uci:get("misstar",id,"ss_server_port")
    ss_detail.ss_password = uci:get("misstar",id,"ss_password")
    ss_detail.ss_mode = uci:get("misstar",id,"ss_mode")
    ss_detail.ssr_protocolparam = uci:get("misstar",id,"ssr_protocolparam")
    ss_detail.ssr_obfsparam = uci:get("misstar",id,"ssr_obfsparam")
    result["code"]=0
    result["ss_detail"]=ss_detail
    print(cjson.encode(result))
end

function set_ss(data)
    local code = 0
    local result = {}
    data=cjson.decode(data)
    local ss_name = data.ss_name
    local ss_server = data.ss_server
    local ss_server_port = data.ss_server_port
    local ss_password = data.ss_password
    local ss_method = data.ss_method
    local ss_mode = data.ss_mode
    local ssr_enable = data.ssr_enable
    local ssr_protocol = data.ssr_protocol
    local ssr_obfs = data.ssr_obfs
    local ssr_protocolparam = data.ssr_protocolparam
    local ssr_obfsparam = data.ssr_obfsparam
    local id = data.id

    
    if ssr_protocolparam== nil then
        ssr_protocolparam=''
    end
    if ssr_obfsparam== nil then
        ssr_obfsparam=''
    end
--[[    print(ssr_protocolparam)
    print(ssr_obfsparam)]]
    LuciUtil.exec("uci set misstar." ..id.. "=ss")
    LuciUtil.exec("uci set misstar." ..id.. ".ss_name=" ..ss_name)
    LuciUtil.exec("uci set misstar." ..id.. ".ss_server=" ..ss_server)
    LuciUtil.exec("uci set misstar." ..id.. ".ss_server_port=" ..ss_server_port)
    LuciUtil.exec("uci set misstar." ..id.. ".ss_password=" ..ss_password)
    LuciUtil.exec("uci set misstar." ..id.. ".ss_method=" ..ss_method)
    LuciUtil.exec("uci set misstar." ..id.. ".ss_mode=" ..ss_mode)
    LuciUtil.exec("uci set misstar." ..id.. ".ssr_enable=" ..ssr_enable)
    LuciUtil.exec("uci set misstar." ..id.. ".ssr_protocol=" ..ssr_protocol)
    LuciUtil.exec("uci set misstar." ..id.. ".ssr_obfs=" ..ssr_obfs)
    LuciUtil.exec("uci set misstar." ..id.. ".ssr_protocolparam=" ..ssr_protocolparam)
    LuciUtil.exec("uci set misstar." ..id.. ".ssr_obfsparam=" ..ssr_obfsparam)
    LuciUtil.exec("uci set misstar." ..id.. ".id=" ..id)
    LuciUtil.exec("uci commit misstar")


    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = XQErrorUtil.getErrorMessage(result.code)
    end
    print(cjson.encode(result))
end

function set_lancon(data)
	local code = 0
    local result = {}
    data=cjson.decode(data)
    local set=false
    local mac=data.mac
    local mode=data.mode
    local opt=data.opt
    local name
    local ip
    if mac == 'default' then
    	LuciUtil.exec("uci set misstar.ss.ss_acl_default_mode=" ..mode)
      LuciUtil.exec("uci commit misstar")
  else 
     LuciUtil.exec("sed -i '/" ..mac.. "/d' /etc/misstar/applications/ss/config/LanCon.conf")
     if opt == 'submit' then
       name=LuciUtil.exec("cat /tmp/dhcp.leases | grep -i " ..mac.. " | awk '{print $4}'")
       ip=LuciUtil.exec("cat /tmp/dhcp.leases | grep -i '"  ..mac..  "' | awk -F ' ' '{print $3}'")
       LuciUtil.exec("echo " ..mac.. "," ..string.sub(name,1,-2).. "," ..string.sub(ip,1,-2).. "," ..mode.. " >> /etc/misstar/applications/ss/config/LanCon.conf")
   end
end
LuciUtil.exec("/etc/misstar/applications/ss/script/ss restart")
result["code"]=0
result["list"]=deviceList
print(cjson.encode(result))
end




function del_ss(data)
    local result = {}
    data=cjson.decode(data)
    local id = data.id
    uci:delete("misstar", id)
    uci:commit("misstar")
    result["code"] = 0
    print(cjson.encode(result))
end

function dconn_ss(data)
    local result = {}
    LuciUtil.exec("uci set misstar.ss.enable=0")
    uci:commit("misstar")
    LuciUtil.exec("/etc/misstar/applications/ss/script/ss restart")
    result["code"] = 0
    print(cjson.encode(result))
end

function conn_ss(data)
    local result = {}
    data=cjson.decode(data)
    local id = data.id
    LuciUtil.exec("uci set misstar.ss.id=" ..id)
    LuciUtil.exec("uci set misstar.ss.enable=1")
    uci:commit("misstar")
    LuciUtil.exec("/etc/misstar/applications/ss/script/ss restart")
    result["code"] = 0
    print(cjson.encode(result))
end

function get_ssstatus()
	local ss_status={}
	local result = {}
	ss_status.ss_status=LuciUtil.exec("/etc/misstar/applications/ss/script/ss status")
	ss_status.ss_dnsstatus=LuciUtil.exec("/etc/misstar/applications/ss/script/ss dnsstatus")
	local id=uci:get("misstar","ss","id")
	ss_status.ss_node=uci:get("misstar",id,"ss_name")
	result["code"]=0
	result["ss_status"]=ss_status
	print(cjson.encode(result))
end

function get_dns()
	local dns_info={}
	local result = {}
	dns_info.dns_mode = uci:get("misstar","ss","dns_mode")
	dns_info.dns_server = uci:get("misstar","ss","dns_server")
	dns_info.dns_port = uci:get("misstar","ss","dns_port")
	
	dns_info.dns_red_enable = uci:get("misstar","ss","dns_red_enable")
	dns_info.dns_red_ip = uci:get("misstar","ss","dns_red_ip")

	
	dns_info.pac_customize=LuciUtil.exec("cat /etc/misstar/applications/ss/config/pac_customize.conf | grep -v ^$")

	dns_info.chn_list=LuciUtil.exec("cat /etc/misstar/applications/ss/config/chnroute_customize.conf | grep -v ^$")
	
	result["code"]=0
	result["dns_info"]=dns_info
	print(cjson.encode(result))
end



function set_dns(data)
	local code = 0
    local result = {}
    data=cjson.decode(data)
    local dns_mode = data.dns_mode
    local dns_server = data.dns_server
    local dns_port = data.dns_port

    local dns_red_enable = data.dns_red_enable
    local dns_red_ip = data.dns_red_ip

    
    LuciUtil.exec("uci set misstar.ss.dns_mode=" ..dns_mode)
    LuciUtil.exec("uci set misstar.ss.dns_server=" ..dns_server)
    LuciUtil.exec("uci set misstar.ss.dns_port=" ..dns_port)
    
    LuciUtil.exec("uci set misstar.ss.dns_red_enable=" ..dns_red_enable)
    LuciUtil.exec("uci set misstar.ss.dns_red_ip=" ..dns_red_ip)
    
    LuciUtil.exec("uci commit misstar ")

    LuciUtil.exec("/etc/misstar/applications/ss/script/ss dnsconfig")

    set=true
    
    if set then
        code = 0
    else
        code = 1583
    end
    result["code"] = code
    if result.code ~= 0 then
        result["msg"] = XQErrorUtil.getErrorMessage(result.code)
    end
    print(cjson.encode(result))
end

function get_devlist()
    local deviceList = {}

    local conf=LuciUtil.exec("cat /tmp/dhcp.leases | awk -F ' ' '{print $2}'")
    local hostlist=string.split(conf,'\n')
    for i,v in pairs(hostlist) do 
      if hostlist[i] ~= '' then

       local isexist= LuciUtil.exec("cat /etc/misstar/applications/ss/config/LanCon.conf | grep -i '" ..hostlist[i].. "' | wc -l")
       if tonumber(isexist) == 0 then
        ip= LuciUtil.exec("cat /tmp/dhcp.leases | grep -i '"  ..hostlist[i]..  "' | awk -F ' ' '{printf $3}'")
        if ip ~= '' then
            local item = {
            ["mac"] = hostlist[i],
            ["devname"] = LuciUtil.exec("cat /tmp/dhcp.leases | grep -i '"  ..hostlist[i]..  "' | awk -F ' ' '{printf $4\"(\"$3\")\"}'"),
            ["ip"] = ip
        }
        table.insert(deviceList, item)
    end
    
end
end
end
local result={}
result["code"]=0
result["list"]=deviceList
print(cjson.encode(result))
end



function save_pac(data)
	local code = 0
	local result = {}
    data=cjson.decode(data)
    local address=data.gfwlist
    local f = assert(io.open("/etc/misstar/applications/ss/config/pac_customize.conf", "w"))
    f:write(address)
    f:close()
    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = "添加失败。"
    end
    print(cjson.encode(result))
end

function save_white(data)
	local code = 0
	local result = {}
    data=cjson.decode(data)
    local address=data.whitelist
    local f = assert(io.open("/etc/misstar/applications/ss/config/chnroute_customize.conf", "w"))
    f:write(address)
    f:close()
    result["code"] = 0
    if result.code ~= 0 then
        result["msg"] = "添加失败。"
    end
    print(cjson.encode(result))
end


if (api=="get_ss") then
    get_ss(data)
    elseif (api=="set_dns") then
        set_dns(data)
        elseif(api=="get_ssstatus") then
            get_ssstatus()
            elseif (api=="conn_ss") then
                conn_ss(data) 
                elseif (api=="dconn_ss") then
                    dconn_ss(data) 
                    elseif (api=="getssdetail") then
                        getssdetail(data) 
                        elseif (api=="set_ss") then
                            set_ss(data) 
                            elseif (api=="del_ss") then
                                del_ss(data) 
                                elseif (api=="set_lancon") then
                                    set_lancon(data) 
                                    elseif (api=="get_devlist") then
                                        get_devlist(data) 
                                        elseif (api=="get_dns") then
                                            get_dns(data) 
                                            elseif (api=="save_pac") then
                                                save_pac(data) 
                                                elseif (api=="save_white") then
                                                    save_white(data) 
                                                else
                                                    local code = 999
                                                    local result = {}
                                                    result["code"] = code
                                                    result["msg"] = "Api not Found"
                                                    print(cjson.encode(result))
                                                end
