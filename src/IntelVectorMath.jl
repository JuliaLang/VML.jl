__precompile__()

module IntelVectorMath

export IVM
const IVM = IntelVectorMath

# import Base: .^, ./
include("setup.jl")

function __init__()
    compilersupportlibaries_jll_uuid = Base.UUID("e66e0078-7015-5450-92f7-15fbd957f2ae")
    if Sys.isapple() && haskey(Base.loaded_modules, Base.PkgId(compilersupportlibaries_jll_uuid, "CompilerSupportLibraries_jll"))
        @warn "It appears CompilerSupportLibraries_jll was loaded prior to this package, which currently on mac may lead to wrong results in some cases. For further details see github.com/JuliaMath/IntelVectorMath.jl"
    end
end

for t in (Float32, Float64, ComplexF32, ComplexF64)
    # Unary, real or complex
    def_unary_op(t, t, :acos, :acos!, :AcosI)
    def_unary_op(t, t, :asin, :asin!, :AsinI)
    def_unary_op(t, t, :acosh, :acosh!, :AcoshI)
    def_unary_op(t, t, :asinh, :asinh!, :AsinhI)
    def_unary_op(t, t, :sqrt, :sqrt!, :SqrtI)
    def_unary_op(t, t, :exp, :exp!, :ExpI)
    def_unary_op(t, t, :log, :log!, :LnI)

    # # Binary, real or complex
    def_binary_op(t, t, :pow, :pow!, :PowI, true)
    def_binary_op(t, t, :divide, :divide!, :DivI, true)
end

for t in (Float32, Float64)
    # Unary, real-only
    def_unary_op(t, t, :cbrt, :cbrt!, :CbrtI)
    def_unary_op(t, t, :expm1, :expm1!, :Expm1I)
    def_unary_op(t, t, :log1p, :log1p!, :Log1pI)
    def_unary_op(t, t, :abs, :abs!, :AbsI)
    def_unary_op(t, t, :abs2, :abs2!, :SqrI)
    def_unary_op(t, t, :ceil, :ceil!, :CeilI)
    def_unary_op(t, t, :floor, :floor!, :FloorI)
    def_unary_op(t, t, :round, :round!, :RoundI)
    def_unary_op(t, t, :trunc, :trunc!, :TruncI)

    # now in SpecialFunctions (make smart, maybe?)
    def_unary_op(t, t, :erf, :erf!, :ErfI)
    def_unary_op(t, t, :erfc, :erfc!, :ErfcI)
    def_unary_op(t, t, :erfinv, :erfinv!, :ErfInvI)
    def_unary_op(t, t, :erfcinv, :erfcinv!, :ErfcInvI)
    def_unary_op(t, t, :lgamma, :lgamma!, :LGammaI)
    def_unary_op(t, t, :gamma, :gamma!, :TGammaI)
    # Not in Base
    def_unary_op(t, t, :inv_cbrt, :inv_cbrt!, :InvCbrtI)
    def_unary_op(t, t, :inv_sqrt, :inv_sqrt!, :InvSqrtI)
    def_unary_op(t, t, :pow2o3, :pow2o3!, :Pow2o3I)
    def_unary_op(t, t, :pow3o2, :pow3o2!, :Pow3o2I)

    # Enabled only for Real. MKL guarantees higher accuracy, but at a
    # substantial performance cost.
    def_unary_op(t, t, :atan, :atan!, :AtanI)
    def_unary_op(t, t, :cos, :cos!, :CosI)
    def_unary_op(t, t, :sin, :sin!, :SinI)
    def_unary_op(t, t, :tan, :tan!, :TanI)
    def_unary_op(t, t, :atanh, :atanh!, :AtanhI)
    def_unary_op(t, t, :cosh, :cosh!, :CoshI)
    def_unary_op(t, t, :sinh, :sinh!, :SinhI)
    def_unary_op(t, t, :tanh, :tanh!, :TanhI)
    def_unary_op(t, t, :log10, :log10!, :Log10I)

    # # .^ to scalar power
    # mklfn = Base.Meta.quot(Symbol("$(vml_prefix(t))Powx"))
    # @eval begin
    #     export pow!
    #     function pow!{N}(out::Array{$t,N}, A::Array{$t,N}, b::$t)
    #         size(out) == size(A) || throw(DimensionMismatch())
    #         ccall(($mklfn, lib), Nothing, (Int, Ptr{$t}, $t, Ptr{$t}), length(A), A, b, out)
    #         vml_check_error()
    #         out
    #     end
    #     function (.^){N}(A::Array{$t,N}, b::$t)
    #         out = similar(A)
    #         ccall(($mklfn, lib), Nothing, (Int, Ptr{$t}, $t, Ptr{$t}), length(A), A, b, out)
    #         vml_check_error()
    #         out
    #     end
    # end

    # # Binary, real-only
    def_binary_op(t, t, :atan, :atan!, :Atan2I, false)
    def_binary_op(t, t, :hypot, :hypot!, :HypotI, false)

    # Unary, complex-only
    def_unary_op(Complex{t}, Complex{t}, :conj, :conj!, :ConjI)
    def_unary_op(Complex{t}, t, :abs, :abs!, :AbsI)
    def_unary_op(Complex{t}, t, :angle, :angle!, :ArgI)

    ### cis is special, IntelVectorMath function is based on output
    def_unary_op(t, Complex{t}, :cis, :cis!, :CISI; vmltype = Complex{t})

    # Binary, complex-only. These are more accurate but performance is
    # either equivalent to Base or slower.
    # def_binary_op(Complex{t}, Complex{t}, (:+), :add!, :Add, false)
    # def_binary_op(Complex{t}, Complex{t}, (:.+), :add!, :Add, true)
    # def_binary_op(Complex{t}, Complex{t}, (:.*), :multiply!, :Mul, true)
    # def_binary_op(Complex{t}, Complex{t}, (:-), :subtract!, :Sub, false)
    # def_binary_op(Complex{t}, Complex{t}, (:.-), :subtract!, :Sub, true)
    # def_binary_op(Complex{t}, Complex{t}, :multiply_conj, :multiply_conj!, :Mul, false)
end

export VML_LA, VML_HA, VML_EP, vml_set_accuracy, vml_get_accuracy

end
