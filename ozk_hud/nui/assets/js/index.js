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

                if (data.needs.voz == 1){
                    $(".vozDisplay").css("stroke-dashoffset","66");
                    $(".vozDisplay").css("stroke","#0267ff");
                    $("#voz").css("background","#0267ff");
                } else if (data.needs.voz == 2){
                    $(".vozDisplay").css("stroke-dashoffset","33");
                    $(".vozDisplay").css("stroke","#f2374d");
                    $("#voz").css("background","#f2374d");
                } else if (data.needs.voz == 3){
                    $(".vozDisplay").css("stroke-dashoffset","0");
                    $(".vozDisplay").css("stroke","#00e472");
                    $("#voz").css("background","#00e472");
                }

                if (data.needs.health <= 0){
                    $(".vidaDisplay").css("stroke-dashoffset","100");
                    $(".iconvida").addClass("imgactive");
                } else if (data.needs.health <= 30) {
                    $(".vidaDisplay").css("stroke-dashoffset",100 - data.needs.health);
                    $(".iconvida").addClass("imgactive");
                } else {
                    $(".vidaDisplay").css("stroke-dashoffset",100 - data.needs.health);
                    $(".iconvida").removeClass("imgactive");
                }

                if (data.needs.armor <= 0){
                    $(".coleteDisplay").css("stroke-dashoffset","100");
                    $("#colete").fadeOut(500);
                    $(".container").css("height","190px");
                } else {
                    $(".coleteDisplay").css("stroke-dashoffset",100 - data.needs.armor);
                    $("#colete").fadeIn(500);
                    $(".container").css("height","230px");
                }

                if (data.needs.fome >= 100){
                    $(".fomeDisplay").css("stroke-dashoffset","100");
                } else {
                    $(".fomeDisplay").css("stroke-dashoffset",data.needs.fome);
                }

                if (data.needs.sede >= 100){
                    $(".sedeDisplay").css("stroke-dashoffset","100");
                } else {
                    $(".sedeDisplay").css("stroke-dashoffset",data.needs.sede);
                }

                if (data.needs.fome >= 80){
                    $(".iconfome").addClass("imgactive");
                } else {
                    $(".iconfome").removeClass("imgactive");
                }
                if (data.needs.sede >= 80){
                    $(".iconsede").addClass("imgactive");
                } else {
                    $(".iconsede").removeClass("imgactive");
                }
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
                $('body > speedometer > div.main > div.light > img').css('opacity', '.4');
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
           
            if (Math.ceil((100 * (data.fuel / 100))) <= 0){
                $(".fuelDisplay").css("stroke-dashoffset","100");
            } else {
                $(".fuelDisplay").css("stroke-dashoffset",100 - Math.ceil((100 * (data.fuel / 100))));
            }

            if (Math.ceil((100 * (data.health / 1000))) <= 0){
                $(".motorDisplay").css("stroke-dashoffset","100");
            } else {
                $(".motorDisplay").css("stroke-dashoffset",100 - Math.ceil((100 * (data.health / 1000))));
            }

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