/**
 * dr_reg_page
 */


$(document).on('turbolinks:load', function(){
    let $reg_form = $('#dr_kayit_form');
    let $upt_form = $('#dr_update_form');
    let $reg_button = $('#kayit_but');
    let $upt_button = $('#upt_but');

    let $il_sel = $('#dr_il_sel');
    let $ilce_sel = $("#dr_ilce_sel");
    let $hastane_sel = $('#dr_hastane_sel');
    let $servis_sel = $('#dr_servis_sel');
    let $submit_button = $('#dr_reg_sub');

    let $dr_isim_u = $('#dr_isim_upt');
    let $dr_servis_u = $('#dr_servis_upt');
    let $dr_hastane_u = $('#dr_hastane_upt');
    let $dr_ilce_u = $('#dr_ilce_upt');
    let $dr_il_u = $('#dr_il_upt');


// ::REG-FORM::
    $ilce_sel.attr('disabled', true);
    $hastane_sel.attr('disabled', true);
    $servis_sel.attr('disabled', true);
    $submit_button.attr('disabled', true);

    $il_sel.on('change', function(){
        let selected = $("#dr_il_sel option:selected").attr('value');

        if (selected){
            let il_id = JSON.parse(selected)[0];
            $ilce_sel.attr('disabled', false);
            let $ilce_opt = $("#dr_ilce_sel option");
            $ilce_sel.val("");
            for(let i=1; i < $ilce_opt.length; i++){
                $ilce_opt[i].hidden = false;
                let ilce_sel = $ilce_opt[i].value;
                if(ilce_sel){
                    let ilce_var = JSON.parse(ilce_sel);
                    if(ilce_var[1] !== il_id){
                        $ilce_opt[i].hidden = true;
                    }
                }
            }
        }else {
            $ilce_sel.attr('disabled', true);
            $hastane_sel.attr('disabled', true);
            $servis_sel.attr('disabled', true);
        }
    });

    $ilce_sel.on('change', function(){
        let selected = $("#dr_ilce_sel option:selected").attr('value');

        if(selected){
            let ilce_id = JSON.parse(selected)[0];
            $hastane_sel.attr('disabled', false);

            let $hastane_opt = $('#dr_hastane_sel option');
            $hastane_sel.val("");
            for(let i=1; i < $hastane_opt.length; i++){
                $hastane_opt[i].hidden = false;
                let hastane_val = $hastane_opt[i].value;
                if(hastane_val){
                    let val_parsed = JSON.parse(hastane_val);
                    if(val_parsed[1] !== ilce_id){
                        $hastane_opt[i].hidden = true;
                    }
                }
            }
        }else{
            $hastane_sel.attr('disabled', true);
            $servis_sel.attr('disabled', true);
        }
    });

    $hastane_sel.on('change', function(){
        let hastane_val = $('#dr_hastane_sel option:selected').attr('value');
        if(hastane_val){
            $servis_sel.attr('disabled', false);
            $servis_sel.val('');
        }else {
            $servis_sel.attr('disabled', true);
            $submit_button.attr('disabled', true);
        }
    });

    $servis_sel.on('change', function(){
        let servis_var = $(this).val();
        if (servis_var) {
            $submit_button.attr('disabled', false);
        } else {
            $submit_button.attr('disabled', true);
        }
    });
// :: REG FORM :: END

// :: BUTTON CONTROL ::
    $reg_button.on('click', function(e){
        e.preventDefault();
        $upt_form.fadeOut(300);
        $reg_form.delay(300).fadeIn(300);
        $(this).addClass('but_active');
        $(this).removeClass('but_passive');
        $upt_button.addClass('but_passive');
        $upt_button.removeClass('but_active');
        return false;
    });

    $upt_button.on('click', function(e){
        e.preventDefault();
        $reg_form.fadeOut(300);
        $upt_form.delay(300).fadeIn(300);
        $(this).addClass('but_active');
        $(this).removeClass('but_passive');
        $reg_button.addClass('but_passive');
        $reg_button.removeClass('but_active');
        return false;
    });
// :: BUTTON CONTROL :: END

// :: UPDATE FORM ::
    $dr_il_u.attr('disabled', true);
    $dr_ilce_u.attr('disabled', true);
    $dr_hastane_u.attr('disabled', true);
    $dr_servis_u.attr('disabled', true);

    $dr_il_u.on('change', function(){
        let opt_val = $(this).val();
        if (opt_val){
            let il_id = JSON.parse(opt_val)[0];

            let ilces = $('#dr_ilce_upt option');
            $dr_ilce_u.val('');
            $dr_hastane_u.val('');
            $dr_servis_u.val('');

            for(let i=1; i < ilces.length; i++){
                ilces[i].hidden = false;
                ilce_il_id = JSON.parse(ilces[i].value)[1];

                if(ilce_il_id !== il_id){
                    ilces[i].hidden = true;
                }
            }
        }
    });

    $dr_ilce_u.on('change', function(){
        let opt_val = $(this).val();
        if(opt_val){
            let ilce_id = JSON.parse(opt_val)[0];

            let hastanes = $('#dr_hastane_upt option');
            $dr_hastane_u.val('');
            $dr_servis_u.val('');

            for(let i=1; i<hastanes.length; i++){
                hastanes[i].hidden = false;
                hastane_ilce_id = JSON.parse(hastanes[i].value)[1];

                if(hastane_ilce_id !== ilce_id){
                    hastanes[i].hidden = true;
                }
            }
        }
    });

    $dr_hastane_u.on('change', function(){
        $dr_servis_u.val('');
    });

    $dr_isim_u.on('change', function(){
        isim_val = $(this).val();

        if (isim_val){
            dr_val = JSON.parse(isim_val);
            if(dr_val[3] === 0){
                $dr_il_u.attr('disabled', true);
                $dr_ilce_u.attr('disabled', true);
                $dr_hastane_u.attr('disabled', true);
                $dr_servis_u.attr('disabled', true);
                confirm('Seçtiğiniz doktorun anlık verilere ait kayıdı bulunduğu için güncelleme yapılamamaktadır!');
                return false;
            } else if (dr_val[3] === 1){
                $dr_il_u.attr('disabled', false);
                $dr_ilce_u.attr('disabled', false);
                $dr_hastane_u.attr('disabled', false);
                $dr_servis_u.attr('disabled', false);

                let $il_opts = $('#dr_il_upt option');
                let $ilce_opts = $('#dr_ilce_upt option');
                let $hastane_opts = $('#dr_hastane_upt option');
                let $servis_opts = $('#dr_servis_upt option');

                // Hastane Değerinin Bulunması
                for(let i=1; i<$hastane_opts.length; i++){
                    opt_hastane_id = JSON.parse($hastane_opts[i].value);
                    if(opt_hastane_id[0] === dr_val[1]){
                        $dr_hastane_u.val($hastane_opts[i].value);
                        for(let i=1; i<$ilce_opts.length; i++){
                            $ilce_opts[i].hidden = false;
                            let ilce_il_id = JSON.parse($ilce_opts[i].value)[1];

                            if(ilce_il_id !== opt_hastane_id[2]){
                                $ilce_opts[i].hidden = true;
                            }
                        }
                        break;
                    }
                }
                // Servisin Bulunması:
                for(let i=1; i<$servis_opts.length; i++){
                    opt_servis_id = JSON.parse($servis_opts[i].value);
                    if(opt_servis_id[0] === dr_val[2]){
                        $dr_servis_u.val($servis_opts[i].value);
                        break;
                    }
                }

                // İlçe Değerinin bulunması:
                for(let i=1; i<$ilce_opts.length; i++){
                    opt_ilce_id = JSON.parse($ilce_opts[i].value);
                    if(opt_hastane_id[1] === opt_ilce_id[0]){
                        $dr_ilce_u.val($ilce_opts[i].value);
                        for(let i=1; i<$hastane_opts.length; i++){
                            $hastane_opts[i].hidden = false;
                            let hastane_ilce_id = JSON.parse($hastane_opts[i].value)[1];

                            if(hastane_ilce_id !== opt_ilce_id[0]){
                                $hastane_opts[i].hidden = true;
                            }
                        }
                        break;
                    }
                }
                // İl değerinin bulunması:
                for(let i=1; i<$il_opts.length; i++){
                    opt_il_id = JSON.parse($il_opts[i].value);
                    if(opt_il_id[0] === opt_ilce_id[1]){
                        $dr_il_u.val($il_opts[i].value);
                        break;
                    }
                }
            }
        } else{
            $dr_il_u.val('');
            $dr_ilce_u.val('');
            $dr_hastane_u.val('');
            $dr_servis_u.val('');

            $dr_il_u.attr('disabled', true);
            $dr_ilce_u.attr('disabled', true);
            $dr_hastane_u.attr('disabled', true);
            $dr_servis_u.attr('disabled', true);
        }
    });
});
