/**
 * data_gets javascript
 */

$(document).on('turbolinks:load', function () {
    let $specs = $("select[name='spec']");
    let $unselect = $('#un_select');

    // $unselect.hide();

    function dec_filter(table_id, value){
        if (table_id === "il_veri_tablo"){
            $("tr:has(td#prm_il:contains(" + value + "))").fadeOut(200);
        } else if (table_id === "ilce_veri_tablo"){
            $("tr:has(td[id =" + value + "])").fadeOut(200);
        } else if (table_id === "hastane_veri_tablo"){
            $("tr:has(td#prm_kurum_kodu:contains(" + value + "))").fadeOut(200);
        } else if (table_id === "doktor_veri_tablo"){
            $("tr:has(td#prm_tc:contains(" + value + "))").fadeOut(200);
        } else if (table_id === "hasta_veri_tablo"){
            $("tr:has(td#prm_tc:contains(" + value + "))").fadeOut(200);
        }
    }

    function inc_filter(table_id, value){
        if (table_id === "il_veri_tablo"){
            $("tr:has(td#prm_il:contains(" + value + "))").fadeIn(200);
        } else if (table_id === "ilce_veri_tablo"){
            $("tr:has(td[id =" + value + "])").fadeIn(200);
        } else if (table_id === "hastane_veri_tablo"){
            $("tr:has(td#prm_kurum_kodu:contains(" + value + "))").fadeIn(200);
        } else if (table_id === "doktor_veri_tablo"){
            $("tr:has(td#prm_tc:contains(" + value + "))").fadeIn(200);
        } else if (table_id === "hasta_veri_tablo"){
            $("tr:has(td#prm_tc:contains(" + value + "))").fadeIn(200);
        }
    }

    $unselect.click(function(){
        let val = this.value;
        let table_id = $('table').attr('id');
        if(val !== '') {
            $specs.append($("option[value = " + val + "]"));
            if ($("#un_select option").length === 0){
                $unselect.fadeOut(300);
                $("tr:has(td)").fadeIn(300);
            }else {
                dec_filter(table_id, val);
            }
        }
    });

    if($specs[0]){
        $specs.on('change', function(){
            let val = this.value;
            let table_id = $('table').attr('id');
            let all_tr = $('tr:has(td)');
            if(val === '') {
                $specs.append($("#un_select option"));
                all_tr.fadeIn(300);
                $unselect.hide();
            } else if($("#un_select option").length >= 1) {
                $unselect.append($("option[value =" + val + "]"));
                inc_filter(table_id, val);
            } else {
                all_tr.hide();
                $unselect.fadeIn(300);
                $unselect.append($("option[value =" + val + "]"));
                inc_filter(table_id, val);
            }
        });
    }



});
