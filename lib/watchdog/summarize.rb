module Watchdog
  def self.summarize(message)
    lines = message.split("\n")
    if lines.size >= 20
      lines[5...-5] = "..."
      lines.join("\n")
    else
      message
    end
  end
end
