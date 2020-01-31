module minimalFreezingExample
  using Distributed, FFTW
  export createSeveralRemotes, createFFTPlans
  function createSeveralRemotes(k, sizeToMake)
      FFTs = Array{Future,2}(undef, nworkers(), k)
      for i=1:nworkers(), j=1:k
          FFTs[i, j] = remotecall(makeRemoteArray, i, sizeToMake)
      end
      return FFTs
  end
  function makeRemoteArray(sizeToMake)
      return randn(sizeToMake)
  end


  function createFFTPlans(m,n, dataSizes;
                        verbose=false, iscomplex::Bool = false) where {N}
    nPlans = 1
    FFTs = Array{Future,2}(undef, nworkers(), m+1)
    for i=1:nworkers(), j=1:m+1
        if verbose
            println("i=$(i), j=$(j)")
        end
        if length(n) >= 2
            FFTs[i, j] = remotecall(createRemoteFFTPlan, i,
                                    dataSizes[j],
                                    iscomplex, nPlans)
        else
            fftPlanSize = (dataSizes[j][1]*2, dataSizes[j][3:end]...)
            FFTs[i, j] = remotecall(createRemoteFFTPlan, i, fftPlanSize,
                                    iscomplex, nPlans)
        end
    end

    return FFTs
end


function createRemoteFFTPlan(sizeOfArray, iscomplex, nPlans::Int)
    if nPlans==1
        return plan_rfft(zeros(sizeOfArray...), (1,), flags =
                         FFTW.PATIENT)
    elseif nPlans==2
        return (plan_rfft(zeros(T, sizeOfArray...), (1,), flags =
                          FFTW.PATIENT),
                plan_fft!(zeros(sizeOfArray...), (1,), flags =
                         FFTW.PATIENT))
    end
end

end
