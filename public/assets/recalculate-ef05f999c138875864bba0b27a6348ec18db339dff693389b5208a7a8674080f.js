/**
 * recalculate javascript
 */


$(document).on('turbolinks:load', function(){

    $('#re_calc_but').click(function(e){
        let text = 'DönemlikHesaplama ile yeni bir dönem oluşturulacak ve' +
            ' eski döneme ait "MailList" tablosu silinecektir. Bu seçenek' +
            ' programın yapısına aykırıdır fakat TEST amaçlı kullanılabilir.';
        if(confirm(text)){
            return true;
        }   else{
            e.preventDefault();
            return false;
        }
    });
});
