function c = nxcorr2 (a, b)
  if (nargin != 2)
    print_usage ();
  endif

  ## If this happens, it is probably a mistake
  if (ndims (a) > ndims (b) || any (postpad (size (a), ndims (b)) > size (b)))
    warning ("normxcorr2: TEMPLATE larger than IMG. Arguments may be swapped.");
  endif

  a = double (a) - mean (a(:));
  b = double (b) - mean (b(:));

  a1 = ones (size (a));
  ar = reshape (a(end:-1:1), size (a));

  c = convn (b, conj (ar));
  b = convn (b.^2, a1) .- convn (b, a1).^2 ./ (prod (size (a)));
  a = sumsq (a(:));
  c = reshape (c ./ sqrt (b * a), size (c));

  c(isnan (c)) = 0;
endfunction