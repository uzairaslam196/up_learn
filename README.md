# UpLearn

This is simle elixir project assuming we are going to integrate it in a Web App later. That's why i didn't create phoenix application and use simple mix project to run specific part of code.

I created new mix applicaion with name up_learn, 

<b>Added following dependencies</b>

1- Floki (it's used to parse html document and find html tags)

2- httpoison (it's used to send http request, there are many libraries for this usage like `tesla` and we can also use `crawler` which specially used for scrapping purpose. However I used httppoison for simplicity)

3- mock (it is used only in test env to create mock for external apis. In test cases we don't want to call external api
instead we create a mock of same APIs and expect similar response.
Lets say when we call fetch method, it send http request to fetch html page and then find elements in it, 
when using same method in test case it will use mock API to get our custom page and then will find all the elements in it)

<b>In project:</b>

1- Added new module `UpLearn.Crawler` at `lib/up_learn/crawler.ex`
This module has fetch/1 method that accepts a string arg, function clause will fail if arg is not string because of pattern matching, this make sure to take input only string. This makes debugging easy.

2- Wrote request adapter in separate module, and make it a behaviour so that we can use that behaviour to mock it in test cases.

3- In `test/test_helper.exs` file, I used `Mox.defmock(UpLearn.Request.Mock, for: UpLearn.Adapter.Request)` to create mock with name `UpLearn.Request.Mock` for `UpLearn.Adapter.Request`.

4- Added different config files for dev, test, & prod environments. Added adapter configuration in these files to pick adapter according to environment. For dev/prod it picks `HTTPoison` to send http requests and in test env it picks UpLearn.Request.Mock.

5- Added test cases with different scenarios in this file `test/uplearn/crawler_test.exs`

# To setup project and start server

- mix deps.get
- iex -S mix

Now we can use `UpLearn.Crawler` to call metod from iex session.
This module provides functionality to fetch the HTML content of a web page and extract information about the assets and links present in the page.

**Examples**

  ```
  iex> UpLearn.Crawler.fetch("https://www.example.com")
  %{
    assets: ["/images/logo.png"],
    links: ["https://www.example.com", "https://www.example.com/about"]
  }

  iex> UpLearn.Crawler.fetch("invalid_url")
  {:error, reason}
  ```
  
**Attributes**

The fetch/1 function returns a map with the following attributes:

<assets> - a list of URLs of the images present in the page, as specified in the src
attribute of the img elements.

<links> - a list of URLs of the links present in the page, as specified in the href
attribute of the a elements.

**Notes**

- This module uses the Floki library to parse and traverse the HTML content of the page.

- If the HTTP request to the specified URL fails or if the HTML content of the page is
invalid, the fetch/1 function returns an {:error, reason} tuple.

- Make find_attributes/2 a separate function for extracting specific data from html page to reuse it in both scenarions.


# Test Cases

You can find all test cases in `test/uplearn/crawler_test.exs`, to run test cases, follow this command in terminal
- mix test

It will run all 4 test cases with different scenarios.

# Upcoming Plans: (Important!)

1- We will add test `ExCoveralls` for test coverage that will track the wheather the code which is being tested in test cases or not.
2- We will also add `Credo` package to maintain code quality. Credo gives information about code refactoring, warnings in codebase.
3- We will use CI/CD to continuous deployments. For CI we can use github actions to perform all steps. It will also run all test cases, will check test coverage and warnings in code base when generating any PR.

