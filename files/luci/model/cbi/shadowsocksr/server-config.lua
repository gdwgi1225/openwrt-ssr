-- Copyright (C) 2017 yushi studio <ywb94@qq.com>
-- Licensed to the public under the GNU General Public License v3.

local m, s, o
local shadowsocksr = "shadowsocksr"
local sid = arg[1]

local encrypt_methods = {
	"none",
	"aes-128-ctr",
	"aes-192-ctr",
	"aes-256-ctr",
	"aes-128-cfb",
	"aes-192-cfb",
	"aes-256-cfb",
	"rc4",
	"rc4-md5",
	"rc4-md5-6",
	"aes-128-cfb8",
	"aes-192-cfb8",
	"aes-256-cfb8",
	"salsa20",
	"chacha20",
	"chacha20-ietf",
}

local protocol = {
	"origin",
	"verify_deflat",
	"auth_sha1_v4",
	"auth_aes128_md5",
	"auth_aes128_sha1",
	"auth_chain_a",
	"auth_chain_b",
	"auth_chain_c",
	"auth_chain_d",
}

obfs = {
	"plain",
	"http_simple",
	"http_post",
	"random_head",
	"tls1.2_ticket_auth",
	"tls1.2_ticket_fastauth",
}

m = Map(shadowsocksr, translate("Edit ShadowSocksR Server"))

m.redirect = luci.dispatcher.build_url("admin/services/shadowsocksr/server")
if m.uci:get(shadowsocksr, sid) ~= "server_config" then
	luci.http.redirect(m.redirect) 
	return
end




-- [[ Server Setting ]]--
s = m:section(NamedSection, sid, "server_config")
s.anonymous = true
s.addremove   = false

o = s:option(Flag, "enable", translate("Enable"))
o.default = 1
o.rmempty = false

o = s:option(Value, "server", translate("Server Address"))
o.datatype = "ipaddr"
o.default = "0.0.0.0"
o.rmempty = false

o = s:option(Value, "server_port", translate("Server Port"))
o.datatype = "port"
o.default = 8388
o.rmempty = false

o = s:option(Value, "timeout", translate("Connection Timeout"))
o.datatype = "uinteger"
o.default = 60
o.rmempty = false

o = s:option(Value, "password", translate("Password"))
o.password = true
o.rmempty = false

o = s:option(ListValue, "encrypt_method", translate("Encrypt Method"))
for _, v in ipairs(encrypt_methods) do o:value(v) end
o.rmempty = false

o = s:option(ListValue, "protocol", translate("Protocol"))
for _, v in ipairs(protocol) do o:value(v) end
o.rmempty = false

o = s:option(Value, "protocol_param", translate("protocol param(optional)"))

o = s:option(ListValue, "obfs", translate("Obfs"))
for _, v in ipairs(obfs) do o:value(v) end
o.rmempty = false

o = s:option(Value, "obfs_param", translate("Obfs param(optional)"))

o = s:option(Flag, "fast_open", translate("TCP Fast Open"))
o.rmempty = false

return m
