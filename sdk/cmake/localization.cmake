
if(NOT DEFINED I18N_LANG)
    set(I18N_LANG all)
endif()

function(set_i18n_language I18N_LANG)
    set(I18N_DEFS -DLANGUAGE_EN_US PARENT_SCOPE)
    message("-- Selected localization: ${I18N_LANG}")

endfunction()
