### A Pluto.jl notebook ###
# v0.11.12

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

# ╔═╡ Cell order:
# ╟─de841902-ef55-11ea-1a4e-e93078de192d
# ╠═9e91cd90-ef54-11ea-2248-ed084c83f4a8
# ╠═42648740-ef56-11ea-3da5-af2fb6948027
# ╠═04981932-ef55-11ea-0357-4b296df2880a
# ╠═4d66a14e-ef58-11ea-39e4-aff29ee497f8
# ╠═61078c0e-ef58-11ea-1315-8b62ab89b6d6
