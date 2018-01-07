require "bigdecimal"
require "date"
require "strscan"

module QFX
  Transaction = Struct.new(:type, :date, :amount, :fitid, :name, keyword_init: true)

  class Parser
    def initialize(raw)
      @ss = StringScanner.new(raw.gsub("\r", ""))
    end

    def parse
      until @ss.eos?
        case
        when @ss.scan(/<BANKTRANLIST>\n/)
          return parse_transaction_list
        else
          @ss.skip_until(/\n/)
        end
      end
    end

    private

    def parse_transaction_list
      transactions = []
      transaction = {}
      until @ss.eos? || @ss.scan(/<\/BANKTRANLIST>\n/)
        case
        when @ss.scan(/<STMTTRN>\n/)
          transaction = {}
        when @ss.scan(/<TRNTYPE>((?~\n))\n/)
          transaction[:type] = @ss[1].downcase.to_sym
        when @ss.scan(/<DTPOSTED>((?~\n))\[(?~\])\]\n/)
          transaction[:date] = Date.parse(@ss[1])
        when @ss.scan(/<TRNAMT>((?~\n))\n/)
          transaction[:amount] = BigDecimal(@ss[1])
        when @ss.scan(/<FITID>((?~\n))\n/)
          transaction[:fitid] = @ss[1]
        when @ss.scan(/<NAME>((?~\n))\n/)
          transaction[:name] = @ss[1]
        when @ss.scan(/<\/STMTTRN>\n/)
          transactions << Transaction.new(transaction)
        else
          @ss.skip_until(/\n/)
        end
      end
      transactions
    end
  end
end
