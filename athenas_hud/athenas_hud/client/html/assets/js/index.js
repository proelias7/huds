let months = {[0]: 'Jan', [1]: 'Fev', [2]: 'Mar', [3]: 'Abr', [4]: 'Mai', [5]: 'Jun', [6]: 'Jul', [7]: 'Agos', [8]: 'Set', [9]: 'Out', [10]: 'Nov', [11]: 'Dez'}

"use strict";

var loadJS = function(url, implementationCode, location) {
	var scriptTag = document.createElement('script');
	scriptTag.src = url;

	scriptTag.onload = implementationCode;
	scriptTag.onreadystatechange = implementationCode;

	location.appendChild(scriptTag);
};

window.onload = function () {
    var locale = {
      setText: function(data) {
        var key = document.querySelector('#'+data.id);
        var html = data.value;
        saferInnerHTML(key, html);
      },
    };

    window.addEventListener('message', function(event) {
        if (event.data.hora) locale[event.data.hora](event.data);
    });
}

$(document).ready(() => {
    let vehicle = false;

    window.addEventListener('message', function(e) {
        let data = e.data;

        if (data.action == 'pause') {
            if (data.status) {
                $('body').fadeOut();
            }else if (!data.status) {
                $('body').fadeIn();
            }
        }

        /* Player */
        if (data.action == 'player') {   
            if (data.needs) {
                if (data.needs.health > 100) {
                    data.needs.health = 100
                }
                if (data.needs.health <= 2){
                    data.needs.health = 0
                }
                if (data.needs.health <= 45){
                    $('body > status > needs > life > img').addClass('imgactive');
                }else {
                    $('body > status > needs > life > img').removeClass('imgactive');
                }
                if (data.needs.armor <= 0){
                    $('body > status2').addClass('hide');
                    $('body > status').css('bottom','60px');
                }else{
                    $('body > status2').removeClass('hide');
                    $('body > status').css('bottom','100px');
                }
                $('body > status > needs > life > div').css('width', data.needs.health + '%');
                $('body > status > needs > life > span#vida > p').html(data.needs.health + '%');
                $('body > status2 > needs2 > shield > div').css('width', data.needs.armor + '%');
                $('body > status2 > needs2 > shield > span#colete > p').html(data.needs.armor + '%');
            }
        }

        /* Vehicle */
        if (data.action == 'vehicle') {

            if (!vehicle) {              
                $('.belt').fadeIn('fast');
                $('.belt > img').css('animation', 'blink 2s infinite');
                vehicle = true;
                $('speedometer').removeClass('active');
                
            }
                
            if (data.vClass == 8 || data.vClass == 13 || data.vClass == 14) {
                $('.belt').css('display','none');
            }
            if (data.lights == 'high') {
                $('body > speedometer > div.main > div.light > img').css('opacity', '1');
            }else if (data.lights == 'normal') {
                $('body > speedometer > div.main > div.light > img').css('opacity', '.6');
            }else if (data.lights == 'off') {
                $('body > speedometer > div.main > div.light > img').css('opacity', '.2');
            }

            if (data.engine) {
                $('.info > .item').removeClass('active');
                $('.info > .item:nth-child(1)').addClass('active');
            }else if (data.gear == 'R' && data.speed > 0) {
                $('.info > .item').removeClass('active');
                $('.info > .item:nth-child(1)').addClass('active');
            }else if (data.gear > 0 && data.speed > 0 && data.speed < 10) {
                $('.info > .item').removeClass('active');
                $('.info > .item:nth-child(1)').addClass('active');
                $('.info > .item:nth-child(1)').html('D');
            }else if (data.gear > 0 && data.speed > 10) {
                $('.info > .item').removeClass('active');
                $('.info > .item:nth-child(1)').addClass('active');
                $('.info > .item:nth-child(1)').html(data.gear);
            }else if (data.gear == 'N') {
                $('.info > .item').removeClass('active');
                $('.info > .item:nth-child(1)').addClass('active');
            }

            $('body > speedometer > div.engineBar > div > div').css('width', Math.ceil((100 * (data.health / 1000))) + '%');
            $('body > speedometer > div.fuelBar > div > div').css('width', Math.ceil((100 * (data.fuel / 100))) + '%');

            $('body > speedometer > div.main > div.km > span').html(data.speed);
        }
        
        if (data.action == 'belt') {
            if (data.status) {
                $('.belt').fadeOut('fast');
                $('.belt > img').css('animation', 'unset');
            }else if (!data.status) {
                $('.belt').fadeIn('fast');
                $('.belt > img').css('animation', 'blink 2s infinite');
            }
        }

        if (data.action == 'vehicleReset') {
            if (vehicle) {
                vehicle = false;
                $('speedometer').addClass('active');
            }
        }
    });
});



(function($) {
    var s,
        spanizeLetters = {
            settings: {
                letters: $('.js-spanize'),
            },
            init: function() {
                s = this.settings;
                this.bindEvents();
            },
            bindEvents: function() {
                s.letters.html(function(i, el) {
                    var spanizer = $.trim(el).split("");
                    return '<span>' + spanizer.join('</span><span>') + '</span>';
                });
            },
        };
    spanizeLetters.init();
})(jQuery);