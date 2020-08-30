import conduit
import gleam/should
import gleam/http
import gleam/bit_builder
import gleam/bit_string
import gleam/option
import gleam/string

pub fn hello_world_test() {
  let request =
    http.default_req()
    |> http.set_req_body(<<>>)

  let response =
    request
    |> conduit.service()

  response.status
  |> should.equal(200)

  assert Ok(response_body) =
    response.body
    |> bit_builder.to_bit_string()
    |> bit_string.to_string()
  response_body
  |> should.equal("Hello, from conduit!")
}

pub fn invalid_encoding_request_test() {
  let request =
    http.default_req()
    |> http.set_req_body(<<0xF5>>)

  let response =
    request
    |> conduit.service()

  response.status
  |> should.equal(500)

  assert Ok(response_body) =
    response.body
    |> bit_builder.to_bit_string()
    |> bit_string.to_string()
  response_body
  |> string.starts_with("Could not read the request body")
  |> should.be_true()
}
