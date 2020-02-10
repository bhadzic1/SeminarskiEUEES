@time begin
using CSV
using DataFrames
using SparseArrays
using LinearAlgebra
using Random
using HTTP

include("inputs.jl")
include("calculation.jl")
include("FullNR.jl")
include("SplitNR.jl")
include("TokoviSnage.jl")

Path="C:/" #Upisi path za ispis FullNR
#Path1="C:/" #Upisi path za ispis FastNR
Bazna=100

sysBus = Matrix{Float64}(CSV.read((HTTP.get("https://raw.githubusercontent.com/bhadzic1/SeminarskiEUEES/master/Data/BusData.csv")).body))#Upisi path filea
sysLin = Matrix{Float64}(CSV.read((HTTP.get("https://raw.githubusercontent.com/bhadzic1/SeminarskiEUEES/master/Data/LineData.csv")).body))#upisi path filea
Tau1, U1, Brzina1=FullNR(sysBus,sysLin, Bazna )
# Tau2, U2, Brzina2=SplitNR(sysBus,sysLin, Bazna)
#Rez3=FastNR(sysBus,sysLin, Bazna) treba implementirati brzi razdvojeni NR, problem  B''
Proizvodnja1, Tok1=TokoviSnageAC(sysBus,sysLin,U1,Tau1,Bazna, Path)
# Proizvodnja2, Tok2=TokoviSnageAC(sysBus,sysLin,U2,Tau2,Bazna, Path1)
end
