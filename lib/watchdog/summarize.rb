module Watchdog
  def self.summarize(message)
    lines = message.split("\n")
    lines[5...-5] = "..."
    lines.join("\n")
  end
end
