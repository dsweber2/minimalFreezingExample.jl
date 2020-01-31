module minimalFreezingExample
  using Distributed, FFTW
  export createFFTPlans

  function createFFTPlans(m, dataSizes;
                        verbose=false, iscomplex::Bool = false)
    FFTs = Array{Future, 2}(undef, nworkers(), m)
    for i=1:nworkers(), j=1:m
        println("i=$(i), j=$(j)")
        FFTs[i, j] = remotecall(createRemoteFFTPlan, i, dataSizes[j])
    end

    return FFTs
end


function createRemoteFFTPlan(sizeOfArray)
    return plan_rfft(zeros(sizeOfArray...), (1,), flags =
                     FFTW.PATIENT)
end

end
