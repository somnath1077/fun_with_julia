### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 41c8dfe2-ece6-11ea-2af5-696e277a067d
begin
	using Images
	using ImageView
	using DSP
	using PlutoUI
end

# ╔═╡ 713a1ebe-ece9-11ea-2ead-9f54465ebdc5
md"# First Notebook

We explore Pluto and some libraries to manipulate images in Julia The libraries Images and ImageView contain the basic tools for manipulating images. DSP has several useful functions, in particular, for convolving two arrays.
"

# ╔═╡ c9f4f916-ed25-11ea-3f48-6fba7c091aff
md"### Cats"

# ╔═╡ b1481980-ece8-11ea-3c49-01fef00c362b
img = load("cat.jpg")

# ╔═╡ e3d38b1c-ece8-11ea-0501-f9fcd84cf8ed
typeof(img)

# ╔═╡ 0f5b4996-ece9-11ea-2408-0b583f04c671
size(img)

# ╔═╡ 1dabf20e-ece9-11ea-30e3-4baed92bbd74
img[1:100, 1:200]

# ╔═╡ 23b3fe26-ece9-11ea-11d8-d157ca7ac9c4
RGBX(0.2, 0.4, 0.5)

# ╔═╡ 13502eea-eceb-11ea-2c98-2d2a856faa7a
RGBX(0.2, 0.9, 0.9)

# ╔═╡ a4e8a2f2-ed0d-11ea-2840-49bb6ab34333
begin
	(h, w) = size(img)
	new_img = img[1:h ÷ 2, w ÷ 2:w]
end

# ╔═╡ a51b9c44-ed0e-11ea-3665-4db614e7e00e
cpy = copy(new_img)

# ╔═╡ 460f4dfe-ed0f-11ea-1f15-29e09760c7b0
r = RGB(1, 0, 0)

# ╔═╡ b29b7ab8-ed0e-11ea-2f14-21f3d8cde67f
begin
	for i in 1:100
		for j in 1:100
			cpy[i, j] = r
		end
	end
end

# ╔═╡ 52ae38f6-ed0f-11ea-1061-bd166d6b3940
cpy

# ╔═╡ 55c7adf6-ed0f-11ea-3940-49f613123c01
cpy2 = copy(img)

# ╔═╡ a6f61c62-ed0f-11ea-230b-c3e7529d4525
cpy2[1:100, 1:100] .= RGB(0, 1, 0)

# ╔═╡ 1a205068-ed10-11ea-1c3d-7bf905d5e173
function redify(color)
	return RGB(color.r, 0, 0)
end

# ╔═╡ 27d9a416-ed10-11ea-28a8-afbcef7ac918
begin
	color = RGB(0.6, 0.4, 0.7)
	[color, redify(color)]
end

# ╔═╡ 391062ec-ed10-11ea-24c2-67ac934f94fc
redify.(cpy)

# ╔═╡ 7931aad4-ed10-11ea-2263-999f1baefcce
redify.(img)

# ╔═╡ c00ed3f6-ed14-11ea-2b77-5b18e50344ea
function blur(n)
	a = Array{Float64, 2}(undef, (n, n)) 
	return fill!(a, 1.0 / n^2)
end

# ╔═╡ 14c1d3d0-ed15-11ea-3248-032db33591f2
blur(10)

# ╔═╡ e5945252-ed16-11ea-27e6-45dbac07cf9a
function blueify(color)
	return RGB(0, 0, color.b)
end

# ╔═╡ f1393802-ed16-11ea-1943-3b1f661ef06e
function greenify(color)
	return RGB(0, color.g, 0)
end

# ╔═╡ fa40091c-ed16-11ea-314e-a1a24b853f41
blueify.(img)

# ╔═╡ ff47e70e-ed16-11ea-3e37-a9f40549eb75
function get_red(color)
	return color.r
end

# ╔═╡ ac556ebc-ed17-11ea-3853-e96af971e677
function get_green(color)
	return color.g
end

# ╔═╡ b98d40f0-ed17-11ea-1058-c54d4fc8cd13
function get_blue(color)
	return color.b
end

# ╔═╡ 4319917a-ed18-11ea-33a2-e97cc3acc992
function combine_colors(r, g, b)
	return RGB(r, g, b)
end

# ╔═╡ c9a197ee-ed1b-11ea-25b8-6565cf5f853c
function get_RGB_components(img)
	return (get_red.(img), get_green.(img), get_blue.(img))
end

# ╔═╡ cff2d620-ed17-11ea-3cbb-cd7ed3ad5959
function convolve(img, blur_factor)
	(r_comp, g_comp, b_comp) = get_RGB_components(img)
	
	r_conv = conv(r_comp, blur(blur_factor))
	g_conv = conv(g_comp, blur(blur_factor))
	b_conv = conv(b_comp, blur(blur_factor))
	return combine_colors.(r_conv, g_conv, b_conv)
end

# ╔═╡ c62cc13a-ed20-11ea-26f3-47190421ecc7
function convolve2(img, mat)
	(r_comp, g_comp, b_comp) = get_RGB_components(img)
	
	r_conv = conv(r_comp, mat)
	g_conv = conv(g_comp, mat)
	b_conv = conv(b_comp, mat)
	return combine_colors.(r_conv, g_conv, b_conv)
end

# ╔═╡ a6f91e7c-ed18-11ea-3ad8-776cf4fd96d2
@bind blur_factor Slider(1:20, show_value=true)

# ╔═╡ a8f7ac48-ed18-11ea-2ca9-8342fd0716e2
convolve(img, blur_factor)

# ╔═╡ 36f87058-ed1f-11ea-023a-2b1d461d620b
edge_detect = zeros((3, 3))

# ╔═╡ 2405b7de-ed20-11ea-319c-536a2472b711
begin
	edge_detect[1, 2] = -1.0
	edge_detect[2, 1] = -1.0
	edge_detect[2, 2] = 4.0
	edge_detect[2, 3] = -1.0
	edge_detect[3, 2] = -1.0
end

# ╔═╡ ee3da50c-ed20-11ea-13b3-8359d85abb35
convolve2(img, edge_detect)

# ╔═╡ f664baf4-ed20-11ea-1c36-a76486b43a9a


# ╔═╡ Cell order:
# ╟─713a1ebe-ece9-11ea-2ead-9f54465ebdc5
# ╠═41c8dfe2-ece6-11ea-2af5-696e277a067d
# ╟─c9f4f916-ed25-11ea-3f48-6fba7c091aff
# ╠═b1481980-ece8-11ea-3c49-01fef00c362b
# ╠═e3d38b1c-ece8-11ea-0501-f9fcd84cf8ed
# ╠═0f5b4996-ece9-11ea-2408-0b583f04c671
# ╠═1dabf20e-ece9-11ea-30e3-4baed92bbd74
# ╠═23b3fe26-ece9-11ea-11d8-d157ca7ac9c4
# ╠═13502eea-eceb-11ea-2c98-2d2a856faa7a
# ╠═a4e8a2f2-ed0d-11ea-2840-49bb6ab34333
# ╠═a51b9c44-ed0e-11ea-3665-4db614e7e00e
# ╠═460f4dfe-ed0f-11ea-1f15-29e09760c7b0
# ╠═b29b7ab8-ed0e-11ea-2f14-21f3d8cde67f
# ╠═52ae38f6-ed0f-11ea-1061-bd166d6b3940
# ╠═55c7adf6-ed0f-11ea-3940-49f613123c01
# ╠═a6f61c62-ed0f-11ea-230b-c3e7529d4525
# ╠═1a205068-ed10-11ea-1c3d-7bf905d5e173
# ╠═27d9a416-ed10-11ea-28a8-afbcef7ac918
# ╠═391062ec-ed10-11ea-24c2-67ac934f94fc
# ╠═7931aad4-ed10-11ea-2263-999f1baefcce
# ╠═c00ed3f6-ed14-11ea-2b77-5b18e50344ea
# ╠═14c1d3d0-ed15-11ea-3248-032db33591f2
# ╠═e5945252-ed16-11ea-27e6-45dbac07cf9a
# ╠═f1393802-ed16-11ea-1943-3b1f661ef06e
# ╠═fa40091c-ed16-11ea-314e-a1a24b853f41
# ╠═ff47e70e-ed16-11ea-3e37-a9f40549eb75
# ╠═ac556ebc-ed17-11ea-3853-e96af971e677
# ╠═b98d40f0-ed17-11ea-1058-c54d4fc8cd13
# ╠═4319917a-ed18-11ea-33a2-e97cc3acc992
# ╠═c9a197ee-ed1b-11ea-25b8-6565cf5f853c
# ╠═cff2d620-ed17-11ea-3cbb-cd7ed3ad5959
# ╠═c62cc13a-ed20-11ea-26f3-47190421ecc7
# ╠═a6f91e7c-ed18-11ea-3ad8-776cf4fd96d2
# ╠═a8f7ac48-ed18-11ea-2ca9-8342fd0716e2
# ╠═36f87058-ed1f-11ea-023a-2b1d461d620b
# ╠═2405b7de-ed20-11ea-319c-536a2472b711
# ╠═ee3da50c-ed20-11ea-13b3-8359d85abb35
# ╠═f664baf4-ed20-11ea-1c36-a76486b43a9a
