require "socket"
require 'timeout'
gs = TCPServer.open(2000)
addr = gs.addr
addr.shift
printf("server is on %s\n", addr.join(":"))

while true
  Thread.start(gs.accept) do |s|
    sock_domain, remote_port, remote_hostname, remote_ip = s.peeraddr
    print(remote_ip + " Host->" + remote_hostname + " is accepted\n")


    host_thread = Thread.new do
      while host_get = gets
        begin
          if host_get.chomp == "bye"
            #プロセスを強制終了しつつ，コネクト終了
            remote_thread.exit
            break
          end
          s.write(host_get)
        rescue
          break
        end
      end
    end

    #相手から通知
    remote_thread = Thread.new do
      while remote_get = s.gets
        printf(response = remote_get)
      end
    end



    #終了待ち
    host_thread.join
    print(remote_ip, " is gone\n")
    s.close
  end
end