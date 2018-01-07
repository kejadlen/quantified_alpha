module Ledger

  Comment = Struct.new(:comment) do
    def to_s
      "; #{comment}"
    end
  end

  Transaction = Struct.new(:date, :description, :tags, :postings, keyword_init: true) do
    def to_s
      <<-EOS
#{date.strftime("%Y.%m.%d")} #{description} ; #{tags.map {|k,v| "#{k}: #{v}" }.join(", ")}
#{postings.map(&:to_s).map {|s| "  #{s}" }.join("\n")}
      EOS
    end
  end

  Posting = Struct.new(:account, :amount, keyword_init: true) do
    def to_s
      out = [ account ]
      out << "$%.2f" % amount unless amount.nil?
      out.join("  ")
    end
  end

end
