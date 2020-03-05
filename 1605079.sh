#!/bin/bash

input_file=
working_dir=

if [ $# -eq 0 ]; then
    echo "Please run the script as : bash 1605079.sh working_dir(optional) input_file_name.txt"
elif [ $# -eq 2 ];then

    if file $2 | grep directory; then
        echo "Please run the script as : bash 1605079.sh working_dir(optional) input_file_name.txt"
    else 
        working_dir_full_path="$(realpath $1)"
        working_dir=$1
        input_file=$2
    fi
    
elif [ $# -eq 1 ]; then

    if file "$1" | grep text ; then 
        input_file=$1
        root="$(realpath .)"
        echo $root
        base_root="${root##*/}"
        remove_from_root="${root%/*$base_root}"
        working_dir=.
        echo $working_dir
        is_rootwd="yes"
    else
        echo "Please run the script as : bash 1605079.sh working_dir(optional) input_file_name.txt"
    fi
fi

   

#echo $working_dir_full_path 

#making an output directory
mkdir ./output_dir
output_dir="$(realpath output_dir)"
#echo $output_dir


if [ ! -z "$input_file" ]
then
    if [ -f $input_file ]; then
    #echo "Input file exist"
    start_from=$(head -n 1 $input_file)
    lines_to_look=$(head -n 2 $input_file | tail -n 1)
    word_to_look=$(tail -n 1 $input_file)
    echo $word_to_look
    #echo $lines_to_look
    #echo $start_from
else 
    echo "Please give a valid input file name"
fi

#this variable will count the total number of matched file
total_matched_file=0

#making a CSV file
csv="$(realpath ../output.csv)"
echo File Path,Line Number,Line Containing Searched String>"$csv"



#look_up_directories $working_dir




#a method to travserse the directory and match the given string
#The first parameter will be the working directory upon which we will lookup the files 
f(){
    for dir in "$1"/*
    do

        if [ -d "$dir" ]; then 
            #echo is a folder $dir 
            #echo ekhane
            f "$dir" 
            #echo here
        elif [ -f "$dir" ]; then 
                #echo $dir 

             if file "$dir" | grep -qEi -- 'ASCII|Unicode'; then 
                        #echo $dir is an ASCII file
                        #echo $dir

                if [ $start_from = "begin" ]; then 
                            #echo from begin
                            if head -n $lines_to_look "$dir" | grep -qi $word_to_look; then
                                #echo found in $dir

                                ((total_matched_file = total_matched_file + 1))
                                
                                #finding the line no from the beginning---------------------------------
                                found_in=`grep -ni $word_to_look "$dir" | cut -d':' -f 1 | head -n 1`

                                #finding the line itself from the beginning
                                #line_containing_word=`grep -i $word_to_look "$dir" | head -n 1`
                                #echo 
                                #echo line containing the word is $line_containing_word

                                #modifying the file name------------------------------------------------
                                if [ "$is_rootwd" = "yes" ];then

                                    file_path_before_edit=$dir
                                    temp="${dir#\.}"
                                    dir=${base_root}${temp}
                                    echo $dir
                                fi

                                
                                #echo $file_name
                                extension="${dir##*.}"

                                if echo $extension | grep -q \/; then 
                                    echo no extension
                                    echo $dir
                                    #echo $file_name
                                    #echo woext $file_name

                                    mod_f_name="${dir//\//.}"
                                    #echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}
                                    echo $new_f_name 
                                else 
                                    echo extension is $extension

                                    file_name_woext="${dir%.*}"
                                    echo woext $file_name_woext

                                    mod_f_name="${file_name_woext//\//.}"
                                    echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}.${extension}
                                    echo $new_f_name 
                                fi

                                #writing to the directory-------------------------------------------------
                                echo writing to the output $new_f_name
                                if [ "$is_rootwd" = "yes" ];then
                                    cp "$file_path_before_edit" "$output_dir/${new_f_name}"
                                else 
                                    cp "$dir" "$output_dir/${new_f_name}"
                                fi


                                #Writing to the CSV file
                                #echo $dir,$found_in,$line_containing_word>>output.csv
                                
                                echo found in line no: $found_in 
                           
                            fi

                elif [ $start_from = "end" ]; then 
                            echo from end
                            if tail -n $lines_to_look "$dir" | grep -qi $word_to_look; then
                                echo found in $dir

                                ((total_matched_file = total_matched_file + 1))

                                found_in=`grep -ni $word_to_look "$dir" | cut -d':' -f 1 | tail -n 1`

                                #finding the line itself from the beginning
                                line_containing_word=`grep -i $word_to_look "$dir" | head -n 1`
                                echo 
                                echo line containing the word is $line_containing_word

                                #new_name=$((found_from_back)).pappa

                                #echo found in $((found_from_back)).pappa
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
                                    #echo $new_f_name 
                                fi

                                #writing to the directory-------------------------------------------------
                                #cp "$dir" "$output_dir/${new_f_name}"
                                if [ "$is_rootwd" = "yes" ];then
                                    cp "$file_path_before_edit" "$output_dir/${new_f_name}"
                                else 
                                    cp "$dir" "$output_dir/${new_f_name}"
                                fi


                                 #Writing to the CSV file
                                #echo $dir,$found_in,$line_containing_word>>output.csv
                            fi
                        fi
                fi
            fi
    done    
}

f $working_dir



#browse_dir $working_dir



echo Total Number of matched file: $total_matched_file
fi


