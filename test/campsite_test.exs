defmodule CampsiteTest do
  use ExUnit.Case
  doctest Campsite

  test "returns hello world" do
    assert {:ok, {{'HTTP/1.1', 200, 'OK'}, _headers, '<!doctype html><h1>Hello World!</h1>'}} =
      :httpc.request('http://localhost:4000/')
  end
end
