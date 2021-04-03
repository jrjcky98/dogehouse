defmodule BrothTest.Message.Room.JoinTest do
  use ExUnit.Case, async: true

  alias Broth.Message.Room.Join

  setup do
    {:ok, uuid: UUID.uuid4()}
  end

  describe "when you send a join message" do
    test "it populates roomId", %{uuid: uuid} do
      assert {:ok,
              %{
                payload: %Join{roomId: ^uuid}
              }} =
               Broth.Message.validate(%{
                 "operator" => "room:join",
                 "payload" => %{"roomId" => uuid},
                 "reference" => UUID.uuid4()
               })

      # short form also allowed
      assert {:ok,
              %{
                payload: %Join{roomId: ^uuid}
              }} =
               Broth.Message.validate(%{
                 "op" => "room:join",
                 "p" => %{"roomId" => uuid},
                 "ref" => UUID.uuid4()
               })
    end

    test "omitting the reference is not allowed", %{uuid: uuid} do
      assert {:error, %{errors: [reference: {"is required for Broth.Message.Room.Join", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "room:join",
                 "payload" => %{"roomId" => uuid}
               })
    end

    test "omitting the roomId is not allowed", %{uuid: uuid} do
      assert {:error, %{errors: [roomId: {"can't be blank", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "room:join",
                 "payload" => %{},
                 "reference" => UUID.uuid4()
               })
    end

    test "roomId must be a UUID", %{uuid: uuid} do
      assert {:error, %{errors: [roomId: {"is invalid", _}]}} =
               Broth.Message.validate(%{
                 "operator" => "room:join",
                 "payload" => %{"roomId" => "aaa"},
                 "reference" => UUID.uuid4()
               })
    end
  end
end
