using CSV
using DataFrames
using SparseArrays
using LinearAlgebra
using Random

include("inputs.jl")
include("calculation.jl")
include("FullNR.jl")
include("SplitNR.jl")
include("TokoviSnage.jl")

path="D:/Fakultet/EUEES"
Bazna=100
sysBus = Matrix{Float64}(CSV.read("C:/Users/hadzi/github/SeminarskiEUEES/Data/BusData.csv"))
sysLin = Matrix{Float64}(CSV.read("C:/Users/hadzi/github/SeminarskiEUEES/Data/LineData.csv"))
Tau1, U1=FullNR(sysBus,sysLin, Bazna )
Tau2, U2=SplitNR(sysBus,sysLin, Bazna)
#Rez3=FastNR(sysBus,sysLin, Bazna) treba implementirati brzi razdvojeni NR, problem  B''
Proizvodnja, Tok=TokoviSnageAC(sysBus,sysLin,U1,Tau1,Bazna, path)
