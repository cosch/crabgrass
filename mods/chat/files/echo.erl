-module(echo).
-export([test/0]).

test() ->
  Cmd = "ruby ejabberd-auth.rb",
  Port = open_port({spawn, Cmd}, [{packet, 4}, nouse_stdio, exit_status, binary]),
  Payload = term_to_binary({array, [<<"blue">>, <<"rainbow">>]}),
  port_command(Port, Payload),
  receive
    {Port, {data, Data}} ->
      {result, Text} = binary_to_term(Data),
      io:format("~p~n", [Text])
  end.
