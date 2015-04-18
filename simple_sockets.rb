require 'socket'

class SimpleSockets
  PORT = '2500'

  def initialize(port = PORT)
    @port = port
    @server = TCPServer.open(port)
  end

  def main
    clients = []
    loop do
      Thread.start(server.accept) do |client|
        clients << client
        loop do
          input = client.gets.chomp
          time = Time.now
          clients.each do |c|
            c.puts("#{ time }:  #{ input }") unless c == client
          end
          puts input
          if input.match(/^quit$/)
            client.puts 'Goodbye'
            client.close
            break
          end
        end
      end
    end
  rescue Interrupt => e
    puts "\n Shutting Down"
  ensure
    server.close if server and !server.closed?
  end

  private

  def server; @server; end
end

SimpleSockets.new.main
