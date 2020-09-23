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

# ╔═╡ 04981932-ef55-11ea-0357-4b296df2880a
begin
	using Images
		
	cat_img = load("cat.jpg")
end

# ╔═╡ 58bd8baa-fd81-11ea-1895-618702888b37
begin
	using PlutoUI
	
	@bind blur_factor Slider(1:20, show_value=true)
end

# ╔═╡ de841902-ef55-11ea-1a4e-e93078de192d
md"# An Introduction to Julia and Pluto
"

# ╔═╡ 7eaa2560-fd85-11ea-3aaa-0142a1e78325
x = 6

# ╔═╡ 8315cda2-fd85-11ea-0743-adf8c7da9360
y = x^2

# ╔═╡ 443b1aa4-fd69-11ea-0d56-bb3b79db391b
md"## And there shall be Greek!"

# ╔═╡ c6f03756-fd67-11ea-2e7e-29d185e8ac72
begin
	α = 2
	β = 2
	γ = 3
	δ = 4
end

# ╔═╡ 7ba28db6-fd68-11ea-00e6-a50cdd5e1c00
z(a, b) = α * a^2 + β * a * b + γ * b^2 + δ

# ╔═╡ cd3c51a2-fd68-11ea-1e98-2d7243725f10
z(1, 2)

# ╔═╡ 0a77b05c-fd7d-11ea-34aa-5d76e5d91164
md"### Math Constants"

# ╔═╡ b93a5866-fd7c-11ea-3543-e5455a87291b
π

# ╔═╡ bde55eee-fd7c-11ea-3200-f728444cbd52
ℯ

# ╔═╡ 43c23d1e-fd7d-11ea-0d54-9186e498b91a
md"### Euler's Equation 

``
$
	e^{i \pi} + 1 = 0
$
``
"

# ╔═╡ 1efc1338-fd7d-11ea-180e-87ba1b4badf1
ℯ^(im * π) + 1

# ╔═╡ 7af67b92-fd69-11ea-0808-d93f995c6239
md"## A Famous Greek Guy and His Algorithm"

# ╔═╡ fa5707e0-fd68-11ea-12a8-abe10351c405
function gcd(a, b)
	if b == 0
		return a
	else
		return gcd(b, a % b)
	end
end

# ╔═╡ c7322eea-fd69-11ea-0d75-bfa3ffcf34ea
gcd(34, 8)

# ╔═╡ cf3b7a72-fd69-11ea-173d-2df17ece474e
gcd(17325, 345)

# ╔═╡ e467d544-fd69-11ea-3b20-0f8f3ebabc5c
gcd(-10, -5)

# ╔═╡ 66818094-fd69-11ea-2c19-41b9631fb375
md"## Convoluting Images"

# ╔═╡ 3091922e-fd7f-11ea-19ba-f3836c82e08b
pwd()

# ╔═╡ cef8dfaa-fd6e-11ea-3e40-1d1ec66c0619
md"https://medium.com/@bdhuma/6-basic-things-to-know-about-convolution-daef5e1bc411"

# ╔═╡ 6b8d7ee6-fd6c-11ea-0789-21fe119334ad
convolving_diagram = load("convolving_images.png")

# ╔═╡ 4d66a14e-ef58-11ea-39e4-aff29ee497f8
size(cat_img)

# ╔═╡ 12c629c4-fd6d-11ea-1f5d-e3cac5cc838a
size(cat_img)[1]

# ╔═╡ 2706b138-fd6d-11ea-12e9-7b1b7f9e9983
size(cat_img)[2]

# ╔═╡ 61078c0e-ef58-11ea-1315-8b62ab89b6d6
img = imresize(cat_img, (300, 400))

# ╔═╡ 11cec638-f530-11ea-120b-3d021a055733
md"## Functions for convolving"

# ╔═╡ 28d671a0-f530-11ea-068a-d30d1015f1fe
begin
	
function get_center((height, width))
	return (convert(Int64, ceil(height / 2)), convert(Int64, ceil(width / 2)))
end

function get_padded_image(im, kernel_sz)
	im_ht = size(im)[1]
	im_wd = size(im)[2]
	
	add_ht = kernel_sz[1] - 1
	add_wd = kernel_sz[2] - 1
	
	padded_im = ones(Float64, (im_ht + add_ht, im_wd + add_wd))
	kern_center = get_center(kernel_sz)
	
	first_h = kern_center[1]
	last_h = first_h + im_ht - 1 
		
	first_w = kern_center[2]
	last_w = first_w + im_wd - 1
		
	padded_im[first_h:last_h, first_w:last_w] = im
	return padded_im
end
	
function convolve_at(padded_im, kernel, pos)
	first_h = pos[1]
	last_h = first_h + size(kernel)[1] - 1
	
	first_w = pos[2]
	last_w = first_w + size(kernel)[2] - 1
		
	return sum(padded_im[first_h:last_h, first_w:last_w] .* kernel)
end

function convolute_images(img, kernel)
	padded_img = get_padded_image(img, size(kernel))
	ret_img = zeros(Float64, size(img))
		
	for row in 1:size(ret_img)[1]
		for col in 1:size(ret_img)[2]
			ret_img[row, col] = convolve_at(padded_img, kernel, (row, col))
		end
	end
	return ret_img
end
	
end

# ╔═╡ a74bea3a-f5bf-11ea-2056-8b14c4654cec
md"## Functions for dealing with color images"

# ╔═╡ 68e5142a-f5be-11ea-04a6-d71f5aeec015
begin
	function get_red(color)
		return color.r
	end

	function get_green(color)
		return color.g
	end

	function get_blue(color)
		return color.b
	end

	function combine_colors(r, g, b)
		return RGB(r, g, b)
	end

	function get_RGB_components(img)
		return (get_red.(img), get_green.(img), get_blue.(img))
	end


	function convolve_main(img, kernel)
		(r_comp, g_comp, b_comp) = get_RGB_components(img)

		r_conv = convolute_images(r_comp, kernel)
		g_conv = convolute_images(g_comp, kernel)
		b_conv = convolute_images(b_comp, kernel)
		return combine_colors.(r_conv, g_conv, b_conv)
	end
end

# ╔═╡ 3b436ac0-fd80-11ea-23e1-6131fbc1a566
color = RGBX(0.2, 0.4, 0.5)

# ╔═╡ 418b1a72-fd80-11ea-3943-b56d2592ce72
get_red(color)

# ╔═╡ ed40907c-fd67-11ea-0989-57c037020d50
md"## Blurring Images"

# ╔═╡ f9fe2c3e-fd67-11ea-0fb5-09a5f6a16ff3
function blur(n)
	return ones(Float64, n, n) / n^2 
end	

# ╔═╡ f3f624e4-fd81-11ea-0071-f34fe9bcbbdb
convolve_main(img, blur(blur_factor))

# ╔═╡ 1bc335c6-fd68-11ea-26eb-0b4f51bc5a5b
md"## Detecting Edges"

# ╔═╡ 21c2dfbc-fd68-11ea-034b-1946e229cca1
md"### Edge detecting kernels"

# ╔═╡ 3b2372f0-fd68-11ea-232c-b16e39d911e2
E1 =  [-1.0 -1.0 -1.0; -1.0 8.0 -1.0; -1.0 -1.0 -1.0]

# ╔═╡ 49b5eb6a-fd68-11ea-31ca-a1d8c7092bbc
# Sobel Edge Detection Kernel 
E2 = [1 0 -1; 2 0 -2; 1 0 -1]

# ╔═╡ 0216acb8-f5c1-11ea-34d1-bb5c9badad06
convolve_main(img, E1)

# ╔═╡ edb45cea-fd6d-11ea-1a10-c34dfb03cd6b
convolve_main(img, E2)

# ╔═╡ 7087cba8-fd6d-11ea-1bb0-f3194deb8bca
md"## Sharpening Images"

# ╔═╡ 7d1d0284-fd6d-11ea-1705-a5a6c1f26685
S = [0.0 -1.0 0.0; -1.0 5.0 -1.0; 0.0 -1.0 0.0]

# ╔═╡ b5e8cc60-fd6d-11ea-19e7-87b57401eac8
convolve_main(img, S)

# ╔═╡ Cell order:
# ╟─de841902-ef55-11ea-1a4e-e93078de192d
# ╠═7eaa2560-fd85-11ea-3aaa-0142a1e78325
# ╠═8315cda2-fd85-11ea-0743-adf8c7da9360
# ╟─443b1aa4-fd69-11ea-0d56-bb3b79db391b
# ╠═c6f03756-fd67-11ea-2e7e-29d185e8ac72
# ╠═7ba28db6-fd68-11ea-00e6-a50cdd5e1c00
# ╠═cd3c51a2-fd68-11ea-1e98-2d7243725f10
# ╟─0a77b05c-fd7d-11ea-34aa-5d76e5d91164
# ╠═b93a5866-fd7c-11ea-3543-e5455a87291b
# ╠═bde55eee-fd7c-11ea-3200-f728444cbd52
# ╟─43c23d1e-fd7d-11ea-0d54-9186e498b91a
# ╠═1efc1338-fd7d-11ea-180e-87ba1b4badf1
# ╟─7af67b92-fd69-11ea-0808-d93f995c6239
# ╠═fa5707e0-fd68-11ea-12a8-abe10351c405
# ╠═c7322eea-fd69-11ea-0d75-bfa3ffcf34ea
# ╠═cf3b7a72-fd69-11ea-173d-2df17ece474e
# ╠═e467d544-fd69-11ea-3b20-0f8f3ebabc5c
# ╟─66818094-fd69-11ea-2c19-41b9631fb375
# ╠═3091922e-fd7f-11ea-19ba-f3836c82e08b
# ╟─cef8dfaa-fd6e-11ea-3e40-1d1ec66c0619
# ╟─6b8d7ee6-fd6c-11ea-0789-21fe119334ad
# ╠═04981932-ef55-11ea-0357-4b296df2880a
# ╠═4d66a14e-ef58-11ea-39e4-aff29ee497f8
# ╠═12c629c4-fd6d-11ea-1f5d-e3cac5cc838a
# ╠═2706b138-fd6d-11ea-12e9-7b1b7f9e9983
# ╠═61078c0e-ef58-11ea-1315-8b62ab89b6d6
# ╟─11cec638-f530-11ea-120b-3d021a055733
# ╠═28d671a0-f530-11ea-068a-d30d1015f1fe
# ╟─a74bea3a-f5bf-11ea-2056-8b14c4654cec
# ╠═68e5142a-f5be-11ea-04a6-d71f5aeec015
# ╠═3b436ac0-fd80-11ea-23e1-6131fbc1a566
# ╠═418b1a72-fd80-11ea-3943-b56d2592ce72
# ╟─ed40907c-fd67-11ea-0989-57c037020d50
# ╠═f9fe2c3e-fd67-11ea-0fb5-09a5f6a16ff3
# ╠═58bd8baa-fd81-11ea-1895-618702888b37
# ╠═f3f624e4-fd81-11ea-0071-f34fe9bcbbdb
# ╟─1bc335c6-fd68-11ea-26eb-0b4f51bc5a5b
# ╟─21c2dfbc-fd68-11ea-034b-1946e229cca1
# ╠═3b2372f0-fd68-11ea-232c-b16e39d911e2
# ╠═49b5eb6a-fd68-11ea-31ca-a1d8c7092bbc
# ╠═0216acb8-f5c1-11ea-34d1-bb5c9badad06
# ╠═edb45cea-fd6d-11ea-1a10-c34dfb03cd6b
# ╟─7087cba8-fd6d-11ea-1bb0-f3194deb8bca
# ╠═7d1d0284-fd6d-11ea-1705-a5a6c1f26685
# ╠═b5e8cc60-fd6d-11ea-19e7-87b57401eac8
