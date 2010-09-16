module StaticMatic::ServerMixin
  def preview
    puts "StaticMatic Preview Server"
    puts "Ctrl+C to exit"
    StaticMatic::Server.start(self)
  end
end