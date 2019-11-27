defmodule SecpExTest do
  use ExUnit.Case

  @message_delimiter ":"

  test "libsecp256k1 should be working" do
    assert {28,
            38_938_543_279_057_362_855_969_661_240_129_897_219_713_373_336_787_331_739_561_340_553_100_525_404_231,
            23_772_455_091_703_794_797_226_342_343_520_955_590_158_385_983_376_086_035_257_995_824_653_222_457_926} ==
             Blockchain.Transaction.Signature.sign_hash(<<2::256>>, <<1::256>>)

    assert Blockchain.Transaction.Signature.sign_hash(<<5::256>>, <<1::256>>) ==
             {27,
              74_927_840_775_756_275_467_012_999_236_208_995_857_356_645_681_540_064_312_847_180_029_125_478_834_483,
              56_037_731_387_691_402_801_139_111_075_060_162_264_934_372_456_622_294_904_359_821_823_785_637_523_849}

    data =
      "ec098504a817c800825208943535353535353535353535353535353535353535880de0b6b3a764000080018080"
      |> BitHelper.from_hex()

    hash = data |> ExthCrypto.Hash.Keccak.kec()

    private_key =
      "4646464646464646464646464646464646464646464646464646464646464646" |> BitHelper.from_hex()

    assert Blockchain.Transaction.Signature.sign_hash(hash, private_key, 1) ==
             {37,
              18_515_461_264_373_351_373_200_002_665_853_028_612_451_056_578_545_711_640_558_177_340_181_847_433_846,
              46_948_507_304_638_947_509_940_763_649_030_358_759_909_902_576_025_900_602_547_168_820_602_576_006_531}
  end

  test "[rohit] another test added (based on Tracker entry)" do
    tx = %Blockchain.Transaction{
      data:
        <<179, 3, 41, 229, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 179, 53, 255, 136, 3, 164, 103, 7,
          93, 217, 205, 66, 182, 90, 120, 117, 249, 44, 100, 27, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
          0, 200, 223, 206, 197, 58, 177, 16, 42, 56, 232, 249, 107, 232, 235, 163, 127, 197, 52,
          12, 153>>,
      to:
        <<232, 62, 170, 97, 52, 171, 203, 136, 110, 250, 77, 66, 77, 9, 124, 40, 223, 205, 199,
          36>>,
      init: <<>>,
      value: 0,
      gas_limit: 200_000,
      gas_price: 10_000_000_000,
      nonce: 0
    }

    signed_tx =
      tx
      |> Blockchain.Transaction.Signature.sign_transaction(
        <<199, 171, 134, 109, 45, 46, 96, 10, 173, 26, 83, 16, 204, 12, 122, 193, 107, 202, 85,
          52, 47, 249, 139, 54, 87, 20, 177, 63, 254, 246, 202, 30>>
      )

    assert %{
             r:
               68_262_044_552_050_674_873_339_673_713_038_097_488_344_450_144_808_287_139_785_852_188_390_132_866_620,
             s:
               7_306_457_232_770_890_327_263_144_714_213_405_523_838_282_987_408_813_007_616_809_448_749_158_333_547,
             v: 27
           } == Map.take(signed_tx, [:r, :s, :v])
  end

  test "signing test" do
    [
      [
        signer_index: 1,
        eth_address: "0x2b5ad5c4795c026514f8317c7a215e218dccd6cf",
        kyc_tier: 1,
        kyc_expiry: 112_233,
        block_number: 123,
        price: 321,
        signer: "0xb4a2657afd18261e8b5a8a5cdc9a7fb91341e5d6",
        payload: ":2b5ad5c4795c026514f8317c7a215e218dccd6cf:1:112233:123:321",
        signature:
          "0x56463490b94810d35b4f28a2c0a96bcf3d6dae21de05a41508c461a01c0239ee08c8d31589a66068281bae3899624e620b4bed13030b320127d3c145bdb9eab300"
      ],
      [
        signer_index: 2,
        eth_address: "0x1eff47bc3a10a45d4b230b5d10e37751fe6aa718",
        kyc_tier: 2,
        kyc_expiry: 223_344,
        block_number: 756_432,
        price: 41_241_513_655_135,
        signer: "0xf2336ba620d48f4b43c777bd50df198a1e6f7be9",
        payload: ":1eff47bc3a10a45d4b230b5d10e37751fe6aa718:2:223344:756432:41241513655135",
        signature:
          "0x221679992ac8993e10e0e94b5261e36318c83f1a8db662a53ae939e8c372f0a9119594280449081cf5cfacb653f8029b1e455d7bff56a9e6d1298f591efe107c01"
      ],
      [
        signer_index: 3,
        eth_address: "0xe57bfe9f44b819898f47bf37e5af72a0783e1141",
        kyc_tier: 2,
        kyc_expiry: 1_574_240_718,
        block_number: 756_432,
        price: 41_241_513_655_135,
        signer: "0x91968130ae7eef1803ed3f308fc0645b98947f35",
        payload: ":e57bfe9f44b819898f47bf37e5af72a0783e1141:2:1574240718:756432:41241513655135",
        signature:
          "0xad544afc1a99776b25066f464eab460845a92bac2343919bdcfbdc853df908aa394d4ff41b0d868e55159458cb75abc7dd7a0abf83bce2c021618d49b15b68f301"
      ],
      [
        signer_index: 21,
        eth_address: "0x1738F5096C767a71171b9204D5dc341BD4eD9AD3",
        kyc_tier: 1,
        kyc_expiry: 1_563_753_000,
        block_number: 204,
        price: 255_633_200_000_001,
        signer: "0x8BE713B2216F45Fed3cB95Ea8bf1B46f6b2e7D38",
        payload: ":1738f5096c767a71171b9204d5dc341bd4ed9ad3:1:1563753000:204:255633200000001",
        signature:
          "0x69c6897fd3f1d03af89e5021427f024b6b2eecec7a5e41cff0a05dc4fa21af925a05aa66ac3b2c1af8f5f36e88d422b97b26767a74938de27c4e45f8acee9c9800"
      ],
      [
        signer_index: 22,
        eth_address: "0xdf5004A660840d13a1773bf1320F037dE4B86ed5",
        kyc_tier: 2,
        kyc_expiry: 1_674_864_000,
        block_number: 193,
        price: 356_744_300_000_000,
        signer: "0x3db7d8e8bea7441cffc93bc6cb82b3f2f7b45c45",
        payload: ":df5004a660840d13a1773bf1320f037de4b86ed5:2:1674864000:193:356744300000000",
        signature:
          "0x200d420917fe0b784697e3f4710c1f5f0f2647c8f3905c39305fcb912f4de3ec5b2a6c6e3ee911d31b27463b0edab34f85085715e2ddb37d78c583dbb493185f01"
      ]
    ]
    |> Enum.each(fn opts ->
      index = Keyword.fetch!(opts, :signer_index)
      signer = Keyword.fetch!(opts, :signer)
      signature = Keyword.fetch!(opts, :signature)
      payload = pricefeed_payload(opts)

      assert ^payload = Keyword.fetch!(opts, :payload)
      assert {:ok, [_, ^signer]} = Signer.fetch_by_index(index)
      assert {:ok, [^signature, _]} = Signer.sign_message(index, payload)
    end)
  end

  defp pricefeed_payload(opts \\ []) do
    signer_index = Keyword.fetch!(opts, :signer_index)
    "0x" <> address = Keyword.fetch!(opts, :eth_address)
    kyc_tier = Keyword.fetch!(opts, :kyc_tier)
    kyc_expiry = Keyword.fetch!(opts, :kyc_expiry)
    block_number = Keyword.fetch!(opts, :block_number)
    price = Keyword.fetch!(opts, :price)

    [
      "",
      String.downcase(address),
      kyc_tier,
      kyc_expiry,
      block_number,
      price
    ]
    |> Enum.intersperse(@message_delimiter)
    |> Enum.join("")
  end
end
