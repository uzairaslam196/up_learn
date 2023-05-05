defmodule UpLearn.CrawlerTest do
  use ExUnit.Case

  alias __MODULE__.AssetAndLinkHtml
  alias UpLearn.Crawler
  alias UpLearn.Request
  import Mox

  setup :verify_on_exit!

  describe "fetch/1 returns" do
    @url "https://dummy"
    test "map with one link & asset" do
      Request.Mock
      |> expect(:get, fn _, _ ->
        {:ok, %{body: AssetAndLinkHtml.with_one, status_code: 200}}
      end)

      assert %{assets: ["image1.jpg"], links: ["https://example.com"]} = Crawler.fetch(@url)
    end

    test "map with some links & assets" do
      Request.Mock
      |> expect(:get, fn _, _ ->
        {:ok, %{body: AssetAndLinkHtml.with_some, status_code: 200}}
      end)

      assert %{assets: assets, links: links} = Crawler.fetch(@url)
      assert ["image1.jpg", "image2.jpg"] = assets
      assert ["https://example.com"] = links
    end

    test "map with zero link & asset" do
      Request.Mock
      |> expect(:get, fn _, _ ->
        {:ok, %{body: AssetAndLinkHtml.with_zero, status_code: 200}}
      end)

      assert %{assets: [], links: []} = Crawler.fetch(@url)
    end

    test "error tuple when status code isn't 200" do
      Request.Mock
      |> expect(:get, fn _, _ ->
        {:error, %{body: "", status_code: 301}}
      end)

      assert {:error, %{body: "", status_code: 301}} = Crawler.fetch(@url)
    end
  end

  defmodule AssetAndLinkHtml do
    def with_one do
      """
      <html>
        <head>
          <title>Test Page</title>
        </head>
        <body>
          <div>Test Content</div>
          <img src="image1.jpg" />
          <a href="https://example.com">Example</a>
        </body>
      </html>
      """
    end

    def with_some do
      """
      <html>
        <head>
          <title>Test Page</title>
        </head>
        <body>
          <div>Test Content</div>
          <img src="image1.jpg" />
          <img src="image2.jpg" />
          <a href="https://example.com">Example</a>
        </body>
      </html>
      """
    end

    def with_zero do
      """
      <html>
        <head>
          <title>Test Page</title>
        </head>
        <body>
          <div>Test Content</div>
        </body>
      </html>
      """
    end
  end
end
