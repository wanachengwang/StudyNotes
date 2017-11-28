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
