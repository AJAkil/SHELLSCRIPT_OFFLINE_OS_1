elif [ $start_from = "end" ]; then 
                            #echo from end
                            if tail -n $lines_to_look "$dir" | grep -qi $word_to_look; then
                                #echo found in $dir

                                ((total_matched_file = total_matched_file + 1))

                                found_in=`grep -ni $word_to_look "$dir" | cut -d':' -f 1 | tail -n 1`

                                #finding the line itself from the beginning
                                line_containing_word=`grep -i $word_to_look "$dir" | head -n 1`
                               # echo 
                                #echo line containing the word is $line_containing_word

                                #echo $new_name
                                

                                #actual_line_no=$((total_line_no - lines_to_look + found_from_back))

                                #echo found on line no $actual_line_no

                                #modifying the file name------------------------------------------------

                                if [ "$is_rootwd" = "yes" ];then
                                     file_path_before_edit=$dir
                                    temp="${dir#\.}"
                                    dir=${base_root}${temp}
                                fi

                                #echo $file_name
                                extension="${dir##*.}"

                                if echo $extension | grep -q \/; then 
                                    #echo no extension
                                    #echo $file_name
                                    #echo woext $file_name

                                    mod_f_name="${dir//\//.}"
                                    #echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}
                                    #echo $new_f_name 
                                else 
                                    #echo extension is $extension

                                    file_name_woext="${dir%.*}"
                                    #echo woext $file_name_woext

                                    mod_f_name="${file_name_woext//\//.}"
                                    #echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}.${extension}
                                    echo $new_f_name 
                                fi

                                #writing to the directory-------------------------------------------------
                                if [ "$is_rootwd" = "yes" ];then
                                    cp "$file_path_before_edit" "$output_dir/${new_f_name}"
                                else 
                                    echo abnormal
                                    cp "$dir" "$output_dir/${new_f_name}"
                                fi


                               #Writing to the CSV file
                                if [ "$is_rootwd" = "yes" ];then

                                    file_to_extract="${dir#*/}"
                                else
                                    file_to_extract=$dir
                                fi
                                
                                #echo the file to extract is $file_to_extract
                                tail -n $lines_to_look "$file_to_extract" | grep -ni $word_to_look> temp.txt
                                temp=temp.txt
                                while IFS= read -r line
                                do
                                echo the line is "$line"
                                csv_line="${line#*:}"
                                #echo $csv_line
                                
                                line_no="${line%%:*}"
                                echo $line_no
                                t=`wc -l "$file_to_extract" | cut -d' ' -f 1`
                                echo $t
                                if [ "$t" -gt "$lines_to_look" ]; then 
                                    ((t = t - lines_to_look))
                                    echo $t
                                    ((t = t + line_no))
                                    req_line_no=$t
                                    echo $total_line_no
                                else 
                                    req_line_no=$line_no
                                fi 
                                echo chame diye asho
                                
                                echo $dir,$req_line_no,$csv_line>>"$csv"
                                done < "$temp"
                                rm temp.txt
                                #echo $dir,$found_in,$line_containing_word>>output.csv
                            fi
                        fi