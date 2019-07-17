<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta name="Copyright" content="Misstar Studio." />
	<meta name="viewport" content="width=1200">
	<link href="/static/css/bc.css?v=<%=ver" rel="stylesheet">
	<link href="/static/css/misstar.css" rel="stylesheet" type="text/css">
	<script type="text/javascript" src="/static/js/jquery.min.js"></script>
	<!--<script type="text/javascript" src="/static/js/global.js"></script>-->
	<!--<script type="text/javascript" src="/static/js/jquery.tab.js"></script>-->
	<script type="text/javascript" src="/static/js/qwrap.js"></script>
	<script type="text/javascript" src="/static/js/jbase64.js"></script>
	<script type="text/javascript" src="/static/js/misstar.js"></script>
	<!--<script type="text/javascript" src="<%=resource/web/luci/js/lay/dest/layui.all.js"></script>-->
	<link rel="stylesheet" href="/static/layui/css/layui.css" media="all" />
	<link rel="stylesheet" href="/static/css/global.css" media="all">
	<link rel="stylesheet" href="/static/font-awesome/css/font-awesome.min.css">
</head>

<body style="background: white;width: 100%;height: 100%;">
	<fieldset class="layui-elem-field">
		<legend>工作状态</legend>
		<div class="layui-field-box">
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">插件版本</label>
					<div class="layui-form-mid" id="version">{$version}
					</div>
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">进程状态</label>
					<div class="layui-form-mid layui-word-aux" id="ss_status">查询中...</div>
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">SS节点</label>
					<div class="layui-form-mid layui-word-aux" id="ss_node">查询中...</div>
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-inline">
					<label class="layui-form-label">DNS状态</label>
					<div class="layui-form-mid layui-word-aux" id="dns_status">查询中...</div>
				</div>
			</div>
		</div>
	</fieldset>
	<form class="layui-form" method="POST" name="dns" id="dns">
		<div id="dns_body">
		</div>
	</form>
	<fieldset class="layui-elem-field layui-field-title" style="float: none;">
		<legend>节点列表</legend>
		<div class="layui-field-box">
			<blockquote class="layui-elem-quote">
				<a href="javascript:;" class="layui-btn layui-btn-small" data-type="add">
					<i class="layui-icon">&#xe608;</i> 添加节点
				</a>
				<a href="javascript:;">
					<input type="file" id="uploadfile" style="display: none;" />
					<button class="layui-btn layui-btn-small" data-type="import"><i class="layui-icon">&#xe630;</i>导入节点</button>
				</a>
			</blockquote>
			<table class="site-table table-hover">
				<thead>
					<tr>
						<th>节点名称</th>
						<th>节点地址</th>
						<th>节点端口</th>
						<th>工作模式</th>
						<th>状态</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id='sslist'>
					<tr>
						<td class="center" colspan="6">
							查询中....
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</fieldset>
	<fieldset class="layui-elem-field layui-field-title">
		<legend>局域网控制</legend>
		<div class="layui-field-box">
			<table class="site-table table-hover">
				<thead>
					<tr>
						<th width="20%">主机名</th>
						<th width="20%">IP</th>
						<th width="20%">MAC</th>
						<th>科学上网</th>
						<th>操作</th>
					</tr>
				</thead>
				<tbody id='lanconlist'>
					<tr>
						<td class="center" colspan="5">
							查询中....
						</td>
					</tr>
				</tbody>
			</table>
		</div>
	</fieldset>
	<fieldset class="layui-elem-field layui-field-title">
		<legend>自定义列表</legend>
		<div class="layui-field-box">
			<blockquote class="layui-elem-quote">
				<a href="javascript:;" class="layui-btn layui-btn-small" data-type="savegfw">
					<i class="layui-icon">&#xe621;</i> 保存
				</a>
				<span>自定义Gfwlist列表，在ss工作模式为gfwlist的时候生效，列表内的网址列表将走ss线路。</span>
			</blockquote>
			<textarea name="gfwlist" id="gfwlist"  placeholder="添加格式(不带前缀网址)：baidu.com,一行一个" class="layui-textarea" style="height: 200px"></textarea>
		</div>
		<div class="layui-field-box">
			<blockquote class="layui-elem-quote">
				<a href="javascript:;" class="layui-btn layui-btn-small" data-type="savewhite">
					<i class="layui-icon">&#xe621;</i> 保存
				</a>
				<span>自定义白名单列表，在ss工作模式为白名单的时候生效，列表内的ip段将不走ss线路。</span>
			</blockquote>
			<textarea name="whitelist" id="whitelist"  placeholder="添加格式(网段/掩码)：8.8.8.0/24 一行一个" class="layui-textarea" style="height: 200px"></textarea>
		</div>
	</fieldset>
	<script type="text/javascript" src="/static/layui/layui.js"></script>

	<script type="tmpl/html" id="tplsslist">
		{if($sslist.length > 0)} 
		{for(var i=0 ; $sslist.length > i ; i++)} 
		<tr id="{$sslist[i].id}">

			<td>{$sslist[i].ss_name}</td>
			<td>{$sslist[i].ss_server}</td>
			<td>{$sslist[i].ss_server_port}</td>
			<td>{$sslist[i].ss_mode}</td>
			<td><span class="ss-status">
				<span class="val">
					{if($sslist[i].iscurrent == 1)}
					查询中... {else}
					未启用 {/if}
				</span>
				<span class="uptime"></span>
			</span>
		</td>
		<td>
			<span class="ss_status">
				<span class="control">
					{if($sslist[i].iscurrent == 1)}
					<a href="javascript:;" class="layui-btn layui-btn-normal layui-btn-mini" data-type="disconnect" data-id={$sslist[i].id}>断开连接</a>
					{else}
					<a href="javascript:;" class="layui-btn layui-btn-normal layui-btn-mini" data-type="connect" data-id={$sslist[i].id}>连接</a>
					<a href="javascript:;" class="layui-btn layui-btn-mini" data-type="edit" data-id={$sslist[i].id}>编辑</a>
					<a href="javascript:;" class="layui-btn layui-btn-danger layui-btn-mini" data-type="del" data-id={$sslist[i].id}>删除</a>{/if}
				</span>
			</span>
		</td>
	</tr>
	{/for} {else}
	<tr>
		<td colspan="7" class="center">
			没有设置信息
		</td>
	</tr>
	{/if}
</script>
<script type="tmpl/html" id="tpladdss">
	<fieldset class="layui-elem-field layui-field-title">
		<legend>编辑<span id="version"></span></legend>
		<div class="layui-field-box">
			<form class="layui-form" method="POST" name="ss" id="ss">
				<input type="hidden" name="id" value="{$id}">

				<div class="layui-form-item">
					<label class="layui-form-label">节点名称</label>
					<div class="layui-input-inline">
						<input type="text" name="ss_name" lay-verify="required" autocomplete="off" placeholder="节点名称" class="layui-input" value="{$ss_name}">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">服务器地址</label>
					<div class="layui-input-inline">
						<input type="text" name="ss_server" lay-verify="required" autocomplete="off" placeholder="请输入服务器域名或者IP" class="layui-input" value="{$ss_server}">
					</div>
				</div>

				<div class=" layui-form-item ">
					<label class="layui-form-label ">服务器端口</label>
					<div class="layui-input-inline ">
						<input type="number " name="ss_server_port" lay-verify="required" lay-verify="number" autocomplete="off " class="layui-input " value="{$ss_server_port}">
					</div>
				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">连接密码</label>
					<div class="layui-input-inline">
						<input type="password" name="ss_password" lay-verify="required" placeholder="请输入密码" autocomplete="off" class="layui-input" value="{$ss_password}">
					</div>
				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">加密方式</label>
					<div class="layui-input-inline">
						<select name="ss_method" lay-filter="ss_method">
							<option value="rc4-md5" id="rc4-md5" selected="selected">rc4-md5</option>
							<option value="rc4-md5-6" id="rc4-md5-6">rc4-md5-6</option>
							<option value="aes-128-cfb" id="aes-128-cfb">aes-128-cfb</option>
							<option value="aes-192-cfb" id="aes-192-cfb">aes-192-cfb</option>
							<option value="aes-256-cfb" id="aes-256-cfb">aes-256-cfb</option>
							<option value="aes-128-ctr" id="aes-128-ctr">aes-128-ctr</option>
							<option value="aes-192-ctr" id="aes-192-ctr">aes-192-ctr</option>
							<option value="aes-256-ctr" id="aes-256-ctr">aes-256-ctr</option>
							<option value="camellia-128-cfb" id="camellia-128-cfb">camellia-128-cfb</option>
							<option value="camellia-192-cfb" id="camellia-192-cfb">camellia-192-cfb</option>
							<option value="camellia-256-cfb" id="camellia-256-cfb">camellia-256-cfb</option>
							<option value="bf-cfb" id="bf-cfb">bf-cfb</option>
							<option value="cast5-cfb" id="cast5-cfb">cast5-cfb</option>
							<option value="des-cfb" id="des-cfb">des-cfb</option>
							<option value="des-ede3-cfb" id="des-ede3-cfb">des-ede3-cfb</option>
							<option value="idea-cfb" id="idea-cfb">idea-cfb</option>
							<option value="rc2-cfb" id="rc2-cfb">rc2-cfb</option>
							<option value="seed-cfb" id="seed-cfb">seed-cfb</option>
							<option value="salsa20" id="salsa20">salsa20</option>
							<option value="chacha20" id="chacha20">chacha20</option>
							<option value="chacha20-ietf" id="chacha20-ietf">chacha20-ietf</option>
							<option value="none" id="none">none</option>
							<option value="aes-128-gcm" id="aes-128-gcm">aes-128-gcm</option>
							<option value="aes-192-gcm" id="aes-192-gcm">aes-192-gcm</option>
							<option value="aes-256-gcm" id="aes-256-gcm">aes-256-gcm</option>
							<option value="chacha20-ietf-poly1305" id="chacha20-ietf-poly1305">chacha20-ietf-poly1305</option>
							<option value="xchacha20-ietf-poly1305" id="xchacha20-ietf-poly1305">xchacha20-ietf-poly1305</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">

					<label class="layui-form-label">工作模式</label>
					<div class="layui-input-inline">
						<select name="ss_mode" lay-filter="ss_mode">
							<option value="gfwlist" id="gfwlist">GfwList</option>
							<option value="gamemode" id="gamemode">游戏模式</option>
							<option value="whitelist" id="whitelist">白名单</option>
							<option value="wholemode" id="wholemode">全局模式</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">ssr</label>
					<div class="layui-input-inline">
						<input type="checkbox" name="ssr_enable" id="ssr_enable" title="ssr">
					</div>

				</div>

				<div class="layui-form-item">
					<label class="layui-form-label">混淆协议</label>
					<div class="layui-input-inline">
						<select name="ssr_protocol" lay-filter="ssr_protocol">
							<option value="origin"  id="origin" selected="selected">origin</option>
							<option value="verify_deflate" id="verify_deflate">verify_deflate</option>
							<option value="auth_sha1_v4" id="auth_sha1_v4">auth_sha1_v4</option>
							<option value="auth_sha1_v4_compatible" id="auth_sha1_v4_compatible">auth_sha1_v4_compatible</option>
							<option value="auth_aes128_sha1" id="auth_aes128_sha1">auth_aes128_sha1</option>
							<option value="auth_aes128_md5" id="auth_aes128_md5">auth_aes128_md5</option>
							<option value="auth_chain_a" id="auth_chain_a">auth_chain_a</option>
							<option value="auth_chain_b" id="auth_chain_b">auth_chain_b</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">协议参数</label>
					<div class="layui-input-inline">
						<input type="text" name="ssr_protocolparam" autocomplete="off" class="layui-input" value="{$ssr_protocolparam}">
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">混淆方式</label>
					<div class="layui-input-inline">
						<select name="ssr_obfs" lay-filter="ssr_obfs">
							<option value="plain" id="plain" selected="selected">plain</option>
							<option value="http_simple" id="http_simple">http_simple</option>
							<option value="http_simple_compatible" id="http_simple_compatible">http_simple_compatible</option>
							<option value="http_post" id="http_post">http_post</option>
							<option value="http_post_compatible" id="http_post_compatible">http_post_compatible</option>
							<option value="tls1.2_ticket_auth" id="tls1-2_ticket_auth">tls1.2_ticket_auth</option>
							<option value="tls1.2_ticket_auth_compatible" id="tls1-2_ticket_auth_compatible">tls1.2_ticket_auth_compatible</option>
							<option value="tls1.2_ticket_fastauth" id="tls1-2_ticket_fastauth">tls1.2_ticket_fastauth</option>
							<option value="tls1.2_ticket_fastauth_compatible"  id="tls1-2_ticket_fastauth_compatible">tls1.2_ticket_fastauth_compatible</option>
							<option value="simple_obfs_http" id="simple_obfs_http">simple_obfs_http</option>
							<option value="simple_obfs_http_compatible" id="simple_obfs_http_compatible">simple_obfs_http_compatible</option>
							<option value="simple_obfs_tls" id="simple_obfs_tls">simple_obfs_tls</option>
							<option value="simple_obfs_tls_compatible" id="simple_obfs_tls_compatible">simple_obfs_tls_compatible</option>
						</select>
					</div>
				</div>
				<div class="layui-form-item">
					<label class="layui-form-label">混淆参数</label>
					<div class="layui-input-inline">
						<input type="text" name="ssr_obfsparam" autocomplete="off" class="layui-input" value="{$ssr_obfsparam}">
					</div>
				</div>
				<div class="layui-form-item">
					<div class="layui-input-block">
						<button class="layui-btn" lay-submit="" lay-filter="demo1">立即提交</button>

					</div>
				</div>
			</form>
		</div>
	</fieldset>
</script>
<script type="tmpl/html" id="tpladdgfw">
	<form class="layui-form" method="POST" name="gfw" id="gfw">
		<div class="layui-form-item">
			<label class="layui-form-label">添加地址</label>
			<div class="layui-input-inline">
				<input type="text" name="address" lay-verify="gfwverify" autocomplete="off" placeholder="比如：baidu.com" class="layui-input" value="">
			</div>
		</div>

		<div class="layui-form-item">
			<div class="layui-input-block">
				<button class="layui-btn" lay-submit="" lay-filter="gfwlist">立即提交</button>
				
			</div>
		</div>
	</form>
</script>
<script type="tmpl/html" id="tpladdwhite">
	<form class="layui-form" method="POST" name="white" id="white">

		<div class="layui-form-item">
			<label class="layui-form-label">添加地址</label>
			<div class="layui-input-inline">
				<input type="text" name="address" lay-verify="whiteverify" autocomplete="off" placeholder="比如：192.168.31.0/24" class="layui-input" value="">
			</div>
		</div>f

		<div class="layui-form-item">
			<div class="layui-input-block">
				<button class="layui-btn" lay-submit="" lay-filter="whitelist">立即提交</button>
				
			</div>
		</div>
	</form>
</script>
<script type="tmpl/html" id="dnsbody">
	<fieldset class="layui-elem-field">
		<legend>DNS加强</legend>
		<div class="layui-field-box">
			<div class="layui-form-item">
				<label class="layui-form-label">模式</label>
				<div class="layui-input-inline" id="dns_mode">
					<select name="dns_mode" lay-filter="dns_mode">
						<option value="pdnsd">PDNSD</option>
						<option value="dns2socks">DNS2SOCKS</option>
					</select>
				</div>
			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">上级DNS</label>
				<div class="layui-input-inline">
					<input type="text" name="dns_server" id="dns_server" lay-verify="required" onclick="tips('为了插件的高可用性，pdnsd模式下插件内置Opendns和Google DNS服务器，如果您配置的DNS服务器查询失败则会尝试上述2组服务器。','#dns_server');" autocomplete="off" placeholder="比如：8.8.8.8" class="layui-input" value="{$dns_server}">
				</div>
			</div>
			<div class=" layui-form-item ">
				<label class="layui-form-label ">端口</label>
				<div class="layui-input-inline ">
					<input type="number " name="dns_port" id="dns_port" lay-verify="number" autocomplete="off" placeholder="比如：53" class="layui-input " value="{$dns_port}">
				</div>
			</div>

			<div class="layui-form-item">
				<label class="layui-form-label">DNS重定向</label>
				<div class="layui-input-inline" id="dns_red_enable1" onclick="tips('如果路由翻墙正常但是电脑不正常，建议开启DNS重定向,可解决电脑DNS被劫持等问题','#dns_red_enable1');">
					<input type="checkbox" name="dns_red_enable" id="dns_red_enable" title="开启">
				</div>

			</div>
			<div class="layui-form-item">
				<label class="layui-form-label">重定向地址</label>
				<div class="layui-input-inline">
					<input type="text" name="dns_red_ip" id="dns_red_ip" autocomplete="off" placeholder="默认请留空" onclick="tips('留空IP为路由器IP（如192.168.31.1）','#dns_red_ip');" class="layui-input" value="{$dns_red_ip}">
				</div>
			</div>
			<div class="layui-form-item">
				<div class="layui-input-block">
					<button class="layui-btn" lay-submit="" lay-filter="dnssetting">立即提交</button>
					
				</div>
			</div>
		</div>
	</fieldset>
</script>
<script type="tmpl/html" id="tpllanconlist">
	<tr>
		<td>
			<select name="hostname" lay-filter="hostname" id="hostname" onclick="loaddevlist();">
				<option value="0">请选择设备</option>
			</select>
		</td>
		<td><span id="hostip"></span></td>
		<td><span id="hostmac"></span></td>
		<td>
			<select name="mode" lay-filter="mode" id="add">
				<option value="0">不走SS</option>
				<option value="1">科学上网</option>
			</select>
		</td>
		<td align="center">
			<a href="javascript:;" class="layui-btn layui-btn-normal layui-btn-mini" data-type="submit" data-id="add">添加</a>
		</td>
	</tr>

	{if($lanconlist.length > 0)} {for(var i=0;  $lanconlist.length > i; i++)} <tr>
		<td>{$lanconlist[i].name}</td>
		<td>{$lanconlist[i].ip}</td>
		<td>{$lanconlist[i].mac}</td>
		<td>
			<select name="mode" id={$lanconlist[i].mac} lay-filter="mode">
				<option value="0" {if($lanconlist[i].mode="0" )}selected="selected" {/if}>不走SS</option>
				<option value="1" {if($lanconlist[i].mode="1" )}selected="selected" {/if}>科学上网</option>
			</select>
		</td>
		<td align="center">
			<a href="javascript:;" class="layui-btn layui-btn-normal layui-btn-mini" data-type="submit" data-id={$lanconlist[i].mac}>提交</a>
			<a href="javascript:;" class="layui-btn layui-btn-danger layui-btn-mini" data-type="delete" data-id={$lanconlist[i].mac}>删除</a>
		</td>
	</tr>
	{/for} {/if}

	<tr>
		<td>缺省规则</td>
		<td>缺省规则</td>
		<td>缺省规则</td>
		<td>
			<select name="mode" lay-filter="mode" id="default">
				<option value="0" id="default0">不走SS</option>
				<option value="1" id="default1">科学上网</option>
			</select>
		</td>
		<td align="center">
			<a href="javascript:;" class="layui-btn layui-btn-normal layui-btn-mini" data-type="submit" data-id="default">提交</a>
		</td>
	</tr>
</script>
<script type="tmpl/html" id="tplgfwlist">
	{if($gfwlist.length > 0)} {for(var i=0; i
	< $gfwlist.length; i++)} <tr>
		<td>{$gfwlist[i].id}</td>
		<td>{$gfwlist[i].address}</td>
		<td align="center">
			<a href="javascript:;" class="layui-btn layui-btn-danger layui-btn-mini" data-type="delgfw" data-id={$gfwlist[i].address}>删除</a>
		</td>

	</tr>
	{/for} {else}
	<tr>
		<td colspan="3" class="center">没有设置信息</td>
	</tr>
	{/if}
</script>
<script type="tmpl/html" id="tplwhitelist">
	{if($whitelist.length > 0)} {for(var i=0; i
	< $whitelist.length; i++)} <tr>
		<td>{$whitelist[i].id}</td>
		<td>{$whitelist[i].address}</td>
		<td align="center">
			<a href="javascript:;" class="layui-btn layui-btn-danger layui-btn-mini" data-type="delwhite" data-id={$whitelist[i].address}>删除</a>
		</td>

	</tr>
	{/for} {else}
	<tr>
		<td colspan="3" class="center">没有设置信息</td>
	</tr>
	{/if}
</script>
<script>

	function tips(data, id) {
		var layer = layui.layer;
		layer.tips(data, id);
	}

	function ssInfo() {
		var version, lastversion;
		var xhr = $.getJSON(buildurl("api", "ss", "get_ss"), {}, function(rsp) {
			if(rsp.code == 0) {
				var tpl = $('#tplsslist').html(),
				tpldata = [],
				list = rsp.list,
				current = rsp.current,
				iscurrent = 0;
				sscurrentId = current.id;

				if(list.length > 0) {
					for(var i = 0; i < list.length; i++) {
						if(list[i].id == current.id) {
							iscurrent = 1;

						} else {
							iscurrent = 0;
						}
						var item = {
							id: list[i].id,
							ss_name: list[i].ss_name,
							ss_server: list[i].ss_server,
							ss_server_port: list[i].ss_server_port,
							ss_mode: list[i].ss_mode,
							id: list[i].id,
							iscurrent: iscurrent
						}
						tpldata.push(item);
					}
				}
				$('#sslist').html(tpl.tmpl({
					sslist: tpldata
				}));
				var tpl = $('#tpllanconlist').html();
				list = rsp.LanCon;
				tpldata = [];
				if(list.length > 0) {
					for(var i = 0; i < list.length; i++) {
						var item = {
							mac: list[i].mac,
							name: list[i].name,
							ip: list[i].ip,
							mode: list[i].mode
						}
						tpldata.push(item);
					}
				}

				$('#lanconlist').html(tpl.tmpl({
					lanconlist: tpldata
				}));
				$("#default" + rsp.ss_acl_default_mode).attr("selected",true);
				var xhr = $.getJSON(buildurl("api", "ss", "get_devlist"), {}, function(rsp) {
					if(rsp.code == 0) {
						hostlist = rsp.list;
						if(hostlist.length > 0) {
							var obj = document.getElementById("hostname");
							obj.options.length = 0;
							obj.options.add(new Option("请选择设备", "0"));
							for(var i = 0; i < hostlist.length; i++) {
								obj.options.add(new Option(hostlist[i].devname, hostlist[i].mac));
							}
						}
					}
				});
				version = rsp.version;
				document.getElementById("version").innerHTML = version;
				var str = window.location.href;
				str = str.substr(str.lastIndexOf("/") + 1);
				iframe = parent.document.getElementById(str);
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				iframe.style.height = dHeight + "px";

			}
			$(".layui-btn").each(function() {
				$(this).unbind('click').click(function() {
					bottonclick($(this).attr('data-type'), $(this).attr('data-id'));
				});
			});
		});
		xhr = $.getJSON(buildurl("api", "ss", "get_dns"), {}, function(rsp) {
			if(rsp.code == 0) {
				var tpl = $('#dnsbody').html();
				var tpldata = {
					dns_server: '',
					dns_port: ''
				};
				dns_info = rsp.dns_info;
				tpldata.dns_server = dns_info.dns_server;
				tpldata.dns_port = dns_info.dns_port;
				if(dns_info.dns_red_ip == 'lanip') {
					tpldata.dns_red_ip = '';
				} else {
					tpldata.dns_red_ip = dns_info.dns_red_ip;
				}
				$('#dns_body').html(tpl.tmpl(tpldata));
				setTimeout(function() {
					var form = layui.form();
					form.render();
				}, 100);
				$("#" + dns_info.dns_mode).attr("selected",true);
				dns_info.dns_red_enable == "1" ? $("#dns_red_enable").attr("checked",true) : tmp=1;
				$('#gfwlist').val(dns_info.pac_customize);
				$('#whitelist').val(dns_info.chn_list);
				$(".layui-btn").each(function() {
					$(this).unbind('click').click(function() {
						bottonclick($(this).attr('data-type'), $(this).attr('data-id'));
					});
				});
				var str = window.location.href;
				str = str.substr(str.lastIndexOf("/") + 1);
				iframe = parent.document.getElementById(str);
				var dHeight = iframe.contentWindow.document.documentElement.scrollHeight;
				iframe.style.height = dHeight + "px";

			}

		});

	}

	layui.use(['form', 'layedit', 'laydate'], function() {
		var form = layui.form(),
		layer = layui.layer,
		layedit = layui.layedit,
		laydate = layui.laydate;

				//创建一个编辑器
				var editIndex = layedit.build('LAY_demo_editor');
				//自定义验证规则
				form.verify({
					title: function(value) {
						if(value.length < 5) {
							return '标题至少得5个字符啊';
						}
					},
					pass: [/(.+){6,12}$/, '密码必须6到12位'],
					gfwverify: [/^[A-Za-z0-9\-.]+$/, '网址格式不正确，请输入比如：baidu.com的地址'],
					whiteverify: [/^(\d{1,2}|1\d\d|2[0-4]\d|25[0-5]).(\d{1,2}|1\d\d|2[0-4]\d|25[0-5]).(\d{1,2}|1\d\d|2[0-4]\d|25[0-5]).(\d{1,2}|1\d\d|2[0-4]\d|25[0-5])\/([0-2]\d|3[0-2])$/, '格式不正确']
				});

				//监听提交
				parent.form.on('submit(demo1)', function(data) {
					var url = this.action,
					method = this.method,
					param = $(this).serialize(),
					formName = this.name;
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					if(data.field.id == '') {
						var reg = new RegExp("=", "g");
						id = BASE64.encoder(data.field.ss_server + data.field.ss_server_port + data.field.ss_password);
						id=BASE64.encoder(id+"misstar.com").substr(0, 30);
						data.field.id = id.replace(/\+/g, "");
						data.field.id = id.replace(/\//g, "");
						data.field.id = id.replace(/=/g, "");
					}
					data.field.ss_name = data.field.ss_name.replace(/ /g, "");
					if(data.field.ssr_enable == 'on') {
						data.field.ssr_enable = 1;
					} else {
						data.field.ssr_enable = 0;
					}
					var xhr = $.post(buildurl("api", "ss", "set_ss"), JSON.stringify(data.field), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							parent.layer.close(dlgform);
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
						}, 200);
					});
					return false;
				});
				form.on('submit(gfwlist)', function(data) {
					var url = this.action,
					method = this.method,
					param = $(this).serialize(),
					formName = this.name;
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});

					var xhr = $.post(buildurl("api", "ss", "add_pac"), JSON.stringify(data.field), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							layer.close(dlgform);
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
							location.reload();
						}, 200);
					});
					return false;
				});
				form.on('submit(whitelist)', function(data) {
					var url = this.action,
					method = this.method,
					param = $(this).serialize(),
					formName = this.name;
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});

					var xhr = $.post(buildurl("api", "ss", "add_white"), JSON.stringify(data.field), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							layer.close(dlgform);
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
							location.reload();
						}, 200);
					});
					return false;
				});
				form.on('submit(dnssetting)', function(data) {
					var url = this.action,
					method = this.method,
					param = $(this).serialize(),
					formName = this.name;
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					data.field.dns_red_enable == 'on' ? data.field.dns_red_enable = 1 : data.field.dns_red_enable = 0;
					if(data.field.dns_red_ip == '') {
						data.field.dns_red_ip = 'lanip';
					}
					var xhr = $.post(buildurl("api", "ss", "set_dns"), JSON.stringify(data.field), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							//layer.close(dlgform);
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
							location.reload();
						}, 200);
					});
					return false;
				});
				form.on('select(dns_mode)', function(data) {
					mode = data.value;
					switch(mode) {
						case "pdnsd":
						data = "正常情况下推荐PDNSD，如果提示DNS放污染失败，请尝试DNS2SOCKS";
						break;
						case "dns2socks":
						data = "dns解析走ss线路，效果受ss线路延迟影响。";
						break;
					}
					layer.tips(data, "#dns_mode");
				});
			});
		</script>
		<script>
			function get_ss_status() {
				var xhr = $.getJSON(buildurl("api", "ss", "get_ssstatus"), {}, function(rsp) {
					if(rsp.code == 0) {
						var status = rsp.ss_status;
						if(status.ss_status == 1) {
							document.getElementById("ss_status").innerHTML = "未运行";
							document.getElementById("ss_node").innerHTML = "无";

						} else if(status.ss_status == 2) {
							document.getElementById("ss_status").innerHTML = "运行中，国外网站加速成功！";
							document.getElementById("ss_node").innerHTML = status.ss_node;
						} else if(status.ss_status == 3) {
							document.getElementById("ss_status").innerHTML = "运行中，国外网站加速失败，请检查ss账号。";
							document.getElementById("ss_node").innerHTML = status.ss_node;
						}

						if(status.ss_dnsstatus == 0) {
							document.getElementById("dns_status").innerHTML = "DNS防污染失败！";
						} else if(status.ss_dnsstatus == 1) {
							document.getElementById("dns_status").innerHTML = "DNS防污染成功。";
						}
					}
					var status = rsp.ss_status,
					uptime = '',
					statusCode = 3,
					trstatus,
					statusText;
					ssConnectStatus = parseInt(rsp.ss_status.ss_status);
					// 0 connected 1 connecting 2 failed 3 close
					switch(ssConnectStatus) {
						case 2:
						statusText = '已连接';
							//uptime = secondToDate(rsp.uptime);
							trstatus = 'conn-st-2';
							break;
							case 3:
							statusText = '连接失败';
							trstatus = 'conn-st-1';
							break;
							case 1:
							statusText = '已断开';
							trstatus = 'conn-st-1';
							break;
							case 4:
							statusText = '未启用';
							trstatus = 'conn-st-3';
							break;
							default:
							statusText = '连接异常';
							trstatus = 'conn-st-3';
							break;
						}

						if(rsp.errcode) {
						// statusText = rsp.errmsg;
						statusText = '<span class="errmsg-wrap" data-error="' + rsp.errmsg + '">连接失败</span>';
						uptime = '';
					};
					var el = document.getElementById(sscurrentId);
					if(el) {
						el.className = trstatus;
						$('.ss-status .val', el).html(statusText);
						if(ssConnectStatus != 2) {
							ctrlstatus = "<a href='javascript:;' class='layui-btn layui-btn-normal layui-btn-mini' data-type='connect' data-id=" +
							sscurrentId +
							">重接</a>	<a href='javascript:;' class='layui-btn layui-btn-mini' data-type='edit' data-id=" +
							sscurrentId +
							">编辑</a>	<a href='javascript:;' class='layui-btn layui-btn-danger layui-btn-mini' data-type='del' data-id=" +
							sscurrentId + ">删除</a>";

						} else {
							ctrlstatus = "<a href='javascript:;' class='layui-btn layui-btn-normal layui-btn-mini' data-type='disconnect' data-id=" + sscurrentId + ">断开连接</a>"
						}
						$('.ss_status .control', el).html(ctrlstatus);
					}
					$(".layui-btn").each(function() {
						$(this).unbind('click').click(function() {
							bottonclick($(this).attr('data-type'), $(this).attr('data-id'));
						});
					});
				});
				return xhr;
			}

			//			function fileimport() {
			//				var selectedFile = document.getElementById("uploadfile").files[0]; //获取读取的File对象
			//
			//				var reader = new FileReader(); //这里是核心！！！读取操作就是由它完成的。
			//				reader.readAsText(selectedFile); //读取文件的内容
			//
			//				reader.onload = function() {
			//					var obj = JSON.parse(this.result);
			//					alert(JSON.stringify(obj.configs[0]));
			//					//
			//					//					$("#uploadfile").unbind().change(function() {
			//					//						$("#fileForm").submit();
			//					//					})
			//				};
			//			}
			function loaddevlist() {
				if(hostlist.length > 0) {
					mac = $('#hostname option:selected').val();
					for(var i = 0; i < hostlist.length; i++) {
						if(hostlist[i].mac == mac) {
							document.getElementById("hostip").innerHTML = hostlist[i].ip;
							document.getElementById("hostmac").innerHTML = mac;
						}
					}
				} else {
					alert("获取设备信息失败或所有设备均已配置或没有设备连接到路由器。");
				}
			}

			function bottonclick(datatype, id) {
				switch(datatype) {
					case "add":
					var tpl = $('#tpladdss').html(),
					tpldata = {};
					dlgform = parent.layer.open({
						type: 1,
						title: false,
						skin: 'layui-layer-rim',
						area: ['600px', '790px'],
						content: tpl.tmpl(tpldata),
						anim: 2,
						zIndex: 1,
						shadeClose: true, 
						btnAlign: 'c',
						scrollbar: false
					});
					setTimeout(function() {
						var form = parent.layui.form();
						form.render();
					}, 100);
					break;
					case "del":
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					$.post(buildurl("api","ss","del_ss"), JSON.stringify({
						id: id
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							ssInfo();
							parent.layer.close(index);
						} else {
							alert(rsp.msg);
							parent.layer.close(index);
						}
					});
					break;
					case "edit":
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					$.post(buildurl("api", "ss", "getssdetail"), JSON.stringify({
						id: id
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							var ss_detail = rsp.ss_detail;
							var tpl = $('#tpladdss').html();
							tpldata = {
								ss_server_port: '',
								ss_password: '',
								ss_server: '',
								ssr_enable: '',
								ss_name: ''
							};
							tpldata.ss_server = ss_detail.ss_server;
							tpldata.ss_server_port = ss_detail.ss_server_port;
							tpldata.ss_password = ss_detail.ss_password;
							tpldata.ssr_enable = ss_detail.ssr_enable;
							tpldata.ss_name = ss_detail.ss_name;
							tpldata.ssr_protocolparam=ss_detail.ssr_protocolparam;
							tpldata.ssr_obfsparam=ss_detail.ssr_obfsparam;
							tpldata.id = id;
							dlgform = parent.layer.open({
								type: 1,
								title: false,
								skin: 'layui-layer-rim',
								area: ['600px', '790px'],
								content: tpl.tmpl(tpldata),
								anim: 2,
								zIndex: 1,
								shadeClose: true, 
								btnAlign: 'c',
								scrollbar: false
							});
							parent.$("#" + ss_detail.ss_mode).attr("selected",true);
							parent.$("#" + ss_detail.ss_method).attr("selected",true);
							parent.$("#" + ss_detail.ssr_protocol).attr("selected",true);
							parent.$("#" + ss_detail.ssr_obfs.replace(".","-")).attr("selected",true);
							ss_detail.ssr_enable == "1" ? parent.$("#ssr_enable").attr("checked",true) : tmp=1;
							setTimeout(function() {
								var form = parent.layui.form();
								form.render();
								parent.layer.close(index);
							}, 100);

						}
					});
					break;
					case "disconnect":
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					$.getJSON(buildurl("api","ss","dconn_ss"), {}, function(rsp) {
						if(rsp.code == 0) {
							ssInfo();
							parent.layer.close(index);
						} else {
							alert(rsp.msg);
						}

					});

					break;
					case "connect":
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					$.post(buildurl("api","ss","conn_ss"), JSON.stringify({
						id: id
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							location.reload();
							parent.layer.close(index);
						} else {
							alert(rsp.msg);
						}

					});

					break;
					case "import":
					alert("本插件支持导入标准电脑端ss配置文件gui-config.json,其他文件无法识别！");
					$("#uploadfile").click();
					$("#uploadfile").unbind().change(function() {
							var selectedFile = document.getElementById("uploadfile").files[0]; //获取读取的File对象

							var reader = new FileReader(); //这里是核心！！！读取操作就是由它完成的。
							reader.readAsText(selectedFile); //读取文件的内容

							reader.onload = function() {

								var obj = JSON.parse(this.result);
								var index = parent.layer.load(0, {
									shade: [0.2, '#393D49']
								});

								var i = 0;

								function impss() {
									if(i < obj.configs.length) {
										setTimeout(function() {
											var id = BASE64.encoder(obj.configs[i].remarks + obj.configs[i].server + obj.configs[i].server_port + obj.configs[i].remarks_base64);
											id=BASE64.encoder(id+"misstar.com").substr(0, 30);
											id = id.replace(/\//g, "");
											name = obj.configs[i].remarks.split("-")[0];
											name = name.replace(/ /g, "");
											var isSSR = true;
											if(typeof(obj.configs[i].obfs) == "undefined") {
												obj.configs[i].obfs = "plain";
												console.log("test");
												isSSR = false;
											}

											if(typeof(obj.configs[i].protocol) == "undefined") {
												obj.configs[i].protocol = "origin";
												console.log("test");
											}
											var data = {
												ss_name: name,
												ss_server: obj.configs[i].server,
												ss_server_port: obj.configs[i].server_port,
												ss_password: obj.configs[i].password,
												ss_method: obj.configs[i].method,
												id: id,
												ss_mode: 'gfwlist',
												ssr_enable: isSSR?'1':'0',
												ssr_obfs: obj.configs[i].obfs,
												ssr_protocol: obj.configs[i].protocol,
												ssr_protocolparam: obj.configs[i].protocolparam,
												ssr_obfsparam: obj.configs[i].obfsparam,
											};
											console.log(JSON.stringify(data));
											parent.layer.msg('正在导入' + name);
											var xhr = $.post(buildurl("api", "ss", "set_ss"), JSON.stringify(data), function(rsp) {
												rsp=JSON.parse(rsp);
												if(rsp.code != 0) {
													alert("失败！");
												}

											});
											i++;
											impss();
										}, 1000)
									} else {
										setTimeout(function() {
											parent.parent.layer.close(index);
											location.reload();
										}, 1000)
									}
								}
								impss();
							};
						})
					break;
					case "submit":
					case "delete":
					var obj = document.getElementById(id);
					var index = obj.selectedIndex;
					mode = obj.options[index].value;
					if(id == "add") {
						id = $('#hostmac').text();
						if(id == '') {
							alert("请选择要添加的设备！");
							return 0;
						}
					}
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					$.post(buildurl("api","ss","set_lancon"), JSON.stringify({
						mac: id,
						mode: mode,
						opt: datatype
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							ssInfo();
							parent.layer.close(index);
						} else {
							alert(rsp.msg);
							parent.layer.close(index);
						}
					});
					break;
					case "savegfw":
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					gfwlist=$('#gfwlist').val();
					var xhr = $.post(buildurl("api", "ss", "save_pac"), JSON.stringify({
						gfwlist:gfwlist
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
							location.reload();
						}, 200);
					});
					break;
					case "savewhite":
					whitelist=$('#whitelist').val();
					var index = parent.layer.load(0, {
						shade: [0.2, '#393D49']
					});
					var xhr = $.post(buildurl("api", "ss", "save_white"), JSON.stringify({
						whitelist:whitelist
					}), function(rsp) {
						rsp=JSON.parse(rsp);
						if(rsp.code == 0) {
							ssInfo();
							//location.reload();
						} else {
							alert("Failed");
						}
						setTimeout(function() {
							parent.layer.close(index);
							location.reload();
						}, 200);
					});
					break;
				}
			}
			var modelSs = (function() {

				return {
					init: function() {
						ssInfo();
					}
				}

			}());
			$(function() {
				modelSs.init();
				window.setInterval("get_ss_status()", 5000);
			});
		</script>
	</body>

	</html>