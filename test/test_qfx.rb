require_relative "test_helper"

require "qfx"

require "bigdecimal"
require "date"

module QFX
  class TestParser < Minitest::Test

    def test_parser
      parser = Parser.new(<<-QFX)
...
<BANKTRANLIST>
...
<STMTTRN>
<TRNTYPE>DEBIT
<DTPOSTED>20180105120000[0:GMT]
<TRNAMT>-3.99
<FITID>2018010524492158004637229897430
<NAME>ULTIWORLD SUB - MINI
</STMTTRN>
<STMTTRN>
<TRNTYPE>DEBIT
<DTPOSTED>20180104120000[0:GMT]
<TRNAMT>-34.95
<FITID>2018010524492158004637208206058
<NAME>SP * SHERPA PEN COVERS
</STMTTRN>
...
</BANKTRANLIST>
...
      QFX

      expected = [
        Transaction.new(
          type: :debit,
          date: Date.new(2018, 1, 5),
          amount: BigDecimal("-3.99"),
          fitid: "2018010524492158004637229897430",
          name: "ULTIWORLD SUB - MINI",
        ),
        Transaction.new(
          type: :debit,
          date: Date.new(2018, 1, 4),
          amount: BigDecimal("-34.95"),
          fitid: "2018010524492158004637208206058",
          name: "SP * SHERPA PEN COVERS",
        ),
      ]
      actual = parser.parse

      assert_equal expected, actual
    end

  end
end
