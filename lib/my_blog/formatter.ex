defmodule MyBlog.Formatter do
  @months %{
    1 => "January",
    2 => "february",
    3 => "March",
    4 => "April",
    5 => "May",
    6 => "June",
    7 => "July",
    8 => "August",
    9 => "September",
    10 => "October",
    11 => "November",
    12 => "December"
  }

  def format_date(date) do
    {{year, month, day}, _} = NaiveDateTime.to_erl(date)
    "#{day} #{@months[month]} #{year}"
  end
end
