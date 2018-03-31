/**
 * rey_page javascript
 */

$(document).on('turbolinks:load', function(){
    let $rey_form = $('#rey_form');
    let $answers = $('select');

    $rey_form.on('submit', function(e){
        e.preventDefault();

        for(let i=0; i< $answers.length; i++){
            if($answers[i].value === ''){
                confirm('Seçmediğiniz soru bulunmaktadır. Lütfen tüm' +
                    'soruları cevapladığınızdan emin olunuz..');
                return false;
            }
        }
        $(this).unbind('submit').submit();
    });
});