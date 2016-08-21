app.controller("IndexController", ["$scope", function($scope){
	$scope.value = 0
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
         
        

color = getColorForPercentage($scope.value/100)
console.log(color);
         $scope.termometro.chart.thmFillColor = getColorForPercentage($scope.value/100);
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
    { pct: 0.0, color: { r: 0xff, g: 0x00, b: 0 } },
    { pct: 0.5, color: { r: 0xff, g: 0xff, b: 0 } },
    { pct: 1.0, color: { r: 0x00, g: 0xff, b: 0 } } ];

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

    function colorToHex(color) {
        if (color.substr(0, 1) === '#') {
            return color;
        }
        var digits = /(.*?)rgb\((\d+), (\d+), (\d+)\)/.exec(color);
        
        var red = parseInt(digits[2]);
        var green = parseInt(digits[3]);
        var blue = parseInt(digits[4]);
        
        var rgb = blue | (green << 8) | (red << 16);
        return digits[1] + '#' + rgb.toString(16);
    };
}])