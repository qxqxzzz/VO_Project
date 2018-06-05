function [h_mat] = compute_homogra(P,p)
    
    nr_points = 8;
    
    for i=1:nr_points
        Px_h = P(i,1)/P(i,3);
        Py_h = P(i,2)/P(i,3);
        A(2*i-1,:) = [Px_h,Py_h,1,0,0,0,-Px_h*p(i,1),-p(i,1)*Py_h,-p(i,1)];
        A(2*i, :)  = [0,0,0,Px_h,Py_h,1,-Px_h*p(i,2),-p(i,2)*Py_h,-p(i,2)];       
    end
    
    [U,S,V] = svd(A);
    
    h = V(:,9);
    
    h_mat = reshape(h,[3,3]);
    
end
    
