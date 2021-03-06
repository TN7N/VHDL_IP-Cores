#!/usr/bin/tclsh
# This file provides the generation callback invoked by nios2-bsp generator.

# Generation callback for nios2-bsp
proc generationCallback { instName tgtDir bspDir } {
    set fileName        "tbuf-cfg.h"
    set cmacro_off              "TBUF_OFFSET"
    set listCmacro_off  [list   "TBUF_OFFSET_CONACK" \
                                $cmacro_off \
                                "TBUF_OFFSET_PROACK" ]
    set cmacro_siz              "TBUF_SIZE"
    set listCmacro_siz  [list   "TBUF_SIZE_CONACK" \
                                $cmacro_siz \
                                "TBUF_SIZE_PROACK" ]
    set cmacro_ispro            "TBUF_PORTA_ISPRODUCER"
    set listCmacro_num  [list   "TBUF_NUM_CON" "TBUF_NUM_PRO" ]

    # Get path of this file
    set thisFileLoc [pwd]

    # Get writeFile_* functions by relative path
    source "${thisFileLoc}/../../../common/util/tcl/writeFile.tcl"

    puts ""
    puts "***********************************************************"
    puts ""
    puts " Create ${fileName} with settings from ${instName} ..."
    puts ""

    # Get all cmacro not offset or size names
    set listCmacroName_num ""
    foreach cmacro $listCmacro_num {
        set listCmacroName_num [concat $listCmacroName_num [getAllCmacros $cmacro]]
    }

    # Get all values
    set listCmacroValue_num [getCmacroValues $listCmacroName_num]

    # Get number of triple buffers
    set totalNum 0
    foreach num $listCmacroValue_num {
        set totalNum [expr $totalNum + $num]
    }

    # Get all cmacro offset names
    set listCmacroName_off ""
    foreach cmacro $listCmacro_off {
        #WORKAROUND: limit cmacro_off list to totalNum
        if {$cmacro != $cmacro_off} {
            set listCmacroName_off [concat $listCmacroName_off [getAllCmacros $cmacro]]
        } else {
            set listCmacroName_off [concat $listCmacroName_off [limitList [getAllCmacros $cmacro] $totalNum]]
        }
    }

    # Get all offset values
    set listCmacroValue_off [getCmacroValues $listCmacroName_off]

    # Get all cmacro size names
    set listCmacroName_siz ""
    foreach cmacro $listCmacro_siz {
        #WORKAROUND: limit cmacro_siz list to totalNum
        if {$cmacro != $cmacro_siz} {
            set listCmacroName_siz [concat $listCmacroName_siz [getAllCmacros $cmacro]]
        } else {
            set listCmacroName_siz [concat $listCmacroName_siz [limitList [getAllCmacros $cmacro] $totalNum]]
        }
    }

    # Get all size values
    set listCmacroValue_siz [getCmacroValues $listCmacroName_siz]

    # Get is-producer cmacros
    #WORKAROUND: limit cmacro_ispro list to totalNum
    set listCmacroName_ispro [limitList [getAllCmacros $cmacro_ispro] $totalNum]

    # Get is-producer values
    set listCmacroValue_ispro [getCmacroValues $listCmacroName_ispro]

    # Add con- and pro-ack ispro for vector
    set listCmacroName_ispro [concat    "${cmacro_ispro}_CONACK" \
                                        ${listCmacroName_ispro} \
                                        "${cmacro_ispro}_PROACK"]
    set ackVal_ispro -1
    set listCmacroValue_ispro [concat   "${ackVal_ispro}" \
                                        ${listCmacroValue_ispro} \
                                        "${ackVal_ispro}"]

    # Open file in target directory
    set fid [writeFile_open "${tgtDir}/${fileName}"]

    # Write header
    writeFile_header $fid

    # Write IFNDEF stuff
    writeFile_emptyLine $fid
    writeFile_string $fid "#ifndef _INC_tbuf_cfg_H_"
    writeFile_string $fid "#define _INC_tbuf_cfg_H_"
    writeFile_emptyLine $fid

    # Write offset/size/is-pro pairs
    foreach off_name $listCmacroName_off off_val $listCmacroValue_off \
            siz_name $listCmacroName_siz size_val $listCmacroValue_siz \
            ispro_name $listCmacroName_ispro ispro_val $listCmacroValue_ispro {
        writeFile_cmacro $fid $off_name $off_val
        writeFile_cmacro $fid $siz_name $size_val
        writeFile_cmacro $fid $ispro_name $ispro_val
        writeFile_emptyLine $fid
    }

    # Write other macros
    foreach cmacro $listCmacroName_num value $listCmacroValue_num {
        writeFile_cmacro $fid $cmacro $value
    }
    writeFile_emptyLine $fid

    # Write TBUF initialization vector
    writeFile_string $fid "#define TBUF_INIT_VEC { \\"

    # Get number of buffer, to know the vector length
    set numOfBuf [llength $listCmacroName_off]

    set cnt 0
    foreach off_name $listCmacroName_off siz_name $listCmacroName_siz \
            ispro_name $listCmacroName_ispro {
        set tmpString "                        "
        set tmpString "${tmpString}{ ${off_name}, ${siz_name}, ${ispro_name} }"

        incr cnt

        if { $cnt < $numOfBuf } {
            set tmpString "${tmpString}, "
        }

        set tmpString "${tmpString} \\"

        writeFile_string $fid $tmpString
    }

    writeFile_string $fid "                      }"

    writeFile_emptyLine $fid
    writeFile_string $fid "#endif /* _INC_tbuf_cfg_H_ */"
    writeFile_close $fid

    puts "***********************************************************"
    puts ""

}

# This procedure tries to find the corresponding cmacros in sopcinfo.
# It starts without counting value and afterwards with counting value 0.
# Hence, the following cmacros are found (e.g.):
# THIS_IS_SOMETHING
# or
# THIS_IS_COUNTING0 THIS_IS_COUNTING1 ...
# or
# THIS_IS_ANY THIS_IS_ANY0 THIS_IS_ANY1 ...
#
# Note that cmacros that do not start with 0 are not found!
proc getAllCmacros { cmacro } {
    set listCmacro ""
    set cnt 0

    # Try without counting value
    if { [get_module_assignment embeddedsw.CMacro.$cmacro] != "" } {
        set listCmacro [concat $listCmacro $cmacro]
    }

    # Now try with counting value
    while {1} {
        set tmp ${cmacro}${cnt}
        if { [get_module_assignment embeddedsw.CMacro.$tmp] != "" } {
            set listCmacro [concat $listCmacro $tmp]
        } else {
            return $listCmacro
        }

        incr cnt
    }
}

# This procedure gets the values of a list of cmacros
proc getCmacroValues { listCmacros } {
    set tmp ""
    foreach cmacro $listCmacros {
        set tmp [concat $tmp [get_module_assignment embeddedsw.CMacro.$cmacro]]
    }

    return $tmp
}

# This procedure limits the provided list.
proc limitList { listIn limit } {
    set tmp ""
    set cnt 0

    foreach element $listIn {
        set tmp [concat $tmp $element]
        incr cnt

        if { $cnt >= $limit} {
            break
        }
    }

    return $tmp
}

# Sets the given parameters' visibility to true/false determined by
# the parameter value maxcnt.
proc setGuiParamListVis { lstname maxcnt } {
    set cnt 0

    foreach param $lstname {
        if { $cnt < $maxcnt } {
            set_parameter_property $param VISIBLE true
        } else {
            set_parameter_property $param VISIBLE false
        }
        incr cnt
    }
}

# Get the given parameters' value by the parameter value maxname.
proc getGuiParamListVal { lstname maxname } {
    set cnt 0
    set listRet ""
    set maxcnt [get_parameter_value $maxname]

    foreach param $lstname {
        if { $cnt < $maxcnt } {
            set listRet [concat $listRet [get_parameter_value $param]]
        }
        incr cnt
    }

    return $listRet
}

# Check size list for alignment
proc checkSizeAlign { lst alnm } {
    foreach val $lst {
        if {[expr $val % $alnm] != 0} {
            return -1
        }
    }
    return 0
}

# Check list for unequality
proc checkSizeUnequal { lst uneq } {
    foreach val $lst {
        if {$val == $uneq} {
            return -1
        }
    }
    return 0
}

# Get memory map of provided buffer sizes
proc getMemoryMap { base lstSize } {
    set lstBase $base
    set accu    $base

    foreach size $lstSize {
        set lstBase [concat $lstBase [expr $accu + $size]]
        set accu [expr $accu + $size]
    }

    return $lstBase
}

# Convert list values into hex
proc convDecToHex { lst pos } {
    set tmp ""

    foreach i $lst {
        set tmp [concat $tmp [format %0${pos}X $i]]
    }

    return $tmp
}

# Get string stream from list
proc getStringStream { lst } {
    set tmp ""

    foreach i $lst {
        set tmp [format "%s%s" $tmp $i]
    }

    return $tmp
}

# Set value as CMACRO
proc setValCmacro { name val } {
    set_module_assignment embeddedsw.CMacro.${name}             $val
}

# Set list as CMACRO
proc setListCmacro { name lst } {
    set cnt 0

    foreach i $lst {
        set_module_assignment embeddedsw.CMacro.${name}${cnt}   $i
        incr cnt
    }
}
