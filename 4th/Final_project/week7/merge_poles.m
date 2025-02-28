function [merged_poles, merged_residues] = merge_poles(merged_poles, merged_residues, new_poles, new_residues, tolerance)
    % Check for duplicate poles (within tolerance)
    for i = 1:length(new_poles)
        is_duplicate = false;
        for j = 1:length(merged_poles)
            if abs(new_poles(i) - merged_poles(j)) < tolerance
                is_duplicate = true;
                break;
            end
        end
        if ~is_duplicate
            merged_poles = [merged_poles; new_poles(i)];
            merged_residues = [merged_residues; new_residues(i)];
        end
    end
end