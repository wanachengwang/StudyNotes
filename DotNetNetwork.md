## Net Analysis Console Tool
    netstat -ano | findstr "52280"    
        0.0.0.0:   本机的所有IP集合
        127.0.0.1：本机loopback地址，无法对外提供服务
    nslookup 163.com
        查看DNS解析记录，如有多个记录，用Ping只能看到一个
    tracert 163.com
        跟踪显示本地到目标站沿途经过的节点

    注意：通常网站都应用了网宿科技的网络加速服务，即在本地建立镜像，所以nslookup会查到ourglb0.com，而不是真正的网站。

## Socket通信IO模式比较
|模式|说明|
|----|----|
|Blocking| 阻塞模式socket调用recvfrom
|NonBlocking| 非阻塞模式socket调用recvfrom，返回EWOULDBLOCK error, 但不阻塞
|IO Complexing| 多个阻塞模式Socket，用Select多路复用；poll/epoll为每个socket使用callback，以避免Select轮询，优化性能。
|SignalDriven IO| 仅Unix支持的SIGIO
|Asynchronous IO| Windows的IOCP
参考：(http://blog.csdn.net/wenbingoon/article/details/9004512)
![Comparation of 5 Net IO Modes](files/net5modes.jpg)

## 利用DNS轮询做负载均衡
1. 只能应用于有域名的IP组，所以一般来说 登陆服务器组。
2. 在域名解析添加多个A记录(Address记录)，然后将解析请求按照A记录的顺序，解析到每条记录的IP上。
3. 某些DNS服务商能够区分电信/联通线路。其实可以支持更多算法，但是服务商一般不提供。
4. 缺点一：DNS通常有缓存，至少一个小时甚至3-4小时才更新，所以均衡效果不是那么好。
5. 缺点二：如果其中一个IP宕机，DNS解析到这个IP上的所有客户端都会连不上(直到DNS刷新)

## Http
### Put | Delete | Post | Get
这是Http规范的增删改查，但事实上服务器可以根据命令参数任何违反规范的事情，例如：
1. 用Get来修改数据，因为用Post用到Form，麻烦一点
2. Put 和Delete现在基本都用Get/Post完成替代了
### Get vs Post
| |Get|Post|
|-|---|----|
|Data Format|Get请求数据附在url后，格式Url?Para0=hyddd&Para0=%E4%BD%A0。英文字母/数字，原样发送；空格转换为+；中文/其它用BASE64加密(如%E4%BD%A0，%XX是16进制ASCII)。|Post提交的数据放置在HTTP包体中。|
|Data Length|Get最大数据长度=浏览器最大Url长度(2083 in IE) | Post无限制(200k in IIS6, Form<100k)|
|ASP API | Request.QueryString | Request.Form |
|JSP API | request.getParameter直接输出|request.getParameter赋给变量 |
|PHP API | $_GET | $_POST |
|场景|可分享的URL链接|涉及密码等私密信息|
### HttpWebRequest HttpRequest
- HttpRequest 用于服务器端,获取客户端传来的请求信息(ASP.net)
- HttpWebRequest用于客户端，拼接请求的HTTP报文并发送等
- https://www.cnblogs.com/kissdodog/archive/2013/04/06/3002779.html
### TCPClient

## Https
TODO：


