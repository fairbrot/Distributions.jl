immutable TDist <: ContinuousUnivariateDistribution
    df::Float64

    function TDist(d::Real)
    	d > zero(d) || error("TDist: df must be positive")
        new(float64(d))
    end
end

@_jl_dist_1p TDist t

@distr_support TDist -Inf Inf


#### Parameters

dof(d::TDist) = d.df
params(d::TDist) = (d.df,)


#### Statistics

mean(d::TDist) = d.df > 1.0 ? 0.0 : NaN
median(d::TDist) = 0.0
mode(d::TDist) = 0.0

function var(d::TDist)
    df = d.df
    df > 2.0 ? df / (df - 2.0) :
    df > 1.0 ? Inf : NaN
end

skewness(d::TDist) = d.df > 3.0 ? 0.0 : NaN

function kurtosis(d::TDist)
    df = d.df
    df > 4.0 ? 6.0 / (df - 4.0) :
    df > 2.0 ? Inf : NaN
end

function entropy(d::TDist)
    hdf = 0.5 * d.df
    hdfph = hdf + 0.5
    hdfph * (digamma(hdfph) - digamma(hdf)) + 0.5 * log(d.df) + lbeta(hdf,0.5)
end


#### Evaluation

gradlogpdf(d::TDist, x::Float64) = -((d.df + 1.0) * x) / (x^2 + d.df)

