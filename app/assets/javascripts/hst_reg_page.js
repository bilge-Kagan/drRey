/**
 * hst_reg_page
 */

$(document).on('turbolinks:load', function(){
    let $hastane = $('#hasta_hstn_sel');
    let $servis = $('#hasta_svs_sel');
    let $doktor = $('#hasta_dr_sel');

    let $opt_servis = $('#hasta_svs_sel option');
    let $opt_doktor = $('#hasta_dr_sel option');

    $servis.attr('disabled', true);
    $doktor.attr('disabled', true);

    $hastane.on('change', function(){
        let hst_val = $hastane.val();

        if(hst_val){
            let hst_id = JSON.parse(hst_val)[0];

            $servis.attr('disabled', false);
            $servis.val('');
            for(let i=1; i<$opt_servis.length; i++){
                $opt_servis[i].hidden = true;
            }
            for(let i=1; i<$opt_doktor.length; i++){
                $opt_doktor[i].hidden = false;
                let dr_val = JSON.parse($opt_doktor[i].value);
                let dr_hst_id = dr_val[1];
                let dr_svs_id = dr_val[2];

                if(hst_id !== dr_hst_id){
                    $opt_doktor[i].hidden = true;
                    continue;
                }

                for(let j=1; j<$opt_servis.length; j++){
                    let id = JSON.parse($opt_servis[j].value)[0];
                    if(id === dr_svs_id){
                        $opt_servis[j].hidden = false;
                    }
                }
            }
        } else{
            $doktor.attr('disabled', true);
            $servis.attr('disabled', true);
            $servis.val('');
            $doktor.val('');
        }
    });

    $servis.on('change', function(){
        let svs_val = $servis.val();

        if(svs_val){
            let hst_id = JSON.parse($hastane.val())[0];
            let svs_id = JSON.parse(svs_val)[0];
            $doktor.attr('disabled', false);
            $doktor.val('');

            for(let i=1; i<$opt_doktor.length; i++){
                let dr_val = JSON.parse($opt_doktor[i].value);
                if (dr_val[1] === hst_id){
                    $opt_doktor[i].hidden = dr_val[2] !== svs_id;
                }
            }
        } else{
            $doktor.attr('disabled', true);
            $doktor.val('');
        }
    });
});