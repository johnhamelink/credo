defmodule Credo.Check.Readability.MaxLineLengthTest do
  use Credo.TestHelper

  @described_check Credo.Check.Readability.MaxLineLength

  test "it should NOT report expected code" do
"""
defmodule CredoSampleModule do
  use ExUnit.Case

  def some_fun do
    assert 1 + 1 == 2
  end
end
""" |> to_source_file
    |> refute_issues(@described_check)
  end

  test "it should NOT report expected code if function defintions are excluded" do
"""
defmodule CredoSampleModule do
  use ExUnit.Case

  def some_fun({atom, meta, arguments} = ast, issues, source_file, max_complexity) do
    assert 1 + 1 == 2
  end
end
""" |> to_source_file
    |> refute_issues(@described_check, ignore_definitions: true)
  end

  @tag :to_be_implemented
  test "it should NOT report a violation if strings are excluded" do
"""
defmodule CredoSampleModule do
  use ExUnit.Case

  def some_fun do
    IO.puts 1
    \"\"\"
    long string, right? 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 == 2
    \"\"\"
    IO.puts 2
  end
end
""" |> to_source_file
    |> IO.inspect
    |> refute_issues(@described_check, ignore_multi_line_strings: true)
  end



  test "it should report a violation" do
"""
defmodule CredoSampleModule do
  use ExUnit.Case

  def some_fun do
    assert 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 == 2
  end
end
""" |> to_source_file
    |> assert_issue(@described_check, fn(issue) ->
        assert 81 == issue.column
        assert "2" == issue.trigger
      end)
  end

  test "it should NOT report a violation with config" do
"""
defmodule CredoSampleModule do
  use ExUnit.Case

  def some_fun do
    assert 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 + 1 == 2
  end
end
""" |> to_source_file
    |> refute_issues(@described_check, max_length: 90)
  end

end
