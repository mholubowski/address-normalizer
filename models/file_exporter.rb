class FileExporter

  @@instance = FileExporter.new

  def self.instance
    @@instance
  end

  def ping
    "pong"
  end
end
