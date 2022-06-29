### A Pluto.jl notebook ###
# v0.19.9

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ e5369ccf-34f5-46c8-88b8-72c5320743cd
begin
	using Colors, ColorVectorSpace, ImageShow, FileIO, ImageIO
	using PlutoUI
	using HypertextLiteral
	using JSON
	using Plots
	using InteractiveUtils

end

# ╔═╡ 36c9a925-d302-4630-a897-cec14e327e9f
html"<button onclick='present()'>present</button>"

# ╔═╡ 12230364-811f-4fda-a026-e33cf06ff1a7
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ 7a3885f1-f97e-47e4-9e97-8fecad703733
details(md"""
#### title
hidden title
    ""","test")

# ╔═╡ e5d00386-2872-4029-b29e-03ef271c6f26
details(md"""
	```htmlmixed
	<script type="module" id="asdf">
		//await new Promise(r => setTimeout(r, 1000))

		const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

		const node = this ?? document.createElement("div")

		const new_state = $(json(state))

		if(this == null){

			// PREACT APP STARTS HERE

			const Item = ({value}) => {
				const [loading, set_loading] = useState(true)

				useEffect(() => {
					set_loading(true)

					const handle = setTimeout(() => {
						set_loading(false)
					}, 1000)

					return () => clearTimeout(handle)
				}, [value])

				return html`<li>\${loading ? 
					html`<em>Loading...</em>` : 
					value
				}</li>`
			}

			const App = () => {

				const [state, set_state] = useState(new_state)
				node.set_app_state = set_state

				return html`<h5>Hello world!</h5>
					<ul>\${
					state.x.map((x,i) => html`<\${Item} value=\${x} key=\${i}/>`)
				}</ul>`;
			}

			// PREACT APP ENDS HERE

			render(html`<\${App}/>`, node);

		} else {

			node.set_app_state(new_state)
		}
		return node
	</script>
	```
	""", "Show with syntax highlighting")

# ╔═╡ fb754a60-e746-4c1a-91bc-6d91619ef36f


# ╔═╡ a9be9eb0-f073-11ec-3802-9d7ec98ae107
PlutoUI.TableOfContents(aside=true)

# ╔═╡ 44fdda29-cf15-4b19-b40f-f9d37cb67eb8
#https://www.tutorialspoint.com/html/index.htm


# ╔═╡ 4041c29c-0afc-410d-b0f9-3d886a31308c
md"""
# HTML
https://htmlcheatsheet.com/
## HTML - Overview
"""

# ╔═╡ d90f2fae-d9bb-497c-a168-b676e16308da
#html"""
@htl """
   <head>
      <title>This is document title</title>
   </head>
	
   <body>
      <h4>This is a heading</h4>
      <p>Document content goes here.....</p>
   </body>
"""

# ╔═╡ 709b24a4-9df2-4685-a5c2-b8b74f7b27da
md"""
## HTML-Basic tag
"""

# ╔═╡ 05374086-62c1-4ee6-9d68-15f04d18a22f
#html"""
@htl """
   <head>
      <title>Heading Example</title>
   </head>
	
   <body>
     <!-- comment tag
      <h2>This is heading 2</h2>
      <h3>This is heading 3</h3>
      -->
      <h4>This is heading 4</h4>
      <h5>This is heading 5</h5>
      <h6>This is heading 6</h6>

 	  <p>Here is a first paragraph of text.</p>
      <p>Here is a second paragraph of text.</p>
      <p>Here is a third paragraph of text.</p>

		<p>Hello<br />
         br tag to go to next line.<br />
         new line</p>

	  <center>
         <p>This text is in the center.</p>
      </center>

 	  <p>This is paragraph one and should be on top</p>
      <hr />

      <p>This is paragraph two and should be at bottom</p>

	  <pre>
         preserve formating:
         function testFunction( strText ){
            alert (strText)
         }
      </pre>

    <p> non breaking space : An example of this technique appears in the movie "12&nbsp;Angry&nbsp;Men."</p>

   </body>
	
"""

# ╔═╡ 243d9f26-4965-40de-a939-372aeb439d3d
md"""
## HTML - Elements and formating
"""

# ╔═╡ e88df846-ac26-4982-b260-1eb5e7f72301


# ╔═╡ 092fa136-86a0-45aa-be76-f3b6bac1392d
#html"""
@htl """
       <p><i>italic display</i> and this is <u>underlined</u> now  <b>bold</b> and <strike>strikethrough</strike> and <sup>superscript</sup>  and <tt>monospaced</tt>  and <sub>subscript</sub> and <del>cola</del> <ins>wine</ins>. Now <big>big</big> and <small>small</small> and <em>emphasized</em>. <mark>marked</mark>,<strong>strong</strong> <abbr title = "Abhishek">Abhy</abbr> </p>

<p>Regular text. <code>This is code.</code> Regular text.</p>
 <p><code>document.write("<var>user-name</var>")</code></p><p>Result produced by the program is <samp>Hello World!</samp></p>

 <p>Regular text. <kbd>This is inside kbd element</kbd> Regular text.</p>
<address>388A, Road No 22, Jubilee Hills -  Hyderabad</address>

"""

# ╔═╡ 28718f27-689e-4817-9813-040a145fa1dc
md"""
## HTML - Attributes
"""

# ╔═╡ e8840978-cc0c-40b9-9db8-15b0b12ce2b6
html"""
<!--   @htl  not operating --> 
      <p align = "left">This is left aligned</p> 
      <p align = "center">This is center aligned</p> 
      <p align = "right">This is right aligned</p> 
      <h4 title = "Hello HTML!">Titled Heading Tag Example</h4>
      <p style = "font-family:arial; color:#FF0000;">Some text...</p>
      <br>
      <div id = "menu" align = "middle" >
         <a href = "/index.htm">HOME</a> | 
         <a href = "/about/contact_us.htm">CONTACT</a> | 
         <a href = "/about/index.htm">ABOUT</a>
      </div>

      <div id = "content" align = "left" >
         <h5>Content Articles</h5>
         <p>Actual content goes here.....</p>
      </div>

      <p>This is the example of <span style = "color:green"><b>span tag</b></span>
         and the <span style = "color:red">div tag</span> alongwith CSS.  <cite>W3 Standard for HTML</cite></p>

<blockquote>XHTML 1.0 is the W3C's first Recommendation for XHTML,following on 
         from earlier work on HTML 4.01, HTML 4.0, HTML 3.2 and HTML 2.0.</blockquote>

<head>
      <title>Meta Tags Example</title>
      <meta name = "keywords" content = "HTML, Meta Tags, Metadata" />
      <meta name = "description" content = "Learning about Meta Tags." />
   </head>

	By default, Web servers and Web browsers use ISO-8859-1 (Latin1) encoding to process Web pages. Following is an example to set UTF-8 encoding
<p>Hello 
<meta http-equiv = "Content-Type" content = "text/html; charset = UTF-8" />

<br>
Hello UTF-8 encoding  <!-- not different ? --></p>
 < !--   This is not a valid comment -->
      <p>Document content goes here.....</p>

   <head>
      <title>Commenting Style Sheets</title>  
      <style>
         <!--
            .example {
               border:1px solid #4a7d49;
            }
         //-->
      </style>
   </head>
   <body>
      <div class = "example">Hello , World!</div>
   </body>
"""

# ╔═╡ c9fa03fc-295e-485c-a7e9-e53ec069ef20
md"""
## HTML-Image insert
"""

# ╔═╡ fe8a09ce-f38c-4189-a3e8-6dfdbf171dff
#html"""
@htl """
 <p>Simple Image Insert</p>
      <img src = "https://www.referenseo.com/wp-content/uploads/2019/03/image-attractive-960x540.jpg" alt = "Test Image" width = "240" height = "124"  border = "5" align = "left"/>
"""

# ╔═╡ 78526e74-1d59-43ba-a9ea-6db08f441fb0
md""" 
## HTML tables
"""

# ╔═╡ b4e04ab6-0338-4a41-9e7e-c5377ee29561
html"""
<head>
      <title>HTML Tables</title>
   </head>
	
   <body>
      <table border = "1">
         <tr>
            <td>Row 1, Column 1</td>
            <td>Row 1, Column 2</td>
         </tr>
         
         <tr>
            <td>Row 2, Column 1</td>
            <td>Row 2, Column 2</td>
         </tr>
      </table>


"""

# ╔═╡ 94b683b0-23f8-4a63-9362-7dff29814ba5
md"""
    
  |4 blanks before| markdown table| v |
  | :----- | -----:| :----:|
  | Row 1 , Column 1 done in markdown |Row 1, Column 2 | tesy |
  |Row 2 , Column 1 |Row 2, Column 2 ppppppppppppppp |  |
  
  """

# ╔═╡ 163ef32a-3cf8-498a-b006-a60f5a0c04c9
html"""
<table border = "1">
         <tr>
            <th>Name</th>
            <th>Salary</th>
         </tr>
         <tr>
            <td>Ramesh Raman</td>
            <td>5000</td>
         </tr>
         
         <tr>
            <td>Shabbir Hussein</td>
            <td>7000</td>
         </tr>
      </table>
"""

# ╔═╡ a8572e86-4605-4995-b023-9a12df9821e0
md"""   

    |4 blanks before including last triple quote| markdown table|
    | :-----: | -----:|
    |Ramesh Raman | 5000 |
    |Shabbir Hussein |7000 |
    
    """

# ╔═╡ ca0d2f5f-2ecf-4e6e-9ee9-33959b1b5131
html"""

      <table border = "1">
         <tr>
            <th>Column 1</th>
            <th>Column 2</th>
            <th>Column 3</th>
         </tr>
         <tr>
            <td rowspan = "2">Row 1 Cell 1</td>
            <td>Row 1 Cell 2</td>
            <td>Row 1 Cell 3</td>
         </tr>
         <tr>
            <td>Row 2 Cell 2</td>
            <td>Row 2 Cell 3</td>
         </tr>
         <tr>
            <td colspan = "3" align = "center">Row 3 Cell 1</td>
         </tr>
      </table>
"""

# ╔═╡ a6f91b84-bc93-40de-b0e8-8c92ce9fc204
html"""
<table border = "1" bordercolor = "green" background = "https://images.assetsdelivery.com/compings_v2/mblach/mblach1609/mblach160900065.jpg">
         <tr>
            <th>Column 1</th>
            <th>Column 2</th>
            <th>Column 3</th>
         </tr>
         <tr>
            <td rowspan = "2">Row 1 Cell 1</td>
            <td>Row 1 Cell 2</td><td>Row 1 Cell 3</td>
         </tr>
         <tr>
            <td>Row 2 Cell 2</td>
            <td>Row 2 Cell 3</td>
         </tr>
         <tr>
            <td colspan = "3">Row 3 Cell 1</td>
         </tr>
      </table>
"""

# ╔═╡ 90cd251b-c8f4-4005-997b-cc1c0db78257
 html"""
 		<table border = "1" bordercolor = "green" bgcolor = "yellow">
         <tr>
            <th>Column 1</th>
            <th>Column 2</th>
            <th>Column 3</th>
         </tr>
         <tr>
            <td rowspan = "2">Row 1 Cell 1</td>
            <td>Row 1 Cell 2</td>
            <td>Row 1 Cell 3</td>
         </tr>
         <tr>
            <td>Row 2 Cell 2</td>
            <td>Row 2 Cell 3</td>
         </tr>
         <tr>
            <td colspan = "3">Row 3 Cell 1</td>
         </tr>
      </table>
			"""

# ╔═╡ 5787e23d-e4f4-4d1e-8b58-95c56a703fbb
html"""
<table border = "1" width = "400" height = "150">
         <tr>
            <td>Row 1, Column 1</td>
            <td>Row 1, Column 2</td>
         </tr>
         
         <tr>
            <td>Row 2, Column 1</td>
            <td>Row 2, Column 2</td>
         </tr>
      </table>
"""

# ╔═╡ 04448aaa-71f5-4efa-827d-29a5c9b701d9
html"""
   

<head>
      <title>HTML Table</title>
   </head>
	
   <body>
      <table border = "1" width = "100%" bgcolor = "yellow">
         <thead>
            <tr>
               <td colspan = "4">This is the head of the table</td>
            </tr>
         </thead>
         
         <tfoot>
            <tr>
               <td colspan = "4">This is the foot of the table</td>
            </tr>
         </tfoot>
         
         <tbody>
            <tr>
               <td>  <center><  Cell 1<br> test</center></td>
               <td>Cell 2</td>
               <td>Cell 3</td>
               <td>Cell 4</td>
            </tr>
         </tbody>
         
      </table>
     </body>

	
  

"""

# ╔═╡ ee82dff3-7fbb-4f23-b8bb-67b52085149d
html"""
      <table border = "1" width = "100%">
         
         <tr>
            <td>
               <table border = "1" width = "100%">
                  <tr>
                     <th>Name</th>
                     <th>Salary</th>
                  </tr>
                  <tr>
                     <td>Ramesh Raman</td>
                     <td>5000</td>
                  </tr>
                  <tr>
                     <td>Shabbir Hussein</td>
                     <td>7000</td>
                  </tr>
               </table>
            </td>
         </tr>
         
      </table>

"""

# ╔═╡ 2c98b1ad-702a-4cab-8d18-e51945c5e9d0
md"""
## HTML Lists
"""

# ╔═╡ b86b4cf9-94fe-4a1a-afb0-ef1695c6df78
html"""
<head>
      <title>HTML Unordered List</title>
   </head>
	
   <body>
      <ul type = "square">
         <li>Beetroot</li>
         <li>Ginger</li>
         <li>Potato</li>
         <li>Radish</li>
      </ul>
<ul type = "square">
<ul type = "disc">
<ul type = "circle">


<body>
      <ol type = "A"> 
         <li>Beetroot</li>
         <li>Ginger</li>
         <li>Potato</li>
         <li>Radish</li>
      </ol>
   
 <!--
<ol type = "1"> - Default-Case Numerals.
<ol type = "I"> - Upper-Case Numerals.
<ol type = "i"> - Lower-Case Numerals.
<ol type = "A"> - Upper-Case Letters.
<ol type = "a"> - Lower-Case Letters.

<ol type = "1" start = "4"> - Numerals starts with 4.
<ol type = "I" start = "4"> - Numerals starts with IV.
<ol type = "i" start = "4"> - Numerals starts with iv.
<ol type = "a" start = "4"> - Letters starts with d.
<ol type = "A" start = "4"> - Letters starts with D.
-->

		<dl>
         <dt><b>HTML</b></dt>
         <dd>This stands for Hyper Text Markup Language</dd>
         <dt><b>HTTP</b></dt>
         <dd>This stands for Hyper Text Transfer Protocol</dd>
      	</dl>


   

</body>
"""

# ╔═╡ 7e4a2f30-bf6f-401b-a082-c66fdd05ce4c
md"""
## HTML Links
"""

# ╔═╡ b69a1bea-3522-4a6e-994b-a10c3e945a6a
html"""<!--
<body> 
      <p>Click following link</p>
      <a href = "https://www.tutorialspoint.com" target = "_self">Tutorials Point</a>
   <a href = "https://www.tutorialspoint.com/html/html_quick_guide.htm" target = "_self">Click to go to the link</a>

</body>

<br>

 <head>
      <title>Hyperlink Example</title>
      <base href = "https://www.tutorialspoint.com/html/html_quick_guide.htm">
   </head>
	
   <body>
      <p>Click any of the following links</p>
      <a href = "/html/index.htm" target = "_blank">Opens in New</a> |
      <a href = "/html/index.htm" target = "_self">Opens in Self</a> |
      <a href = "/html/index.htm" target = "_parent">Opens in Parent</a> |
      <a href = "/html/index.htm" target = "_top">Opens in Body</a>
   </body>   

 <head>
      <title>Hyperlink Example</title>
      <base href = "https://www.tutorialspoint.com/">
   </head>
-->
   <body>
      <p>Click following link</p>
      <a href = "/html/index.htm" target = "_blank">HTML Tutorial</a>
   </body>
<p>HTML Text Links <a name = "top"></a></p>
<p>some text</p>
<a href = "/html/html_text_links.htm#top">Go to the Top</a>



</body>
"""

# ╔═╡ 06914567-01cc-4933-b399-4b5a3fd038c8
md"""
## HTML - Email Links
"""

# ╔═╡ 054b7884-3c2c-41bd-ae46-f6a4a3088daa
html"""
<a href = "mailto: abc@example.com">Send Email</a>
"""

# ╔═╡ bde2f0f4-3778-4637-83b1-adfc4ad6c30f
md"""
## HTML - Blocks
"""

# ╔═╡ efc9875c-af73-4af3-a3b7-8a955148dc8d
#html"""
@htl """   
   <head>
      <title>HTML div Tag</title>
   </head>
	
   <body>
      <!-- First group of tags -->
      <div style = "color:red">
         <h4>This is first group</h4>
         <p>Following is a list of vegetables</p>
         
         <ul>
            <li>Beetroot</li>
            <li>Ginger</li>
            <li>Potato</li>
            <li>Radish</li>
         </ul>
      </div>

      <!-- Second group of tags -->
      <div style = "color:green">
         <h4>This is second group</h4>
         <p>Following is a list of fruits</p>
         
         <ul>
            <li>Apple</li>
            <li>Banana</li>
            <li>Mango</li>
            <li>Strawberry</li>
         </ul>
      </div>


		   <head>
		      <title>HTML span Tag</title>
		   </head>
			
		   <body>
		      <p>This is <span style = "color:red">red</span> and this is
		         <span style = "color:green">green</span></p>
		   </body>
   </body>
   
</html>
"""

# ╔═╡ 89dbdca0-1f6f-4bed-b632-06fd14e65e49
pwd()

# ╔═╡ 3c96a5d0-85e1-4597-9907-a856a59d9b2a
md"""
## HTML - Backgrounds
"""

# ╔═╡ bef98420-c656-44ff-827a-3f7ad3412585
html"""
<head>
      <title>HTML Background Colors</title>
   </head>
	
   <body>
      <!-- Format 1 - Use color name -->
      <table bgcolor = "yellow" width = "50%" align="left">
         <tr>
            <td>
               This background is yellow
            </td>
         </tr>

      </table>
 
      <!-- Format 2 - Use hex value -->
      <table bgcolor = "#6666FF" width = "100%">
         <tr>
            <td>
               This background is sky blue
            </td>
         </tr>
      </table>
 
      <!-- Format 3 - Use color value in RGB terms -->
      <table bgcolor = "rgb(255,0,255)" width = "100%">
         <tr>
            <td>
               This background is green
            </td>
         </tr>
      </table>

<!-- Set a table background using pattern -->
      <table background = "https://patterninja.com/cover-0.png"  width = "100%" height = "10">
         <tr>
            <td>
               This background is filled up with a pattern image.
            </td>
         </tr>
      </table>



   </body>
"""

# ╔═╡ c6bf0ca8-a988-4720-9b2f-4acab0ad161a
md"""
## HTML - Colors
"""

# ╔═╡ 809ff068-a635-4679-ada9-ef5bf09a9b8e
#html"""
 @htl """
   <body>
       <table bgcolor = "yellow" width = "100%">
         <tr>
            <td>
               This background is yellow
       
            </td>
         </tr>
      
      
      </table>
      <table bgcolor = "Fuchsia">
         <tr>
            <td>
               <font color = "#FFFFFF">This text will appear white on fushsia background.</font>

            </td>
         </tr>
      </table>

<br>
<br>

      <a href = "https://htmlcolorcodes.com/color-chart/web-safe-color-chart/" target = "_blank">Click for nice color codes</a>

   </body>
"""

# ╔═╡ a2576af9-2e5f-4055-a68f-6ddacfe268ce
md"""
## HTML - Fonts
"""

# ╔═╡ 1a81abc6-2505-4699-a4f6-dbdbc0285cba
#html"""
@htl """
<body>
      <font size = "1">Font size = "1"</font> 
      <font size = "2">Font size = "2"</font> 
      <font size = "3">Font size = "3"</font> 
      <font size = "4">Font size = "4"</font><br />
      <font size = "5">Font size = "5"</font>
      <font size = "6">Font size = "6"</font> 
      <font size = "7">Font size = "7"</font>
   </body>
<br> <br>


 <font size = "-1">Font size = "-1"</font>
      <font size = "+1">Font size = "+1"</font>
      <font size = "+2">Font size = "+2"</font>
      <font size = "+3">Font size = "+3"</font>
      <font size = "+4">Font size = "+4"</font>
<br> <br>
<font face = "Times New Roman" size = "5">Times New Roman</font><br />
      <font face = "Verdana" size = "5">Verdana</font>
      <font face = "Comic sans MS" size =" 5">Comic Sans MS</font>
      <font face = "WildWest" size = "5">WildWest</font>
      <font face = "Bedrock" size = "5">Bedrock</font>

<font face = "arial,helvetica" size = "3">avaiable font</font><br />
<font face = "Lucida Calligraphy,Comic Sans MS,Lucida Console" size = "3">avaiable font</font><br />
 <font color = "#FF00FF">This text is in pink</font><br />
      <font color = "red">This text is red</font>
<br> <br>
      <basefont face = "arial, verdana, sans-serif" size = "2" color = "#ff0000">
      <p>This is the page's default font.</p>
      <h5>Example of the &lt;basefont&gt; Element</h5>
      
      <p><font size = "+2" color = "darkgray">
            This is darkgray text with two sizes larger
         </font>
      </p>

      <p><font face = "courier" size = "-1" color = "#000000">
            It is a courier font, a size smaller and black in color.
         </font>
      </p>
"""


# ╔═╡ d434b59b-c382-4bfd-bedd-609000b5e131
md"""
## HTML - Forms
"""

# ╔═╡ 3c22daf6-9088-4cfe-a1ee-a8f0b2392dd8
html"""
  <head>
      <title>Text Input Control</title>
   </head>
	
   <body>
      <form >
         First name: <input type = "text" name = "first_name" />
         <br>
         Last name: <input type = "text" name = "last_name" />
      </form>
   </body>

  <body>
      <form >
         User ID : <input type = "text" name = "user_id" />
         <br>
         Password: <input type = "password" name = "password" />
      </form>
   </body>
 <body>
      <form>
         Description : <br />
         <textarea rows = "5" cols = "50" name = "description">
            Enter description here...
         </textarea>
      </form>

 <form>
         <input type = "checkbox" name = "maths" value = "on"> Maths
         <input type = "checkbox" name = "physics" value = "on"> Physics
      </form>
   </body>

<body>
      <form>
         <input type = "radio" name = "subject" value = "maths"> Maths
         <input type = "radio" name = "subject" value = "physics"> Physics
      </form>
   </body>
<body>
      <form>
         <select name = "dropdown">
            <option value = "Maths" selected>Maths</option>
            <option value = "Physics">Physics</option>
         </select>
      </form>
   </body>
<body>
      <form>
         <input type = "file" name = "fileupload" accept = "image/*" />
      </form>
   </body>
<body>

   </body>
"""

# ╔═╡ 7a0cc7bd-6182-4291-b051-67382563e2ab
md"""
## HTML - Embed Multimedia
"""

# ╔═╡ c6a69629-3afe-45dc-bb8f-db1f0850a6ef
html"""
  <a href = "https://www.tutorialspoint.com/html/html_embed_multimedia.htm" target = "_blank">Click for more infos</a>
"""

# ╔═╡ b78dd4fb-09f2-40a4-8b1e-5eb7c0e5858d
md"""
# HypertextLiteral
https://juliapluto.github.io/HypertextLiteral.jl/dev/
"""

# ╔═╡ f030dbcc-af65-4180-a7cc-da835768f4ef
begin
book = "Strunk & White"
htl"<span>Today's Reading: $book</span>"
end

# ╔═╡ 1bade3bd-5dbc-4d43-bf7b-b9afdcb89499
@htl "They said, \"your total is \$42.50\"."

# ╔═╡ 18ec7cc8-2f03-48c0-9866-47a5e610af07
@bind x html" <<input type=range> " 

# ╔═╡ e9863fd8-c0b8-4ef4-9cfd-ad30b8f71195
"x="*string(x)

# ╔═╡ 1fb7486e-3915-409e-8ca3-18a884d4d5e4
begin
	@htl "  <div>
				<font color = \"red\">
					$(x)^2 is $(x^2)
				</font>
			</div>
		"
end

# ╔═╡ 0e038948-395c-4c11-8c39-ba3ce764600a
@bind cat Select(["yesterday", "today", "tomorrow"])

# ╔═╡ 9e87d367-8096-45b6-8ba4-65e73a4f99f2


# ╔═╡ 2a662847-3589-41f9-8bd2-08911127fa25
begin
	books = ["Who Gets What & Why", "Switch", "Governing The Commons"]
	@htl "
			<ul>$(map(books) do b @htl("<li>$b") end)</ul>
			 They said, \"your total is \$42.50\". <br>
			<div>$(HTML("<font color = 'red'>This text is red</font>"))</div>
			<div>$(md""" **bold** """)</div>
	     "
end

# ╔═╡ 60a6feea-f1f2-426d-8726-b8d345f4bc51
@htl "
<div>$(md""" *markdown* """)</div>
<span>They said, \"your total is \$42.50\" in HTML</span>
<div>$(md""" **new markdown** """)</div>
"

# ╔═╡ 6ac30130-4a7e-4401-9c60-ab6e59a8dbf9
cool_features=[1,3,"5"]

# ╔═╡ fe0d3c31-fcca-4198-9d42-11c2db8f76ec
@htl("""
	<p>It has a bunch of very cool features! Including:</p>
	<ul>$([
		@htl(
			"<li>$(item)</li>"
		)
		for item in cool_features
	])</ul>
	""")

# ╔═╡ b284add0-a6f1-4966-b232-6518f8fbe87c
#comment before
md""" 
# Markdown
"""
#comment after

# ╔═╡ d4c5c2b7-06a8-4a43-8081-daf52a00aa5e
md""" 

$(html"<!--This is a comment. Comments are not displayed in the browser-->")

Text above the line.

---

And text below the line. 

_text in italic_. or *italic* **bold** A paragraph containing a `literal` word.
A paragraph containing ``` `backtick` characters ```.

A paragraph containing some ``\LaTeX`` markup.

A paragraph containing a link to [Julia](http://www.julialang.org).


| Column One | Column Two | Column Three |
|:---------- | ----------: |:------------:|
| Row `10`    | Column `200` |              |
| *Row* 200    | **Row** 2000000  | C ``3000`` |
- dot 1
$(html"<br>")
$(html"<font color = 'red'>This text is in html red</font>")


- dot
   + subdot 
      * subsubdot
   →  (\rightarrow+tab)

#### title level 4

>
>insert line in blue 
>


This is the content of the note.

!!! warning "Beware!"

    And this is another one.

    This warning admonition has a custom title: `"Beware!"`.

!!! terminology "julia vs Julia"

    Strictly speaking, "Julia" refers to the language,
    and "julia" to the standard implementation.

!!! note
    ```julia
    function func(x)
        # ...
    end
    ```

> 👍  le rajout d'un emoji se fait en le trouvant sur le [net](https://gist.github.com/rxaviers/7360908) et couper coller !



""" # markdown end



# ╔═╡ 7ee327a6-cfc6-421e-9f67-0fe3c0cf9d0d

details(
    "Pluto is fun !", "A secret" )


# ╔═╡ 0e52df3e-b0f9-46cd-b496-a1b5e25b8ab6


# ╔═╡ 3aad6f2b-72ed-4329-959d-ba8c85c45671
md"""

 1. item one
 2. item two
 3. item three

```math
f(a) = \frac{1}{2\pi}\int_{0}^{2\pi} (\alpha+R\cos(\theta))d\theta
```


  * item one
  * item two

    ```
    f(x) = x
    ```

  * and a sublist:

      + sub-item one
      + sub-item two

This is a paragraph.

    function func(x)  (4 blanks)
        # ...
    end

Another paragraph.


A code block without a "language":

```
function func(x)
    # ...
end
```

and another one with the "language" specified as `julia`:

```julia
function func(x)
    # ...
end
```

"""

# ╔═╡ ee874a81-ba6d-4297-86ec-b53e82af4905
who = "🌍"

# ╔═╡ 99853782-fb10-4f97-bd56-0c9cd4876053
md"""
Hello $(who)
"""

# ╔═╡ 6f434ae7-52fa-4fb0-8609-2e78ce5a34bb
begin
	struct Foldable{C}
	    title::String
	    content::C
	end

	# <details>
    # <summary> A secret </summary>
    # <p> Pluto is fun </p>
    # </details>
	function Base.show(io, mime::MIME"text/html", fld::Foldable)
	    write(io,"<details><summary>$(fld.title)</summary><p>")
	    show(io, mime, fld.content)
	    write(io,"</p></details>")
	end
	Foldable("What is the gravitational acceleration?", md"Correct, it's ``\pi^2``.")
	
end

# ╔═╡ 40f566f1-5e9f-4908-b31e-477a8ed2cf1f
Foldable("Some cool plot:", plot(0:10, x -> x^2))

# ╔═╡ 2800321d-d156-4fb4-a0e9-b71af9c1fd42
begin
	struct TwoColumn{L, R}
    left::L
    right::R
end

function Base.show(io, mime::MIME"text/html", tc::TwoColumn)
    write(io, """<div style="display: flex;"><div style="flex: 50%;">""")
    show(io, mime, tc.left)
    write(io, """</div><div style="flex: 50%;">""")
    show(io, mime, tc.right)
    write(io, """</div></div>""")
	
end
	TwoColumn(md"Note the kink at ``x=0``!", plot(-5:5, abs))
end

# ╔═╡ 6a37fe9f-59dc-4d4f-b436-ca9a327823e5


# ╔═╡ a8f1852c-6fcd-459a-8d0c-6483bf11fb9c
md"""
# CSS
https://htmlcheatsheet.com/css/
https://www.tutorialrepublic.com/css-reference/css3-properties.php
"""

# ╔═╡ d99bf239-0cdf-4250-a790-5bb3ad7672aa
@htl """
      <img src = "https://bs-uploads.toptal.io/blackfish-uploads/uploaded_file/file/509262/image-1611230174330-01552ff764c16e2ed436b4841d9f0bbb.png" alt = "CSS definitions" width =50% height = 50%  border = "5" align = "center"/>
"""



# ╔═╡ 449baac8-a07a-4485-a791-03b30c059f31
@htl "
<head>
<style>
h4.center {
  text-align: center;
  color: red;
  background-color: #FFCCFF;
  border-bottom: 5px dashed #ff0000;
  border-radius: 20px;
  margin-left: 50px;
}

p.center {
  text-align: center;
  color: red;
  word-spacing: 50px;
}

p.large {
  font-size: 200%;
  text-align: right;
}
</style>
</head>
<body>

<h4 class='center'> This heading will be affected</h4>
<p class='center'>This paragraph will be red and center-aligned.</p>
<p class='center large'>This paragraph will be red, right-aligned, and in a large font-size.</p> 

</body>
"

# ╔═╡ 30e680a3-fcfc-42ed-95bf-2412df928f33
md"""
# Javascript
https://htmlcheatsheet.com/js/

https://plutocon2021-demos.netlify.app/fonsp%20%E2%80%94%20javascript%20inside%20pluto

https://javascript.info/
"""

# ╔═╡ fd23e53b-fe1c-4870-8ad4-c6a9853373ea
@htl """
<body>
  <p>Before the script...</p>
  <script>
    "use strict";
     let message;
	 message = 'Hello!';

     alert(message); alert('World');
  </script>
  <p>...After the script.</p>
</body>

"""

# ╔═╡ 665af8ed-10d2-4e42-a2c5-90675438522d
@htl """
<body>
 	<script>
    
	const COLOR_RED = '#F00';
	const COLOR_GREEN = '#0F0';
	const COLOR_BLUE = '#00F';
	const COLOR_ORANGE = '#FF7F00';
	
	// ...when we need to pick a color
	let color = COLOR_ORANGE;
	alert(color); // #FF7F00
    let str2 = 'Single quotes are ok too';
    let phrase = `can embed another \${str2}`;
    alert(phrase);

    let age = prompt('How old are you?', 100);
    let isBoss = confirm("Are you the boss?");

	let value = true;
	alert(typeof value); // boolean
	
	value = String(value); // now value is a string 'true'
	alert(typeof value); // string

     let year = prompt('In which year was ECMAScript-2015 specification published?', '');

	if (year < 2015) {
	  alert( 'Too early...' );
	} else if (year > 2015) {
	  alert( 'Too late' );
	} else {
	  alert( 'Exactly!' );
	}


 	let  age1 = prompt('age?', 18);
	let message1 = (age1 < 3) ? 'Hi, baby!' :
	(age1 < 18) ? 'Hello!' :
	(age1 < 100) ? 'Greetings!' :
	'What an unusual age!';
	alert( message1 );

	let i = 0;
	while (i < 3) { // shows 0, then 1, then 2
	  alert( i );
	  i++;
	}

    i=0
     do {
  alert( i );
  i++;
} while (i < 3);

for (let i = 0; i < 3; i++) { // shows 0, then 1, then 2
  alert(i);
}

let a = 2 + 2;

switch (a) {
  case 3:
    alert( 'Too small' );
    break;
  case 4:
  case 4.1
    alert( 'Exactly or nearly so!' );
    break;
  case 5:
    alert( 'Too big' );
    break;
  default:
    alert( "I don't know such values" );
}
	</script>
</body>

"""

# ╔═╡ 6535ea92-dcb0-49f3-8c3c-c16904443d08


# ╔═╡ c358f24c-9d25-497d-8296-bf69ca061454
ClickCounter(text="Click") = @htl("""
<div>
<button>$(text)</button>

<script>

	// Select elements relative to `currentScript`
	var div = currentScript.parentElement
	var button = div.querySelector("button")

	// we wrapped the button in a `div` to hide its default behaviour from Pluto

	var count = 0

	button.addEventListener("click", (e) => {
		count += 1

		// we dispatch the input event on the div, not the button, because 
		// Pluto's `@bind` mechanism listens for events on the **first element** in the
		// HTML output. In our case, that's the div.

		div.value = count
		div.dispatchEvent(new CustomEvent("input"))
		e.preventDefault()
	})

	// Set the initial value
	div.value = count

</script>
</div>
""")

# ╔═╡ 93374565-ae0b-4091-8bd9-9b973827a265
@bind num_clicks ClickCounter()

# ╔═╡ e71c955f-d15f-42a5-a2db-b009b7b607b1
num_clicks

# ╔═╡ 93300cf0-70d6-4caf-9613-04f3fa16d993
@show html"""

<script>

console.info("Can you find this message in the console?")

</script>

""" 

# ╔═╡ bc1a6ee3-0817-4863-b205-a75e0e9b326f
begin
	lol = IOBuffer()
	println(lol,"How to write several lines in one cell")
	println(lol,"TEXT2")
	take!(lol) |> String |> Text
end

# ╔═╡ 64e94ff5-9f55-4ea9-83d0-e0684b87d6d0
@htl("""

<!-- the wrapper div -->
<div>
    <button id="first">Hello</button> 
    <button id="second">Julians!</button>
    
    <script>
        var wrapper_div = currentScript.parentElement
        // we can now use querySelector to select anything we want
        var first_button = wrapper_div.querySelector("button#first")
        console.log(first_button)
    </script>
</div>
""")

# ╔═╡ c0045615-0d56-4c72-9804-ecdd328c0b93
@bind fantastic_x Slider(0:400)

# ╔═╡ 97ed000f-c004-4d23-880c-ae8c0a44929c
my_data = [
	(name="Cool", coordinate=[100, 100]),
	(name="Awesome", coordinate=[200, 100]),
	(name="Fantastic!", coordinate=[fantastic_x, 150]),
]

# ╔═╡ d786ab9f-a785-44e8-b902-758e20db4377
@htl("""
	<script src="https://cdn.jsdelivr.net/npm/d3@6.2.0/dist/d3.min.js"></script>

	<script>

	// interpolate the data 🐸
	const data = $(JSON.json(my_data))

	const svg = DOM.svg(600,200)
	const s = d3.select(svg)

	s.selectAll("text")
		.data(data)
		.join("text")
		.attr("x", d => d.coordinate[0])
		.attr("y", d => d.coordinate[1])
		.text(d => d.name)

	return svg
	</script>
""")

# ╔═╡ a684bc55-2462-4787-bd19-ad00ad8e30fc
films = [
	(title="Frances Ha", director="Noah Baumbach", year=2012),
	(title="Portrait de la jeune fille en feu", director="Céline Sciamma", year=2019),
	(title="De noorderlingen", director="Alex van Warmerdam", year=1992),
];

# ╔═╡ a44b046b-aa07-458a-bb9d-6856be856826
@htl("""
	<script>
	
	let data = $(JSON.json(films))
	
	// html`...` is from https://github.com/observablehq/stdlib
	// note the escaped dollar signs:
	let Film = ({title, director, year}) => html`
		<li class="film">
			<b>\${title}</b> by <em>\${director}</em> (\${year})
		</li>
	`
	
	// the returned HTML node is rendered
	return html`
		<ul>
			\${data.map(Film)}
		</ul>
	`
	
	</script>
	""")

# ╔═╡ 441a0161-4643-4403-be2c-092c67e245e0
md"""
# Mise en forme type Powerpoint
Full screen with F11 click "present" to return
"""

# ╔═╡ 79562a95-48ea-4429-99bb-a7118d143940
html"<button onclick='present()'>present</button>"

# ╔═╡ 8473d57b-f8a6-408e-b3fd-59e5c5f92935
@gif for φ in 0 : .1 : 2π
    plot(0 : .1 : 2π, t -> sin(t + φ))
end

# ╔═╡ b02c847d-9499-4e53-95e2-ef086a2fa1d6
let
    # show the first 10 builtin colours:
    animation = @animate for i in 1:10
        scatter([1], [1], msize=10, shape=:hexagon, mcolour=i)
    end

    gif(animation, fps=1)
end

# ╔═╡ 25ace84a-d464-4a85-ba8c-cf1e474bd590
md"""
## Introduction
Attraction to other membranes/surfaces mediated by adhesion molecules → observe **phase separation** into domains with small and large distance.
###### Can we theoretically explain, why?
#### Roadmap
1. A physical model of membranes
1. How membranes interact
1. Statistical physics, transforming the system
1. Identifying stable states under different conditions
"""




# ╔═╡ da974fc8-bd51-4434-a1c6-80f8407fc9a3
md"""
# slide 2 
qq data 2
"""

# ╔═╡ 94fdc6c4-149e-48c8-bcc4-f59fbcd77261
md"""
# slide 3
qq data 3
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
FileIO = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
ImageIO = "82e4d734-157c-48bb-816b-45c225c6df19"
ImageShow = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
InteractiveUtils = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
JSON = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
ColorVectorSpace = "~0.9.9"
Colors = "~0.12.8"
FileIO = "~1.14.0"
HypertextLiteral = "~0.9.4"
ImageIO = "~0.6.5"
ImageShow = "~0.3.6"
JSON = "~0.21.3"
Plots = "~1.30.1"
PlutoUI = "~0.7.39"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CEnum]]
git-tree-sha1 = "eb4cb44a499229b3b8426dcfb5dd85333951ff90"
uuid = "fa961155-64e5-5f13-b03f-caf6b980ea82"
version = "0.4.2"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9489214b993cd42d17f44c36e359bf6a7c919abf"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "1e315e3f4b0b7ce40feded39c73049692126cf53"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.3"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "7297381ccb5df764549818d9a7d57e45f1057d30"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.18.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "924cdca592bc16f14d2f7006754a621735280b74"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.1.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.DataAPI]]
git-tree-sha1 = "fb5f5316dd3fd4c5e7c30a24d50643b73e37cd40"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.10.0"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "d1fff3a548102f48987a52a2e0d114fa97d730f0"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.13"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FileIO]]
deps = ["Pkg", "Requires", "UUIDs"]
git-tree-sha1 = "9267e5f50b0e12fdfd5a2455534345c4cf2c7f7a"
uuid = "5789e2e9-d7fb-5bc7-8068-2c6fae9b9549"
version = "1.14.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "c98aea696662d09e215ef7cda5296024a9646c75"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.4"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "3a233eeeb2ca45842fe100e0413936834215abf5"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.4+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphics]]
deps = ["Colors", "LinearAlgebra", "NaNMath"]
git-tree-sha1 = "d61890399bc535850c4bf08e4e0d3a7ad0f21cbd"
uuid = "a2bd30eb-e257-5431-a919-1863eab51364"
version = "1.1.2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.ImageBase]]
deps = ["ImageCore", "Reexport"]
git-tree-sha1 = "b51bb8cae22c66d0f6357e3bcb6363145ef20835"
uuid = "c817782e-172a-44cc-b673-b171935fbb9e"
version = "0.1.5"

[[deps.ImageCore]]
deps = ["AbstractFFTs", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Graphics", "MappedArrays", "MosaicViews", "OffsetArrays", "PaddedViews", "Reexport"]
git-tree-sha1 = "acf614720ef026d38400b3817614c45882d75500"
uuid = "a09fc81d-aa75-5fe9-8630-4744c3626534"
version = "0.9.4"

[[deps.ImageIO]]
deps = ["FileIO", "IndirectArrays", "JpegTurbo", "LazyModules", "Netpbm", "OpenEXR", "PNGFiles", "QOI", "Sixel", "TiffImages", "UUIDs"]
git-tree-sha1 = "d9a03ffc2f6650bd4c831b285637929d99a4efb5"
uuid = "82e4d734-157c-48bb-816b-45c225c6df19"
version = "0.6.5"

[[deps.ImageShow]]
deps = ["Base64", "FileIO", "ImageBase", "ImageCore", "OffsetArrays", "StackViews"]
git-tree-sha1 = "b563cf9ae75a635592fc73d3eb78b86220e55bd8"
uuid = "4e3cecfd-b093-5904-9786-8bbb286a6a31"
version = "0.3.6"

[[deps.Imath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "87f7662e03a649cffa2e05bf19c303e168732d3e"
uuid = "905a6f67-0a94-5f89-b386-d35d92009cd1"
version = "3.1.2+0"

[[deps.IndirectArrays]]
git-tree-sha1 = "012e604e1c7458645cb8b436f8fba789a51b257f"
uuid = "9b13fd28-a010-5f03-acff-a1bbcff69959"
version = "1.0.0"

[[deps.Inflate]]
git-tree-sha1 = "f5fc07d4e706b84f72d54eedcc1c13d92fb0871c"
uuid = "d25df0c9-e2be-5dd7-82c8-3ad0b3e990b9"
version = "0.1.2"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "b3364212fb5d870f724876ffcd34dd8ec6d98918"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.7"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo]]
deps = ["CEnum", "FileIO", "ImageCore", "JpegTurbo_jll", "TOML"]
git-tree-sha1 = "a77b273f1ddec645d1b7c4fd5fb98c8f90ad10a5"
uuid = "b835a17e-a41a-41e7-81f0-2f016b05efe0"
version = "0.1.1"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "46a39b9c58749eefb5f2dc1178cb8fab5332b1ab"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.15"

[[deps.LazyModules]]
git-tree-sha1 = "a560dd966b386ac9ae60bdd3a3d3a326062d3c3e"
uuid = "8cdb02fc-e678-4876-92c5-9defec4f444e"
version = "0.3.1"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "3eb79b0ca5764d4799c06699573fd8f533259713"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.4.0+0"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "09e4b894ce6a976c354a69041a04748180d43637"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.15"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.MappedArrays]]
git-tree-sha1 = "e8b359ef06ec72e8c030463fe02efe5527ee5142"
uuid = "dbb5928d-eab1-5f90-85c2-b9b0edb7c900"
version = "0.4.1"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MosaicViews]]
deps = ["MappedArrays", "OffsetArrays", "PaddedViews", "StackViews"]
git-tree-sha1 = "b34e3bc3ca7c94914418637cb10cc4d1d80d877d"
uuid = "e94cdb99-869f-56ef-bcf0-1ae2bcbe0389"
version = "0.3.3"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NaNMath]]
git-tree-sha1 = "737a5957f387b17e74d4ad2f440eb330b39a62c5"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "1.0.0"

[[deps.Netpbm]]
deps = ["FileIO", "ImageCore"]
git-tree-sha1 = "18efc06f6ec36a8b801b23f076e3c6ac7c3bf153"
uuid = "f09324ee-3d7c-5217-9330-fc30815ba969"
version = "1.0.2"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "ec2e30596282d722f018ae784b7f44f3b88065e4"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.12.6"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenEXR]]
deps = ["Colors", "FileIO", "OpenEXR_jll"]
git-tree-sha1 = "327f53360fdb54df7ecd01e96ef1983536d1e633"
uuid = "52e1d378-f018-4a11-a4be-720524705ac7"
version = "0.3.2"

[[deps.OpenEXR_jll]]
deps = ["Artifacts", "Imath_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "923319661e9a22712f24596ce81c54fc0366f304"
uuid = "18a262bb-aa17-5467-a713-aee519bc75cb"
version = "3.1.1+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PNGFiles]]
deps = ["Base64", "CEnum", "ImageCore", "IndirectArrays", "OffsetArrays", "libpng_jll"]
git-tree-sha1 = "e925a64b8585aa9f4e3047b8d2cdc3f0e79fd4e4"
uuid = "f57f5aa1-a3ce-4bc8-8ab9-96f992907883"
version = "0.3.16"

[[deps.PaddedViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "03a7a85b76381a3d04c7a1656039197e70eda03d"
uuid = "5432bcbf-9aad-5242-b902-cca2824c8663"
version = "0.5.11"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "0044b23da09b5608b4ecacb4e5e6c6332f833a7e"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.3.2"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PkgVersion]]
deps = ["Pkg"]
git-tree-sha1 = "a7a7e1a88853564e551e4eba8650f8c38df79b37"
uuid = "eebad327-c553-4316-9ea0-9fa01ccd7688"
version = "0.1.1"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "2402dffcbc5bb1631fb4f10cb5c3698acdce29ea"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.30.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "8d1f54886b9037091edf146b517989fc4a09efec"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.39"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.ProgressMeter]]
deps = ["Distributed", "Printf"]
git-tree-sha1 = "d7a7aef8f8f2d537104f170139553b14dfe39fe9"
uuid = "92933f4c-e287-5a05-a399-4b506db050ca"
version = "1.7.2"

[[deps.QOI]]
deps = ["ColorTypes", "FileIO", "FixedPointNumbers"]
git-tree-sha1 = "18e8f4d1426e965c7b532ddd260599e1510d26ce"
uuid = "4b34888f-f399-49d4-9bb3-47ed5cae4e65"
version = "1.0.0"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sixel]]
deps = ["Dates", "FileIO", "ImageCore", "IndirectArrays", "OffsetArrays", "REPL", "libsixel_jll"]
git-tree-sha1 = "8fb59825be681d451c246a795117f317ecbcaa28"
uuid = "45858cf5-a6b0-47a3-bbea-62219f50df47"
version = "0.1.2"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "a9e798cae4867e3a41cae2dd9eb60c047f1212db"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.6"

[[deps.StackViews]]
deps = ["OffsetArrays"]
git-tree-sha1 = "46e589465204cd0c08b4bd97385e4fa79a0c770c"
uuid = "cae243ae-269e-4f55-b966-ac2d0dc13c15"
version = "0.1.1"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "2bbd9f2e40afd197a1379aef05e0d85dba649951"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "2c11d7290036fe7aac9038ff312d3b3a2a5bf89e"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.4.0"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "642f08bf9ff9e39ccc7b710b2eb9a24971b52b1a"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.17"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "9abba8f8fb8458e9adf07c8a2377a070674a24f1"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.8"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TiffImages]]
deps = ["ColorTypes", "DataStructures", "DocStringExtensions", "FileIO", "FixedPointNumbers", "IndirectArrays", "Inflate", "OffsetArrays", "PkgVersion", "ProgressMeter", "UUIDs"]
git-tree-sha1 = "f90022b44b7bf97952756a6b6737d1a0024a3233"
uuid = "731e570b-9d59-4bfa-96dc-6df516fadf69"
version = "0.5.5"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "58443b63fb7e465a8a7210828c91c08b92132dff"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.14+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libsixel_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "78736dab31ae7a53540a6b752efc61f77b304c5b"
uuid = "075b6546-f08a-558a-be8f-8157d0f608a5"
version = "1.8.6+1"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╠═36c9a925-d302-4630-a897-cec14e327e9f
# ╠═7a3885f1-f97e-47e4-9e97-8fecad703733
# ╠═12230364-811f-4fda-a026-e33cf06ff1a7
# ╠═e5d00386-2872-4029-b29e-03ef271c6f26
# ╠═fb754a60-e746-4c1a-91bc-6d91619ef36f
# ╠═e5369ccf-34f5-46c8-88b8-72c5320743cd
# ╠═a9be9eb0-f073-11ec-3802-9d7ec98ae107
# ╠═44fdda29-cf15-4b19-b40f-f9d37cb67eb8
# ╠═4041c29c-0afc-410d-b0f9-3d886a31308c
# ╟─d90f2fae-d9bb-497c-a168-b676e16308da
# ╟─709b24a4-9df2-4685-a5c2-b8b74f7b27da
# ╠═05374086-62c1-4ee6-9d68-15f04d18a22f
# ╟─243d9f26-4965-40de-a939-372aeb439d3d
# ╠═e88df846-ac26-4982-b260-1eb5e7f72301
# ╠═092fa136-86a0-45aa-be76-f3b6bac1392d
# ╟─28718f27-689e-4817-9813-040a145fa1dc
# ╠═e8840978-cc0c-40b9-9db8-15b0b12ce2b6
# ╟─c9fa03fc-295e-485c-a7e9-e53ec069ef20
# ╠═fe8a09ce-f38c-4189-a3e8-6dfdbf171dff
# ╟─78526e74-1d59-43ba-a9ea-6db08f441fb0
# ╟─b4e04ab6-0338-4a41-9e7e-c5377ee29561
# ╟─94b683b0-23f8-4a63-9362-7dff29814ba5
# ╟─163ef32a-3cf8-498a-b006-a60f5a0c04c9
# ╟─a8572e86-4605-4995-b023-9a12df9821e0
# ╟─ca0d2f5f-2ecf-4e6e-9ee9-33959b1b5131
# ╟─a6f91b84-bc93-40de-b0e8-8c92ce9fc204
# ╟─90cd251b-c8f4-4005-997b-cc1c0db78257
# ╟─5787e23d-e4f4-4d1e-8b58-95c56a703fbb
# ╟─04448aaa-71f5-4efa-827d-29a5c9b701d9
# ╟─ee82dff3-7fbb-4f23-b8bb-67b52085149d
# ╟─2c98b1ad-702a-4cab-8d18-e51945c5e9d0
# ╟─b86b4cf9-94fe-4a1a-afb0-ef1695c6df78
# ╟─7e4a2f30-bf6f-401b-a082-c66fdd05ce4c
# ╠═b69a1bea-3522-4a6e-994b-a10c3e945a6a
# ╟─06914567-01cc-4933-b399-4b5a3fd038c8
# ╟─054b7884-3c2c-41bd-ae46-f6a4a3088daa
# ╟─bde2f0f4-3778-4637-83b1-adfc4ad6c30f
# ╟─efc9875c-af73-4af3-a3b7-8a955148dc8d
# ╠═89dbdca0-1f6f-4bed-b632-06fd14e65e49
# ╟─3c96a5d0-85e1-4597-9907-a856a59d9b2a
# ╟─bef98420-c656-44ff-827a-3f7ad3412585
# ╟─c6bf0ca8-a988-4720-9b2f-4acab0ad161a
# ╟─809ff068-a635-4679-ada9-ef5bf09a9b8e
# ╟─a2576af9-2e5f-4055-a68f-6ddacfe268ce
# ╠═1a81abc6-2505-4699-a4f6-dbdbc0285cba
# ╟─d434b59b-c382-4bfd-bedd-609000b5e131
# ╟─3c22daf6-9088-4cfe-a1ee-a8f0b2392dd8
# ╟─7a0cc7bd-6182-4291-b051-67382563e2ab
# ╟─c6a69629-3afe-45dc-bb8f-db1f0850a6ef
# ╟─b78dd4fb-09f2-40a4-8b1e-5eb7c0e5858d
# ╠═f030dbcc-af65-4180-a7cc-da835768f4ef
# ╠═1bade3bd-5dbc-4d43-bf7b-b9afdcb89499
# ╠═18ec7cc8-2f03-48c0-9866-47a5e610af07
# ╠═e9863fd8-c0b8-4ef4-9cfd-ad30b8f71195
# ╠═1fb7486e-3915-409e-8ca3-18a884d4d5e4
# ╠═0e038948-395c-4c11-8c39-ba3ce764600a
# ╠═9e87d367-8096-45b6-8ba4-65e73a4f99f2
# ╠═2a662847-3589-41f9-8bd2-08911127fa25
# ╠═60a6feea-f1f2-426d-8726-b8d345f4bc51
# ╠═fe0d3c31-fcca-4198-9d42-11c2db8f76ec
# ╠═6ac30130-4a7e-4401-9c60-ab6e59a8dbf9
# ╠═b284add0-a6f1-4966-b232-6518f8fbe87c
# ╠═d4c5c2b7-06a8-4a43-8081-daf52a00aa5e
# ╠═7ee327a6-cfc6-421e-9f67-0fe3c0cf9d0d
# ╠═0e52df3e-b0f9-46cd-b496-a1b5e25b8ab6
# ╠═3aad6f2b-72ed-4329-959d-ba8c85c45671
# ╠═ee874a81-ba6d-4297-86ec-b53e82af4905
# ╠═99853782-fb10-4f97-bd56-0c9cd4876053
# ╠═6f434ae7-52fa-4fb0-8609-2e78ce5a34bb
# ╟─40f566f1-5e9f-4908-b31e-477a8ed2cf1f
# ╠═2800321d-d156-4fb4-a0e9-b71af9c1fd42
# ╠═6a37fe9f-59dc-4d4f-b436-ca9a327823e5
# ╠═a8f1852c-6fcd-459a-8d0c-6483bf11fb9c
# ╠═d99bf239-0cdf-4250-a790-5bb3ad7672aa
# ╠═449baac8-a07a-4485-a791-03b30c059f31
# ╟─30e680a3-fcfc-42ed-95bf-2412df928f33
# ╠═fd23e53b-fe1c-4870-8ad4-c6a9853373ea
# ╠═665af8ed-10d2-4e42-a2c5-90675438522d
# ╠═6535ea92-dcb0-49f3-8c3c-c16904443d08
# ╠═c358f24c-9d25-497d-8296-bf69ca061454
# ╠═93374565-ae0b-4091-8bd9-9b973827a265
# ╠═e71c955f-d15f-42a5-a2db-b009b7b607b1
# ╠═93300cf0-70d6-4caf-9613-04f3fa16d993
# ╠═bc1a6ee3-0817-4863-b205-a75e0e9b326f
# ╠═64e94ff5-9f55-4ea9-83d0-e0684b87d6d0
# ╠═c0045615-0d56-4c72-9804-ecdd328c0b93
# ╠═97ed000f-c004-4d23-880c-ae8c0a44929c
# ╠═d786ab9f-a785-44e8-b902-758e20db4377
# ╠═a44b046b-aa07-458a-bb9d-6856be856826
# ╠═a684bc55-2462-4787-bd19-ad00ad8e30fc
# ╠═441a0161-4643-4403-be2c-092c67e245e0
# ╠═79562a95-48ea-4429-99bb-a7118d143940
# ╠═8473d57b-f8a6-408e-b3fd-59e5c5f92935
# ╠═b02c847d-9499-4e53-95e2-ef086a2fa1d6
# ╟─25ace84a-d464-4a85-ba8c-cf1e474bd590
# ╟─da974fc8-bd51-4434-a1c6-80f8407fc9a3
# ╟─94fdc6c4-149e-48c8-bcc4-f59fbcd77261
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
