#PowerDNS使用指南

本目录包括：

- PowerDNS-Authoritative
- PowerDNS-Recursor
- PowerDNS-Admin（web管理工具）
- MySQL（可选）

## 环境

- ubuntu 18.04（使用python3）

## 参数

由于参数比较多，比较复杂，详见`map.jinja`。

- 所有参数都可以覆盖。
- powerdns.config中没有的参数可以传进去。

`不需要修改的参数不用传`

## 使用

不传额外可以起一套示例程序，但显然不符合我们的需求。


## 安装

### 安装PowerDNS

包括：

- 初始化数据库
- 安装Authoritative
- 安装Recursor

**数据库相关参数**

- powerdns.mysql.pdns.database
- powerdns.mysql.pdns.host
- powerdns.mysql.pdns.port
- powerdns.mysql.pdns.root_user
- powerdns.mysql.pdns.root_password
- powerdns.mysql.pdns.powerdns_user
- powerdns.mysql.pdns.powerdns_password

**web api服务相关参数**

- powerdns.config.module.web （web服务开关，yes/no）
- powerdns.config.module.api（api服务开关，yes/no）
 - powerdns.config.web.webserver-address （监听地址，应该为内网地址）
 - powerdns.config.web.webserver-allow-from （允许访问的地址段，应该为内网段，例：10.111.0.0/24）

**recursor递归服务相关参数**

- powerdns.config.recursor.local-address (recursor的监听地址，应为内网地址)
- powerdns.config.recursor.allow-from (允许访问的地址，应为内网段11.11.11.11/24之类的)
- powerdns.config.recursor.forward-zones-recurse （私有地址以外的地址交给谁解析，应为aws的局域网内的dns，.=10.111.0.2）

#### Master

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"pdns": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"root_user": "root",
# 				"root_password": 123456,
# 				"powerdns_password": "powerdnspasswd"
# 			}
# 		},
# 		"config": {
# 			"module": {
# 				"api": "yes",
# 				"web": "yes"
# 			},
# 			"web": {
# 				"webserver-address": "10.111.0.11",
# 				"webserver-allow-from": "10.111.0.0/24"
# 			},
# 			"recursor": {
# 				"local-address": "10.111.0.11",
# 				"allow-from": "10.111.0.0/24",
# 				"forward-zones-recurse": ".=10.111.0.2"
# 			}
# 		}
# 	}
# }

sudo salt 'aa' state.sls powerdns pillar='{"powerdns":{ "mysql": {"pdns": {"host":"127.0.0.1","port":3306,"root_user":"root","root_password":123456,"powerdns_password":"powerdnspasswd" } } ,"config": {"module": {"api":"yes","web":"yes" }, "web":{"webserver-address":"10.111.0.11", "webserver-allow-from":"10.111.0.0/24"}, "recursor": {"local-address":"10.111.0.11","allow-from":"10.111.0.0/24","forward-zones-recurse":".=10.111.0.2" } } }}'
```

#### Slave

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"pdns": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"root_user": "root",
# 				"root_password": 123456,
# 				"powerdns_password": "powerdnspasswd"
# 			}
# 		},
# 		"config": {
# 			"recursor": {
# 				"local-address": "10.111.0.11",
# 				"allow-from": "10.111.0.0/24",
# 				"forward-zones-recurse": ".=10.111.0.2"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns pillar='{"powerdns":{ "mysql": {"pdns": {"host":"127.0.0.1","port":3306,"root_user":"root","root_password":123456,"powerdns_password":"powerdnspasswd" } } ,"config": {"recursor": {"local-address":"10.111.0.11","allow-from":"10.111.0.0/24","forward-zones-recurse":".=10.111.0.2" } } }}'
```

### 安装Admin

包括：

- 初始化数据库
- 安装Admin
- 安装Nginx

```bash
# "config": {"nginx": {"server_name":"www.poweradmin.com"} } 选填
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"admin": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"root_user": "root",
# 				"root_password": 123456,
# 				"admin_password": "adminpasswd"
# 			}
# 		},
# 		"config": {
# 			"nginx": {
# 				"server_name": "www.poweradmin.com"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.admin pillar='{"powerdns":{ "mysql": {"admin": {"host":"127.0.0.1","port":3306,"root_user":"root","root_password":123456,"admin_password":"adminpasswd" } },"config": {"nginx": {"server_name":"www.poweradmin.com"} } }}'

```

详见[详细介绍](#详细介绍)

## 详细介绍（分解步骤）

### 创建MySQL数据库（不是必须）

**相关参数**

- powerdns.mysql.pdns.root_password

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"pdns": {
# 				"root_password": 123456
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.mysql pillar='{"powerdns":{ "mysql": {"pdns": {"root_password":123456 } } }}'
```

### PowerDNS-Authoritative

#### 初始化数据库（Authoritative服务的数据里）

**相关参数**

- powerdns.mysql.pdns.database
- powerdns.mysql.pdns.host
- powerdns.mysql.pdns.port
- powerdns.mysql.pdns.root_user
- powerdns.mysql.pdns.root_password
- powerdns.mysql.pdns.powerdns_user
- powerdns.mysql.pdns.powerdns_password


```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"pdns": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"root_user": "root",
# 				"root_password": 123456,
# 				"powerdns_password": "powerdnspasswd"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.authoritative.setup-database  pillar='{"powerdns":{ "mysql": {"pdns": {"host":"127.0.0.1","port":3306,"root_user":"root","root_password":123456,"powerdns_password":"powerdnspasswd" } } }}'
```

#### 修改systemd-resolved

ubuntu18.04，systemd-resolved服务会占用53端口

**相关参数**

```bash
sudo salt 'aa' state.sls powerdns.authoritative.modify-dns-setting
```


#### 安装Authoritative 

```bash
sudo salt 'aa' state.sls powerdns.authoritative.authoritative
```

#### 更新Authoritative配置

**相关参数**

- powerdns.mysql.pdns.database
- powerdns.mysql.pdns.host
- powerdns.mysql.pdns.port
- powerdns.mysql.pdns.powerdns_user
- powerdns.mysql.pdns.powerdns_password
- powerdns.mysql.pdns.dnssec
- powerdns.config.web下所有参数
 - powerdns.config.web.webserver-address （监听地址，应该为内网地址）
 - powerdns.config.web.webserver-allow-from （允许访问的地址段，应该为内网段，例：10.111.0.0/24）
- powerdns.config.api下所有参数


**模块开关**

默认是关着的：

- powerdns.config.module.web（是否启动webserver）
- powerdns.config.module.api （是否启动api）

`master的机器会开启这两个参数`

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"config": {
# 			"module": {
# 				"api": "yes",
# 				"web": "yes"
# 			}
# 		},
# 		"web": {
# 			"webserver-address": "10.111.0.11",
# 			"webserver-allow-from": "10.111.0.0/24"
# 		},
# 		"mysql": {
# 			"pdns": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"powerdns_password": "powerdnspasswd"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.authoritative.config  pillar='{"powerdns":{ "config": {"module": {"api":"yes","web":"yes" } },  "web":{"webserver-address":"10.111.0.11", "webserver-allow-from":"10.111.0.0/24"}, "mysql": {"pdns": {"host":"127.0.0.1","port":3306,"powerdns_password":"powerdnspasswd" } } }}'
```

### 安装Recursor

```bash
sudo salt 'aa' state.sls powerdns.recursor.recursor
```

### 更新Recursor配置

**相关参数**

- powerdns.config.recursor下的所有参数
 - powerdns.config.recursor.local-address (recursor的监听地址，应为内网地址)
 - powerdns.config.recursor.allow-from (允许访问的地址，应为内网段11.11.11.11/24之类的)
 - powerdns.config.recursor.forward-zones-recurse （私有地址以外的地址交给谁解析，应为aws的局域网内的dns，.=10.111.0.2）

**forward_zones_file**

想让Authoritative解析的私有地址，请在`conf/forward/zones`中添加

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"config": {
# 			"recursor": {
# 				"local-address": "10.111.0.11",
# 				"allow-from": "10.111.0.0/24",
# 				"forward-zones-recurse": ".=10.111.0.2"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.recursor.config  pillar='{"powerdns":{ "config": {"recursor": {"local-address":"10.111.0.11","allow-from":"10.111.0.0/24","forward-zones-recurse":".=10.111.0.2" } } }}'
```

### 安装web Admin

#### 初始化数据库（web Admin服务的数据库）

**相关参数**

- powerdns.mysql.admin.database
- powerdns.mysql.admin.host
- powerdns.mysql.admin.port
- powerdns.mysql.admin.root_user
- powerdns.mysql.admin.root_password
- powerdns.mysql.admin.admin_user
- powerdns.mysql.admin.admin_password

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"admin": {
# 				"host": "127.0.0.1",
# 				"port": 3306,
# 				"root_user": "root",
# 				"root_password": 123456,
# 				"admin_password": "adminpasswd"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.admin.setup-database  pillar='{"powerdns":{ "mysql": {"admin": {"host":"127.0.0.1","port":3306,"root_user":"root","root_password":123456,"admin_password":"adminpasswd" } } }}'
```

#### 安装Admin


**相关参数**

- powerdns.mysql.admin.database
- powerdns.mysql.admin.host
- powerdns.mysql.admin.admin_user
- powerdns.mysql.admin.admin_password
- powerdns.config.admin.secret_key
- powerdns.config.admin.bind_address
- powerdns.config.admin.port
- powerdns.config.admin.log_level

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"mysql": {
# 			"admin": {
# 				"host": "127.0.0.1",
# 				"admin_password": "adminpasswd"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.admin.setup-database  pillar='{"powerdns":{ "mysql": {"admin": {"host":"127.0.0.1","admin_password":"adminpasswd"} } }}'
```

#### 安装nginx

**相关参数**

- powerdns.config.nginx.server_name（目前是_,如果给他配置了域名，可以修改成域名）

```bash
sudo salt 'aa' state.sls powerdns.admin.nginx
```

#### 更新nginx的配置

**相关参数**

- powerdns.config.nginx.server_name（目前是_,如果给他配置了域名，可以修改成域名）
- 相关配置文件请参考`nginx/conf下的文件`

```bash
# pillar的格式化注释
# {
# 	"powerdns": {
# 		"config": {
# 			"nginx": {
# 				"server_name": "_"
# 			}
# 		}
# 	}
# }
sudo salt 'aa' state.sls powerdns.admin.nginx.config pillar='{"powerdns":{ "config": {"nginx": {"server_name":"_"} } }}'
```