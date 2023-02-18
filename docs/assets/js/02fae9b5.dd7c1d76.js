"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[331],{3905:(e,n,t)=>{t.d(n,{Zo:()=>u,kt:()=>m});var r=t(67294);function a(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function o(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var r=Object.getOwnPropertySymbols(e);n&&(r=r.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,r)}return t}function i(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?o(Object(t),!0).forEach((function(n){a(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):o(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function l(e,n){if(null==e)return{};var t,r,a=function(e,n){if(null==e)return{};var t,r,a={},o=Object.keys(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||(a[t]=e[t]);return a}(e,n);if(Object.getOwnPropertySymbols){var o=Object.getOwnPropertySymbols(e);for(r=0;r<o.length;r++)t=o[r],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(a[t]=e[t])}return a}var c=r.createContext({}),s=function(e){var n=r.useContext(c),t=n;return e&&(t="function"==typeof e?e(n):i(i({},n),e)),t},u=function(e){var n=s(e.components);return r.createElement(c.Provider,{value:n},e.children)},p={inlineCode:"code",wrapper:function(e){var n=e.children;return r.createElement(r.Fragment,{},n)}},d=r.forwardRef((function(e,n){var t=e.components,a=e.mdxType,o=e.originalType,c=e.parentName,u=l(e,["components","mdxType","originalType","parentName"]),d=s(t),m=a,h=d["".concat(c,".").concat(m)]||d[m]||p[m]||o;return t?r.createElement(h,i(i({ref:n},u),{},{components:t})):r.createElement(h,i({ref:n},u))}));function m(e,n){var t=arguments,a=n&&n.mdxType;if("string"==typeof e||a){var o=t.length,i=new Array(o);i[0]=d;var l={};for(var c in n)hasOwnProperty.call(n,c)&&(l[c]=n[c]);l.originalType=e,l.mdxType="string"==typeof e?e:a,i[1]=l;for(var s=2;s<o;s++)i[s]=t[s];return r.createElement.apply(null,i)}return r.createElement.apply(null,t)}d.displayName="MDXCreateElement"},76647:(e,n,t)=>{t.r(n),t.d(n,{contentTitle:()=>i,default:()=>u,frontMatter:()=>o,metadata:()=>l,toc:()=>c});var r=t(87462),a=(t(67294),t(3905));const o={},i="Bee2D",l={type:"mdx",permalink:"/Bee2D/",source:"@site/pages/index.md",title:"Bee2D",description:"Bee2D is a semi-barebones 2D game engine integrated into Roblox. Simply download the repo and run the default.project.json with Rojo to clone it into your game. Additionally, you can add it straight into your game with the model below:",frontMatter:{}},c=[{value:"Actors",id:"actors",level:2},{value:"Transform",id:"transform",level:2}],s={toc:c};function u(e){let{components:n,...t}=e;return(0,a.kt)("wrapper",(0,r.Z)({},s,t,{components:n,mdxType:"MDXLayout"}),(0,a.kt)("h1",{id:"bee2d"},"Bee2D"),(0,a.kt)("p",null,"Bee2D is a semi-barebones 2D game engine integrated into Roblox. Simply download the repo and run the ",(0,a.kt)("inlineCode",{parentName:"p"},"default.project.json")," with Rojo to clone it into your game. Additionally, you can add it straight into your game with the model below:\n",(0,a.kt)("a",{parentName:"p",href:"https://www.roblox.com/library/12159480029/Bee2D"},"https://www.roblox.com/library/12159480029/Bee2D")),(0,a.kt)("p",null,"Discord Server: ",(0,a.kt)("a",{parentName:"p",href:"https://discord.gg/ptNSRYcvr9"},"https://discord.gg/ptNSRYcvr9")),(0,a.kt)("h1",{id:"getting-started"},"Getting Started"),(0,a.kt)("p",null,"Bee2D has a bit of a learning curve, but once you get into it, it's extremely simple. To start out, simply require the ",(0,a.kt)("inlineCode",{parentName:"p"},"Main")," and ",(0,a.kt)("inlineCode",{parentName:"p"},"Engine")," modules from Bee2D like so:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"local Engine = require(Services.ReplicatedStorage.Bee2D.Engine)\nlocal Bee2D = require(Services.ReplicatedStorage.Bee2D.Main)\n")),(0,a.kt)("p",null,"From there, there's a couple of built-in functions you can set up."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'Engine.BindToUpdate("Name", function(deltaTime)\n    -- This will allow you to bind functions to the update calls of the engine. \n    --Engine.Update(deltaTime) runs every frame.\n    -- The first argument, "Name", is what you will use to unbind the function.\nend)\n\nEngine.BindToDraw("Name", function()\n    -- This will allow you to bind functions to the draw calls of the engine.   \n    -- Engine.Draw() runs every frame after Engine.Update() is called.\n    -- The first argument, "Name", is what you will use to unbind the function.\nend)\n')),(0,a.kt)("p",null,"In order to unbind these functions, it's as simple as running the following:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'Engine.UnbindFromUpdate("Name")\nEngine.UnbindFromDraw("Name")\n')),(0,a.kt)("p",null,"This engine runs with modules called ",(0,a.kt)("inlineCode",{parentName:"p"},"Scenes"),". Scenes have their own ",(0,a.kt)("inlineCode",{parentName:"p"},"Start"),", ",(0,a.kt)("inlineCode",{parentName:"p"},"Update"),", and ",(0,a.kt)("inlineCode",{parentName:"p"},"Draw")," functions which are called with the Engine. To set up your scenes, simply make a folder for them and load them with the following:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"Engine.LoadScenes(ScenesFolder)\n")),(0,a.kt)("p",null,"A scene is set up like such:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"-- First you want to include the Scene module, as it sets up the class for you to use.\nlocal Scene = require(ReplicatedStorage.Bee2D.Components.Scene)\n\n-- Then you can set up your Scene like such:\n\nlocal YourSceneName = Scene.new()\nYourSceneName.Prioritize = true -- This will make this scene the current active scene when it is loaded. This means that it will be displayed immediately.\n\nfunction YourSceneName:Start()\n-- This will run once when the scene is loaded.\nend\n\nfunction YourSceneName:Update(deltaTime)\n-- This will run every frame.\nend\n\nfunction YourSceneName:Draw()\n-- This will run every frame after Update, and is used to render images and geometry.\nend\n")),(0,a.kt)("p",null,"Bee2D's Main module also has some neat functions for you to use."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"function Bee2D.DrawFPS()\n-- Displays the FPS on screen in the top right corner.\n\nfunction Bee2D:SetFullScreen(boolean)\n-- Will make the window take up the entire screen.\n\nfunction Bee2D.DrawImage(texture: string, position: Vector2, rotation: number, scale: Vector2, tint: Color3)\n-- Will draw an image on screen given the texture (roblox image link).\n\nfunction Bee2D.DrawRectangle(posX: number, posY: number, width: number, height: number, color: Color3)\n-- Will draw a rectangle on screen given a position, width, and height.\n\nfunction Bee2D.DrawRectangleEx(posX: number, posY: number, width: number, height: number, rotation: number, color: Color3)\n-- Will draw a rectangle on screen same as above, but includes rotation.\n\nfunction Bee2D.DrawText(text: string, posX: number, posY: number, color: Color3, font: Enum.Font, size: number)\n-- Displays text on screen\n\nfunction Bee2D.DrawLine(lineStart: Vector2, lineEnd: Vector2, width: number, color: Color3)\n-- Draws a line on screen given a start and end. May be buggy.\n\nfunction Bee2D.DrawCircleLine(posX: number, posY: number, radius: number, color: Color3)\n-- Draws a circle out of lines.\n")),(0,a.kt)("h2",{id:"actors"},"Actors"),(0,a.kt)("p",null,"Actors are more advanced objects that are displayed in a scene.\nActors also have a Start, Update, and Draw function that can be overriden. These functions are run when you add the actor to a scene like such:"),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},'local Actor = require(ReplicatedStorage.Bee2D.Source.Actor)\nlocal Sprite = require(ReplicatedStorage.Bee2D.Source.Interface.Sprite)\n-- Sprite class is used to display the actor\n\nlocal Player = YourSceneName:AddActor(Actor.new("Player",  Sprite.new(Color3.new(1,1,1), "imagelinkhere")))\n')),(0,a.kt)("p",null,"Additionally, actors can be moved, scaled, and rotated by their Transform properties, and also can be given collision."),(0,a.kt)("pre",null,(0,a.kt)("code",{parentName:"pre",className:"language-lua"},"Player.Transform:SetLocalPosition(Vector2.new(1,1))\n")),(0,a.kt)("p",null,"More information regarding Transforms can be seen below."),(0,a.kt)("h2",{id:"transform"},"Transform"),(0,a.kt)("p",null,"WIP"))}u.isMDXComponent=!0}}]);