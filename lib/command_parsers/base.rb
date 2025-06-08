module CommandParsers
  class Base
    def self.can_parse?(input)
      raise NotImplementedError
    end

    def self.parse(input)
      raise NotImplementedError
    end
  end
end
