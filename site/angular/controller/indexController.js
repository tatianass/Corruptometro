app.controller("IndexController", ["$scope", function($scope){
    $scope.value = 0;
    $scope.emotion = "emotion/1.png";
    var emotions = [
        {p: 0.2, src:"emotion/1.png"},
        {p: 0.4, src:"emotion/2.png"},
        {p: 0.6, src:"emotion/3.png"},
        {p: 0.8, src:"emotion/4.png"},
        {p: 1.0, src:"emotion/5.png"}];

    var updateEmotion = function(p){
        if(p <= emotions[0].p){
            $scope.emotion = emotions[0].src
        } else if(p > emotions[0].p & p <= emotions[1].p){
            $scope.emotion = emotions[1].src
        } else if (p > emotions[1].p & p <= emotions[2].p){
            $scope.emotion = emotions[2].src
        } else if(p > emotions[2].p & p <= emotions[3].p){
            $scope.emotion = emotions[3].src
        }  else{
            $scope.emotion = emotions[4].src
        }        
    }


    
    $scope.termometro = {
        chart: {
                subcaptionFontBold: "0",
                lowerLimit: "0",
                upperLimit: "100",
                numberSuffix: "%",
                showBorder: "1",
                thmFillColor: "#FFFFFF",
                chartBottomMargin: "30",
                majorTMNumber: "6",
                ticksOnRight: "0"

        },
        value: $scope.value

    }

    $scope.search = function(){
        $scope.termometro.value = $scope.value;
        
        //pegar a cor segundo a porcentagem (>p mais vermelho) 
        color = getColorForPercentage($scope.value/100);
        color = colorToHex(color);
        $scope.termometro.chart.thmFillColor = color;
        updateEmotion($scope.value/100);
    }

    $scope.features = {
        chart: {
            caption: "Índices de Corrupção",
            paletteColors: "#0075c2",
            theme: "zune",
            numberSuffix: "%"
        },
        data:[{
            label: "feature1",
            value: "24"
        },
        {
            label: "feature2",
            value: "14"
        },
        {
            label: "feature3",
            value: "40"
        }]
    };

    var percentColors = [
    { pct: 0.0, color: { r: 0x00, g: 0xff, b: 0x00 } },
    { pct: 0.2, color: { r: 0xe6, g: 0xff, b: 0x00 } },
    { pct: 0.4, color: { r: 0xff, g: 0xc4, b: 0x00 } },
    { pct: 0.6, color: { r: 0xff, g: 0x9e, b: 0x00 } },
    { pct: 0.8, color: { r: 0xff, g: 0x44, b: 0x00 } },
    { pct: 1.0, color: { r: 0xff, g: 0x00, b: 0x00} } ];

    var getColorForPercentage = function(pct) {
        for (var i = 1; i < percentColors.length - 1; i++) {
            if (pct < percentColors[i].pct) {
                break;
            }
        }
        var lower = percentColors[i - 1];
        var upper = percentColors[i];
        var range = upper.pct - lower.pct;
        var rangePct = (pct - lower.pct) / range;
        var pctLower = 1 - rangePct;
        var pctUpper = rangePct;
        
        var color = {
            r: Math.floor(lower.color.r * pctLower + upper.color.r * pctUpper),
            g: Math.floor(lower.color.g * pctLower + upper.color.g * pctUpper),
            b: Math.floor(lower.color.b * pctLower + upper.color.b * pctUpper)
        };

        return [color.r, color.g, color.b];
        // or output as hex if preferred
    }  

    var colorToHex = function (color) {

        color[0] = parser(color[0]);
        color[1] = parser(color[1]);
        color[2] = parser(color[2]);
        
        color = "#" + color.join("");
        return color;        
    };

    var parser = function(x){             //For each array element
        x  = parseInt(x).toString(16);      //Convert to a base16 string
        return (x.length==1) ? "0"+x : x;  //Add zero if we get only one character
    }
}])