module StaticMatic::ServerMixin
  def preview
    puts "StaticMatic Preview Server Starting..."
    StaticMatic::Server.start(self)
  end
end