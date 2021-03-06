require 'base64'
require 'json'

def test_decode_from_base64()
	s = Base64::decode64("""eyIkb3JpZ2luIjogImRhdGEtZGlhZ25vc3RpY3MiLCAiJHZlcnNpb24iOiAiMSIsICIkY2FyZHMiOiBbeyJ0aXRsZSI6ICJzYW1wbGVfaW1wb3J0ZWRfY2FyZCIsICJpc05ldyI6IHRydWUsICJzY2VuZXMiOiBbeyJsYXllcnMiOiBbeyJzY2FsZSI6IDAuNDMsICJ0b3AiOiAwLCAicm90YXRpb24iOiAwLCAibGVmdCI6IDAsICJ2aXNpYmxlIjogdHJ1ZSwgImltYWdlIjogImJhY2tkcm9wLXJlZCIsICJvcGFjaXR5IjogMSB9IF0sICJjYXB0aW9uIjogIlRoaXMgY2FyZCBpcyB0aGUgcmVzdWx0IG9mIGFuIGltcG9ydCBvcGVyYXRpb24ifSBdIH0gXSB9IA==""")

	cardstore = JSON::parse(s)

	puts(" Decoded Cardstore ".center(80, '-'))
	puts(JSON::pretty_generate(cardstore))
end

def generate_import_card()
	s = '{"$origin": "data-diagnostics", "$version": "1", "$cards": [{"title": "sample_imported_card", "isNew": true, "scenes": [{"layers": [{"scale": 0.43, "top": 0, "rotation": 0, "left": 0, "visible": true, "image": "backdrop-red", "opacity": 1 } ], "caption": "This card is the result of an import operation"} ] } ] }'

	puts(" Encoded Cardstore ".center(80, '-'))
	puts(Base64::encode64(s).gsub(/\n/,''))
end

test_decode_from_base64()
generate_import_card()

