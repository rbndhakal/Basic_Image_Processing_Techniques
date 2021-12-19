location = input('Enter image dataset location.\n', 's');
ds = imageDatastore(location);

while hasdata(ds)   
    input('Enter a keyboard input.\n','s');
    Ima = imread('Reference.JPG');
    Imb = read(ds);
    
    Imag = im2single(rgb2gray(Ima)) ;
    Imbg = im2single(rgb2gray(Imb)) ;
    
    [fa,da] = vl_sift(Imag) ;
    [fb,db] = vl_sift(Imbg) ;

    [matches, scores] = vl_ubcmatch(da,db) ;

     numMatch = size(matches,2) ;

     X1 = fa(1:2,matches(1,:)) ; X1(3,:) = 1 ;
     X2 = fb(1:2,matches(2,:)) ; X2(3,:) = 1 ;

    clear H score ok ;
    for t = 1:100
      subset = vl_colsubset(1:numMatch, 4) ;
      A = [] ;
      for i = subset
        A = cat(1, A, kron(X1(:,i)', vl_hat(X2(:,i)))) ;
      end
      [U,S,V] = svd(A) ;
      H{t} = reshape(V(:,9),3,3) ;
      X2_ = H{t} * X1 ;
      du = X2_(1,:)./X2_(3,:) - X2(1,:)./X2(3,:) ;
      dv = X2_(2,:)./X2_(3,:) - X2(2,:)./X2(3,:) ;
      ok{t} = (du.*du + dv.*dv) < 6*6 ;
      score(t) = sum(ok{t}) ;
    end

    [score, best] = max(score) ;
    H = H{best} ;
    ok = ok{best} ;

    dha = max(size(Imb,1)-size(Ima,1),0) ;
    dhb = max(size(Ima,1)-size(Imb,1),0) ;

    figure(1) ; clf ;
    subplot(2,1,1) ;
    imagesc([padarray(Ima,dha,'post') padarray(Imb,dhb,'post')]) ;
    o = size(Ima,2) ;
    line([fa(1,matches(1,:));fb(1,matches(2,:))+o], ...
         [fa(2,matches(1,:));fb(2,matches(2,:))]) ;
    title(sprintf('%d tentative matches', numMatch)) ;
    axis image off ;

    subplot(2,1,2) ;
    imagesc([padarray(Ima,dha,'post') padarray(Imb,dhb,'post')]) ;
    o = size(Ima,2) ;
    line([fa(1,matches(1,ok));fb(1,matches(2,ok))+o], ...
         [fa(2,matches(1,ok));fb(2,matches(2,ok))]) ;
    title(sprintf('%d (%.2f%%) inliner matches out of %d', ...
                  sum(ok), ...
                  100*sum(ok)/numMatch, ...
                  numMatch)) ;
    axis image off ;
    drawnow ;

end

