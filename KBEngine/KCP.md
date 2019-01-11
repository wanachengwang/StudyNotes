## NetworkInterface的创建

1. 在KBEngine.initialize/reset时，创建 NetworkInterfaceTCP 类型的_networkInterface

2. 在login_baseapp/reloginBaseapp时，_networkInterface会被reset， 然后根据配置重新创建，connectTo 服务器
    1. _args.forceDisableUDP || baseappUdpPort == 0： 创建 NetworkInterfaceTCP
    2. 否则： 创建 NetworkInterfaceKCP

3. 调用connectTo 来连接服务器，实际调用 onAsynConnect
    1. 对于TCP：
        1. 创建TCP Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp) 
        2. socket.Connect(ip, port)
    2. 对于KCP：
        1. 创建UDP Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp) 
        1. 通过socket SendTo向服务器发送 UDP_HELLO，然后等待服务器的 HelloAck 包（strHelloAck, strVersion, uintConv）
        2. 收到 HelloAck，检查比对ack/ver以及conv不为零
            1. 不匹配，报错
            2. 用conv设置对话Id

## NetworkInterfaceTCP vs NetworkInterfaceKCP

1. Socket: TCP vs UDP
    1. TCP: Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
    2. UDP: Socket(AddressFamily.InterNetwork, SocketType.Dgram, ProtocolType.Udp)
2. PacketReceiverTCP vs PacketReceiverKCP
    1. PacketReceiverTCP：数据通过_asyncReceive接收，放在在receiveBuffer中，修改_wpos+=bytesread
        1. 未加密数据直接使用_messageReader.process
        2. 加密数据，使用_filter解密_networkInterface.fileter().recv）
        3. 数据处理结束，修改_rpos=t_wpos(_wpos的备份)
    2. PacketReceiverKCP：直接使用UDP Socket的receive接收数据，kcp_.Input根据kcp协议解包提取segment数据并分析然后添加到队列，kcp_.Recv把数据传出来，然后：
        1. 未加密数据直接使用_messageReader.process
        2. 加密数据，使用_filter解密_networkInterface.fileter().recv）
3. PacketSenderTCP vs PacketSenderKCP
    1. PacketSenderTCP：socket用的是默认/阻塞式，因此在这里不能直接使用socket.send()方法，使用BeginInvoke另开线程去做_asynsend。
    2. PacketSenderKCP：socket用的是默认/阻塞式；直接使用 UDP 的sendto函数，其实他只是将发生的数据包进行了一次拷贝，拷贝到了传输层的网络缓冲区，然后函数返回结果。所以sendto函数的返回值并不能代表网络真实的一个发送情况结果。既然理解了上面的这个，所以udp的sendto耗时基本可以忽略了。因为数据拷贝基本不占用多大实际时间。但对于阻塞的socket，当网络缓冲区满了以后，sendto就会阻塞。而对于非阻塞的socket，即使网络缓冲区满了，他也会立即返回，不会进行阻塞等待，所以这种情况下适合于流媒体发送数据，即使单线程作战分发也是可以的。
4. Process：
    1. niBase/niTCP中进行valid检查，以及_packetReceiver.process()
    2. niKCP中除以上操作之外，还会每隔一段时间进行kcp_.Update(current)
    3. 执行时机：
        1. 打开多线程：在线程中根据threadUpdateHZ来运行
        2. 未打开多线程：在FixedUpdate中运行，会受到游戏帧率的影响，所以最好打开多线程
5. Send：
    1. niBase/niTCP进行可选的数据加密/_filter，然后使用PacketSenderTCP进行数据发送
    2. niKCP则是在可选的数据加密/_filter之后，调用kcp.send/在kcp的对数据处理后，在kcp的回调outputKCP中使用PacketSenderKCP进行数据发送；UDP 的sendto函数，其实他只是将发生的数据包进行了一次拷贝，拷贝到了传输层的网络缓冲区，然后函数返回结果。所以sendto函数的返回值并不能代表网络真实的一个发送情况结果。既然理解了上面的这个，所以udp的sendto耗时基本可以忽略了。因为数据拷贝基本不占用多大实际时间。但对于阻塞的socket，当网络缓冲区满了以后，sendto就会阻塞。而对于非阻塞的socket，即使网络缓冲区满了，他也会立即返回，不会进行阻塞等待，所以这种情况下适合于流媒体发送数据，即使单线程作战分发也是可以的。

