Utility to make Skin Packs for Minecraft.

Please read "README.md" as a file, not preview, for better experience.
In files remove >'< so it may work.

Take for an example the "example" folder.
For your own .mcpack Skin Pack file, you would need in the Skin Pack folder:

1. "manifest.json" with
'
{
	"format_version":1,
	"header":{
		"name":"%SkinPackName%,
		"uuid":"LongUUIDForHeader-TryToGetIt",
		"version":[1,0,0]
	},
	"modules":[{
	"type":"skin_pack",
	"uuid":"LongUUIDForModules-TryToGetIt",
	"version:[1,0,0]
	}]
}
'

2. "skins.json" with:
'
{
	"skins":[{
	
	"localization_name":"%SkinName%",
	"geometry":"geometry.%SkinPackName%.%SkinName%",
	"texture":"%SkinFileName%.png",
	"type":"free"}],
	
	"serialize_name":"%SkinPackName%",
	"localization_name":"%SkinPackName%"
}
'
	
3. "en_US.lang" in "texts" folder with:
'
skinpack.%SkinPackName%=%SkinPackName%
	
	skin.%SkinPackName%.%SkinGeometryFrom-skins.json-without-geometry.%=%SkinName%
'

To generate UUIDs you can use "UUIDs-Generator.bat".
Better change UUIDs with every update.
