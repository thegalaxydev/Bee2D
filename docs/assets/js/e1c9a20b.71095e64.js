"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[30],{43852:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Constructor for Scene\\n\\n    @param name string -- Name of the scene\\n\\n    @return Scene -- A new scene object","params":[{"name":"name","desc":"","lua_type":"string"}],"returns":[],"function_type":"static","source":{"line":33,"path":"Bee2D/Source/Scene.luau"}},{"name":"AddActor","desc":"Adds an actor to the scene\\n\\n    @param actor Actor -- Actor to add\\n\\n    @return Actor -- The actor that was added","params":[{"name":"actor","desc":"","lua_type":"Actor"}],"returns":[],"function_type":"method","source":{"line":53,"path":"Bee2D/Source/Scene.luau"}},{"name":"RemoveActor","desc":"Removes an actor from the scene and pops the graphic from the cache.\\n\\n    @param actor Actor -- Actor to remove","params":[{"name":"actor","desc":"","lua_type":"Actor"}],"returns":[],"function_type":"method","source":{"line":65,"path":"Bee2D/Source/Scene.luau"}},{"name":"AddTileMap","desc":"Adds a tilemap to the scene","params":[{"name":"gridScale","desc":"The scale of the grid","lua_type":"number"},{"name":"pos","desc":"The position of the tilemap","lua_type":"number"},{"name":"isometric","desc":"Whether or not the tilemap is isometric","lua_type":"boolean"},{"name":"tilemapData","desc":"","lua_type":"{ {tileTexture : string, tileName: string} } "}],"returns":[{"desc":"The tilemap that was added","lua_type":"TileMap"}],"function_type":"method","source":{"line":86,"path":"Bee2D/Source/Scene.luau"}},{"name":"Start","desc":"Starts the scene and all of its actors. This is called before the first update call.","params":[],"returns":[],"function_type":"method","source":{"line":99,"path":"Bee2D/Source/Scene.luau"}},{"name":"Update","desc":"Updates the scene and all of its actors. This is called every frame.","params":[{"name":"deltaTime","desc":"The time since the last update call","lua_type":"number"}],"returns":[],"function_type":"method","source":{"line":110,"path":"Bee2D/Source/Scene.luau"}},{"name":"Draw","desc":"Draws the scene and all of its actors. This is called every frame.","params":[],"returns":[],"function_type":"method","source":{"line":119,"path":"Bee2D/Source/Scene.luau"}},{"name":"Render","desc":"Renders a graphic to the scene","params":[{"name":"type","desc":"The type of graphic to render","lua_type":"DrawTarget"},{"name":"...","desc":"The arguments for the graphic","lua_type":"any"}],"returns":[{"desc":"The graphic that was rendered","lua_type":"GuiObject"}],"function_type":"method","source":{"line":139,"path":"Bee2D/Source/Scene.luau"}}],"properties":[],"types":[],"name":"Scene","desc":"","source":{"line":8,"path":"Bee2D/Source/Scene.luau"}}')}}]);