# coturn

conf/turnserver.conf  user=coturn:coturn  配置STUN/TURN授权账号
turnadmin -A -u coturn -p coturn  增加或更新web管理员账号
turnadmin -L                      查看管理员账号

turnutils_uclient -v -u coturn -w coturn 192.168.5.220  测试TURN（UDP连接）
turnutils_uclient -v -t -T -u coturn -w coturn 192.168.5.220  测试TURN（TCP连接）

