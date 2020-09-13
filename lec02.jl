### A Pluto.jl notebook ###
# v0.11.14

using Markdown
using InteractiveUtils

# ╔═╡ 9e91cd90-ef54-11ea-2248-ed084c83f4a8
begin
	using Plots
	using DSP
	using PlutoUI
	using FFTW
	using Statistics
	using Images
	using ImageFeatures
	using ImageMagick
end

# ╔═╡ de841902-ef55-11ea-1a4e-e93078de192d
md"# Lecture 2 

### Convoluting Images
"

# ╔═╡ 42648740-ef56-11ea-3da5-af2fb6948027
pwd()

# ╔═╡ 04981932-ef55-11ea-0357-4b296df2880a
begin
	cat_img = load("cat.jpg")
end

# ╔═╡ 4d66a14e-ef58-11ea-39e4-aff29ee497f8
size(cat_img)

# ╔═╡ 61078c0e-ef58-11ea-1315-8b62ab89b6d6
img = imresize(cat_img, (300, 400))

# ╔═╡ 11cec638-f530-11ea-120b-3d021a055733
md"## Functions for convolving"

# ╔═╡ 28d671a0-f530-11ea-068a-d30d1015f1fe
begin
	
function get_center((height, width)::Tuple{Int64, Int64})
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

function convolute_images(im, kernel)
	padded_im = get_padded_image(im, size(kernel))
	ret_im = zeros(Float64, size(im))
		
	for row in 1:size(ret_im)[1]
		for col in 1:size(ret_im)[2]
			ret_im[row, col] = convolve_at(padded_im, kernel, (row, col))
		end
	end
	return ret_im
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

	function blur(n)
		return ones(Float64, n, n) / n^2 
	end	

	function convolve_main(img, kernel)
		(r_comp, g_comp, b_comp) = get_RGB_components(img)

		r_conv = convolute_images(r_comp, kernel)
		g_conv = convolute_images(g_comp, kernel)
		b_conv = convolute_images(b_comp, kernel)
		return combine_colors.(r_conv, g_conv, b_conv)
	end
end

# ╔═╡ f54c06d0-f5be-11ea-188a-5549c5893571
convolve_main(img, blur(10))

# ╔═╡ 0216acb8-f5c1-11ea-34d1-bb5c9badad06
begin
	edge_detect = [-1.0 -1.0 -1.0; -1.0 8.0 -1.0; -1.0 -1.0 -1.0]
	convolve_main(img, edge_detect)
end

# ╔═╡ Cell order:
# ╟─de841902-ef55-11ea-1a4e-e93078de192d
# ╠═9e91cd90-ef54-11ea-2248-ed084c83f4a8
# ╠═42648740-ef56-11ea-3da5-af2fb6948027
# ╠═04981932-ef55-11ea-0357-4b296df2880a
# ╠═4d66a14e-ef58-11ea-39e4-aff29ee497f8
# ╠═61078c0e-ef58-11ea-1315-8b62ab89b6d6
# ╟─11cec638-f530-11ea-120b-3d021a055733
# ╠═28d671a0-f530-11ea-068a-d30d1015f1fe
# ╟─a74bea3a-f5bf-11ea-2056-8b14c4654cec
# ╠═68e5142a-f5be-11ea-04a6-d71f5aeec015
# ╠═f54c06d0-f5be-11ea-188a-5549c5893571
# ╠═0216acb8-f5c1-11ea-34d1-bb5c9badad06
