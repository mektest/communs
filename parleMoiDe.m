%
% Gestion des erreurs dans les  try-catch
%
function parleMoiDe(CELA)
  disp(CELA.identifier)
  disp(CELA.message)
  for V =1:length(CELA.stack)
    disp(CELA.stack(V))
  end
  disp(CELA.cause)
end
