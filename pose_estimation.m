function [pose_mat] = pose_estimation(points3D,pointsImage,K)

    P_mat = compute_projection_matrix(points3D, pointsImage);
    
    %normalizando matriz P fazendo a ultima linha de tamanho unitário
    norm_  = norm(P_mat(3,1:3));
    P_mat = P_mat/norm_;
    
    %pegando a matriz 3x3 mais a esquerda
    M = P_mat(1:3,1:3);
    
    %Estimando a matriz de câmera K e a matriz de rotação R usando decomposição RQ
    [K,R] = rq3(inv(M));
    K = inv(K);   
    R = R';
    
    %Computando a matriz de rotção 
    %Matriz de rotação no eixo z
    theta = atan(P_mat(3,1)/P_mat(3,2));
    Rzth =[cos(theta) sin(theta) 0;-sin(theta) cos(theta) 0;0 0 1];
    %Matriz de rotação no eixo x
    aux = M*Rzth; 
    betha = atan(aux(3,2)/aux(3,3));
    Rxbt = [1 0 0;0 cos(betha) sin(betha);0 -sin(betha) cos(betha)];
    %Matriz de rotação no eixo Y
    aux1 = M*Rzth*Rxbt;
    sigma = atan(aux1(2,1)/aux1(2,2));
    Rysig = [cos(sigma) 0 sin(sigma);0 1 0;-sin(sigma) 0 cos(sigma)];
    %Matriz de rotação completa
    R_l = Rxbt*Rysig*Rzth;
    %computando o vetor de translação
    t = -(R'*inv(K)*[P_mat(1,4);P_mat(2,4);P_mat(3,4)]);
    %construindo a matriz de pose
    pose_mat = horzcat(R_l,t)
        
end

