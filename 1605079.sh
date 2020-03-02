#!/bin/bash

if [ $# -eq 0 ]; then
    echo "Please run the script as : working_dir(optional) file_name"
elif [ $# -eq 2 ];then
    working_dir_full_path="$(realpath $1)"
    working_dir=$1
    input_file=$2
elif [ $# -eq 1 ]; then
    input_file=$1
    working_dir="$(realpath .)" #to be handled
fi

echo $working_dir_full_path 

#making an output directory
#mkdir ./output_dir
output_dir="$(realpath )"

if [ -f $input_file ]; then
    echo "Input file exist"
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

#a method to travserse the directory and match the given string
#The first parameter will be the working directory upon which we will lookup the files 
look_up_directories(){
    cd "$1"
        for dir in *
            do
                if [ -d "$dir" ];then
                    #echo $dir is a directory 
                    look_up_directories "$dir" #recursive call
                elif [ -f "$dir" ];then
                    #do processing of the files and copy the files to the output_dir
                    #firstly check if the file is a text file or not, if it is a text file
                    #extract the string and process the text file
                    #echo $dir is a file
                    if file "$dir" | grep -qEi -- 'ASCII|Unicode'; then 
                        #echo $dir is an ASCII file

                        # now check for the pattern of the file
                        
                        #calculating the total line no first
                        total_line_no=`cat "$dir" | wc -l`
                        #echo $((total_line_no))

                        if [ $start_from = "begin" ]; then 
                            echo from begin
                            if head -n $lines_to_look $dir | grep -qi $word_to_look; then
                                echo found in $dir

                                ((total_matched_file = total_matched_file + 1))
                                
                                #finding the line no from the beginning---------------------------------
                                found_in=`grep -ni $word_to_look $dir | cut -d':' -f 1 | head -n 1`

                                #modifying the file name------------------------------------------------

                                file_name=`realpath $dir`
                                #echo $file_name
                                extension="${file_name##*.}"

                                if echo $extension | grep -q \/; then 
                                    #echo no extension
                                    #echo $file_name
                                    #echo woext $file_name

                                    mod_f_name="${file_name//\//.}"
                                    #echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}
                                    #echo $new_f_name 
                                else 
                                    #echo extension is $extension

                                    file_name_woext="${file_name%.*}"
                                    #echo woext $file_name_woext

                                    mod_f_name="${file_name_woext//\//.}"
                                    #echo $mod_f_name

                                    new_f_name=${mod_f_name}${found_in}.${extension}
                                    #echo $new_f_name 
                                fi

                                #wriing to the directory-------------------------------------------------
                                cp $dir ${}
                                
                                echo found in line no: $found_in 
                            else 
                                echo 
                            fi 
                        elif [ $start_from = "end" ]; then 
                            echo from end
                            if tail -n $lines_to_look $dir | grep -qi $word_to_look; then
                                echo found in $dir

                                ((total_matched_file = total_matched_file + 1))

                                found_from_back=`grep -ni $word_to_look $dir | cut -d':' -f 1 | tail -n 1`

                                new_name=$((found_from_back)).pappa

                                echo found in $((found_from_back)).pappa
                                echo $new_name
                                

                                #actual_line_no=$((total_line_no - lines_to_look + found_from_back))

                                #echo found on line no $actual_line_no

                            else 
                                echo not found
                            fi

                        
                        fi

                    fi 
                fi
            done
        
        cd .. # for coming back from the recursion
}

look_up_directories $working_dir








echo $total_matched_file
