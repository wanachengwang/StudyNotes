## Listen/Connection Relation Table 
+ 使用命令netstat -ano | findstr "52280" //52280是PID
+ 大部分端口是动态分配的，标[定]的为固定端口
### loginapp
    -  TCP    0.0.0.0:20013          0.0.0.0:0              LISTENING       定，客户端端口需是20013
    -  TCP    0.0.0.0:31000          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52261          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:21103    0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52285    192.168.1.254:52268    ESTABLISHED     logger
    -  TCP    192.168.1.254:52293    192.168.1.254:52265    ESTABLISHED     dbmgr
    -  TCP    192.168.1.254:52294    192.168.1.254:52264    ESTABLISHED     baseappmgr
### logger
    -  TCP    0.0.0.0:34000          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52267          0.0.0.0:0              LISTENING       
    -  TCP    0.0.0.0:52268          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52268    192.168.1.254:52280    ESTABLISHED     baseappmgr
    -  TCP    192.168.1.254:52268    192.168.1.254:52281    ESTABLISHED     dbmgr
    -  TCP    192.168.1.254:52268    192.168.1.254:52282    ESTABLISHED     cellappmgr
    -  TCP    192.168.1.254:52268    192.168.1.254:52283    ESTABLISHED     cellapp
    -  TCP    192.168.1.254:52268    192.168.1.254:52285    ESTABLISHED     loginapp
    -  TCP    192.168.1.254:52268    192.168.1.254:52286    ESTABLISHED     baseapp
### dbmgr 
    -  TCP    0.0.0.0:32000          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52265          0.0.0.0:0              LISTENING       
    -  TCP    127.0.0.1:52269        127.0.0.1:30099        ESTABLISHED     interfaces
    -  TCP    127.0.0.1:52271        127.0.0.1:3306         ESTABLISHED     MySQL
    -  TCP    127.0.0.1:52272        127.0.0.1:3306         ESTABLISHED     MySQL
    -  TCP    127.0.0.1:52273        127.0.0.1:3306         ESTABLISHED     MySQL
    -  TCP    127.0.0.1:52274        127.0.0.1:3306         ESTABLISHED     MySQL
    -  TCP    127.0.0.1:52275        127.0.0.1:3306         ESTABLISHED     MySQL
    -  TCP    192.168.1.254:52265    192.168.1.254:52288    ESTABLISHED     baseappmgr
    -  TCP    192.168.1.254:52265    192.168.1.254:52290    ESTABLISHED     cellappmgr
    -  TCP    192.168.1.254:52265    192.168.1.254:52293    ESTABLISHED     loginapp
    -  TCP    192.168.1.254:52265    192.168.1.254:52296    ESTABLISHED     cellapp
    -  TCP    192.168.1.254:52265    192.168.1.254:52299    ESTABLISHED     baseapp
    -  TCP    192.168.1.254:52281    192.168.1.254:52268    ESTABLISHED     logger
### baseappmgr
    -  TCP    0.0.0.0:52264          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52264    192.168.1.254:52291    ESTABLISHED     cellappmgr
    -  TCP    192.168.1.254:52264    192.168.1.254:52294    ESTABLISHED     loginapp
    -  TCP    192.168.1.254:52264    192.168.1.254:52298    ESTABLISHED     cellapp
    -  TCP    192.168.1.254:52264    192.168.1.254:52300    ESTABLISHED     baseapp
    -  TCP    192.168.1.254:52280    192.168.1.254:52268    ESTABLISHED     logger
    -  TCP    192.168.1.254:52288    192.168.1.254:52265    ESTABLISHED     dbmgr
### cellappmgr
    -  TCP    0.0.0.0:52263          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52263    192.168.1.254:52297    ESTABLISHED     cellapp
    -  TCP    192.168.1.254:52263    192.168.1.254:52301    ESTABLISHED     baseapp
    -  TCP    192.168.1.254:52282    192.168.1.254:52268    ESTABLISHED     logger
    -  TCP    192.168.1.254:52290    192.168.1.254:52265    ESTABLISHED     dbmgr
    -  TCP    192.168.1.254:52291    192.168.1.254:52264    ESTABLISHED     baseappmgr
### baseapp 
    -  TCP    0.0.0.0:20015          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:40000          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52266          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52266    192.168.1.254:52302    ESTABLISHED     cellapp
    -  TCP    192.168.1.254:52286    192.168.1.254:52268    ESTABLISHED     logger
    -  TCP    192.168.1.254:52299    192.168.1.254:52265    ESTABLISHED     dbmgr
    -  TCP    192.168.1.254:52300    192.168.1.254:52264    ESTABLISHED     baseappmgr
    -  TCP    192.168.1.254:52301    192.168.1.254:52263    ESTABLISHED     cellappmgr
### cellapp 
    -  TCP    0.0.0.0:50000          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52260          0.0.0.0:0              LISTENING       
    -  TCP    192.168.1.254:52283    192.168.1.254:52268    ESTABLISHED     logger
    -  TCP    192.168.1.254:52296    192.168.1.254:52265    ESTABLISHED     dbmgr
    -  TCP    192.168.1.254:52297    192.168.1.254:52263    ESTABLISHED     cellappmgr
    -  TCP    192.168.1.254:52298    192.168.1.254:52264    ESTABLISHED     baseappmgr
    -  TCP    192.168.1.254:52302    192.168.1.254:52266    ESTABLISHED     baseapp
### interfaces
    -  TCP    0.0.0.0:30099          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:33000          0.0.0.0:0              LISTENING       定
    -  TCP    127.0.0.1:30040        0.0.0.0:0              LISTENING       定
    -  TCP    127.0.0.1:30099        127.0.0.1:52269        ESTABLISHED     dbmgr
### machine
    -  TCP    0.0.0.0:20099          0.0.0.0:0              LISTENING       定
    -  TCP    0.0.0.0:52262          0.0.0.0:0              LISTENING       
    -  UDP    0.0.0.0:20086          *:*                                    定
    -  UDP    127.0.0.1:20086        *:*                                    
    -  UDP    192.168.1.254:20086    *:*                                    
### 总计，占用(定)
-  TCP: 20013，20015，20099，30040，30099，31000，32000，33000，34000，40000，50000
-  UDP: 20086