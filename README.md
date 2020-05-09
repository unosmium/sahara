# Sahara

Super-simple API for converting [SciolyFF](https://github.com/unosmium/sciolyff)
files to HTML.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

Create your own instance on Heroku for free using the button above, or [preview
one here](https://intense-shore-26633.herokuapp.com/).

## Usage

Send a POST request to `<your heroku url>/api` with the content of a SciolyFF
file in the body. The following optional parameters are supported:

- `?type={html,json}`

  Change the response type. The JSON contains either the HTML or messages
  indicating why the SciolyFF input is not valid.

- `?hide_raw={true,false}`

  Replace the raw results in the input with just places in the SciolyFF file
  embeded in the generated HTML.

- `?color={hex color}`

  Changes the color of the background header in the generated HTML results.

## Example

`<your heroku url>/api?type=html&hide_raw=false&color=%23C92424`

Alternatively, open `<your heroku url>/` in a browser to experiment with
SciolyFF in a playground, and view the page source to see an example of calling
the API using Javascript.
