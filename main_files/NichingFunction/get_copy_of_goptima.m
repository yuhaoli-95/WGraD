% ******************************************************************************
% * Version: 1.0.1
% * Last modified on: 27 October, 2016 
% * Developers: Michael G. Epitropakis, Xiaodong Li.
% *      email: m_(DOT)_epitropakis_(AT)_lancaster_(DOT)_ac_(DOT)_uk 
% *           : xiaodong_(DOT)_li_(AT)_rmit_(DOT)_edu_(DOT)_au 
% * ****************************************************************************
%ATTENTION: USE THIS FUNCTION ONLY FOR STATISTICAL PURPOSES
%TODO: Accuracy of the optima positions might vary per function.
%The function returns a number_of_global_optima x number_of_dimension matrix
%each row contains a different optimum position
function [o] = get_copy_of_goptima(nfunc)
total_func_no = 20;

% if nfunc > 10 & nfunc <= total_func_no
% 	load data/optima.mat; % saved the predefined optima, a 10*100 matrix;
% 	D = get_dimension(nfunc);
% 	o = o(:,1:D);
% 	return;
% end
%11 
if nfunc == 1	    fname = 'data/F1_opt.dat';
elseif nfunc == 2	fname = 'data/F2_opt.dat';
elseif nfunc == 3	fname = 'data/F3_opt.dat';
elseif nfunc == 4	fname = 'data/F4_opt.dat';
elseif nfunc == 5	fname = 'data/F5_opt.dat';
elseif nfunc == 6	fname = 'data/F6_2D_opt.dat';
elseif nfunc == 7	fname = 'data/F7_2D_opt.dat';
elseif nfunc == 8	fname = 'data/Copy_of_F6_3D_opt.dat';%%%%%%%%%%%F6_3D_opt
elseif nfunc == 9	fname = 'data/F7_3D_opt.dat';
elseif nfunc == 10	fname = 'data/F8_2D_opt.dat';%10 F8(2D)
elseif nfunc == 11	fname = 'data/CF1_M_D2_opt.dat';%11 F9(2D) F9: Composition function 1 (2D).
elseif nfunc == 12	fname = 'data/CF2_M_D2_opt.dat';%12 F10(2D) F10: Composition function 2 (2D).
elseif nfunc == 13	fname = 'data/CF3_M_D2_opt.dat';%13 F11(2D) F11: Composition function 3 (2D, 3D, 5D, 10D).
elseif nfunc == 14	fname = 'data/CF3_M_D3_opt.dat';%14 F11(3D) 
elseif nfunc == 15	fname = 'data/CF4_M_D3_opt.dat';%15 F12(3D) F12: Composition function 4 (3D, 5D, 10D, 20D).
elseif nfunc == 16	fname = 'data/CF3_M_D5_opt.dat';%16 F11(5D) F11: Composition function 3 (2D, 3D, 5D, 10D).
elseif nfunc == 17	fname = 'data/CF4_M_D5_opt.dat';%17 F12(5D) F12: Composition function 4 (3D, 5D, 10D, 20D).
elseif nfunc == 18	fname = 'data/CF3_M_D10_opt.dat';%18 F11(10D) F11: Composition function 3 (2D, 3D, 5D, 10D).
elseif nfunc == 19	fname = 'data/CF4_M_D10_opt.dat';%19 F12(10D) F12: Composition function 4 (3D, 5D, 10D, 20D).
elseif nfunc == 20	fname = 'data/CF4_M_D20_opt.dat';%20 F12(20D) F12: Composition function 4 (3D, 5D, 10D, 20D).
else
	fprintf('ERROR: Wrong function number: (%d).\n', nfunc);
	fprintf('       Please provide a function number in {1,2,...,%d}\n', total_func_no);
	fprintf('       For now function number == 1\n');
	fname = '';
end

o = load(fname); % saved the predefined optima
