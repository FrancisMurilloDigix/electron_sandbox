defmodule Signer do
  @moduledoc nil

  alias BitHelper
  alias ExthCrypto

  @message_prefix "\x19Ethereum Signed Message:\n"

  @spec fetch_by_index(integer) :: {:ok, [charlist()]}
  def fetch_by_index(index) do
    case index do
      1 ->
        {:ok,
         [
           "5fe851c1fe54ad81b73c30a0a03c9e03737d5d850b7483f1a890f846fe26dd27",
           "0xb4a2657afd18261e8b5a8a5cdc9a7fb91341e5d6"
         ]}

      2 ->
        {:ok,
         [
           "fd28dbab6e80a63686882a61d27c9aeaa9d649ba71157112a5914f20d0a764c4",
           "0xf2336ba620d48f4b43c777bd50df198a1e6f7be9"
         ]}

      3 ->
        {:ok,
         [
           "8f8344707fc55ccf10ca8ade47926d1d02f924196cf6ea485e32a1a9cebf8f71",
           "0x91968130ae7eef1803ed3f308fc0645b98947f35"
         ]}

      21 ->
        {:ok,
         [
           "508be6ea9c00a01fb3280f5df8ed45bff68c647f80fd0a758f7d4a65126dc15a",
           "0x8BE713B2216F45Fed3cB95Ea8bf1B46f6b2e7D38"
         ]}

      22 ->
        {:ok,
         [
           "710779bc149afc6f5ffd888fe37914f4466a1d797688e742860c9e1b8644e793",
           "0x3db7d8e8bea7441cffc93bc6cb82b3f2f7b45c45"
         ]}
    end
  end

  @spec sign_message(integer, charlist()) :: {:ok, [charlist()]} | {:error, any()}
  def sign_message(signer_index, message) do
    with {:ok, [private_hex, public_address]} <- fetch_by_index(signer_index),
         {:ok, pk} <- Base.decode16(private_hex, case: :mixed) do
      payload = "#{@message_prefix}#{String.length(message)}#{message}"

      {sig, r, s, v} =
        payload
        |> ExthCrypto.Hash.Keccak.kec()
        |> ExthCrypto.Signature.sign_digest(pk)

      [{r, 32}, {s, 32}, {v, 1}]
      |> Enum.reverse()
      |> Enum.map(fn {binary, padding} ->
        BitHelper.pad(:binary.encode_unsigned(binary), padding)
      end)
      |> Enum.reduce(&Kernel.<>/2)
      |> Base.encode16(case: :lower)
      |> (&{:ok, ["0x#{&1}", public_address]}).()
    else
      :error -> {:error, :private_hex_invalid}
      error -> error
    end
  end

  defp secret_mnemonic() do
    "cry segment blue hello bid rain sheriff educate couple random office heavy credit borrow sugar shrimp cousin creek boil heavy edit credit shaft arrow couple right boat idea fashion rack screen equip grace crack army gather green radar occur change debris canvas flip silent chaos rack talk holiday give climb success give drip cost lumber almost cry situate assist second credit box sheriff proud cube book sudden gather globe october thunder erosion cry reason off skull casino radar office chase coral loan mirror security chaos broken sugar charge cushion canyon assist general crime grape three cry"
  end
end
