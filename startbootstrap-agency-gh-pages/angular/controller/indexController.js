app.controller("IndexController", ["$scope", "$http", function($scope, $http){
    
    $scope.nome = "";
    $scope.value = 0;
    $scope.info = {}
    $scope.data = {}

    
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

    $scope.search = function(nome){
        data.forEach(function(i){
        if(i.Nome === nome){
            $scope.info = i;
        }
        
    }) 
        $scope.nome = "";
        $scope.value = $scope.info.Probabilidade * 100;
        $scope.termometro.value = $scope.value;
        //pegar a cor segundo a porcentagem (>p mais vermelho) 
        color = getColorForPercentage($scope.value/100);
        color = colorToHex(color);
        $scope.termometro.chart.thmFillColor = color;
        updateEmotion($scope.value/100);

        $scope.data=[{
            label: "QAL",
            value: $scope.info.QAL
        },
        {
            label: "QDL",
            value: $scope.info.QDL
        },
        {
            label: "QCL",
            value: $scope.info.QCL
        }]

        $scope.features.data = $scope.data;
    }

    $scope.features = {
        chart: {
            caption: "Índices de Corrupção",
            paletteColors: "#0075c2",
            theme: "zune",
            yAxisMaxValue: "400"
        },
        data: $scope.data
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



var data = [
  {
    "Nome": "TARCISIO ALVES FIRMINO",
    "Prefeitura": "ÁGUA BRANCA",
    "QCL": 24,
    "QDL": 16,
    "QAL": 66,
    "Probabilidade": 0.418
  },
  {
    "Nome": "EXPEDITO PEREIRA DE SOUZA",
    "Prefeitura": "BAYEUX",
    "QCL": 54,
    "QDL": 78,
    "QAL": 135,
    "Probabilidade": 0.466
  },
  {
    "Nome": "JOSIVAL JUNIOR DE SOUZA",
    "Prefeitura": "BAYEUX",
    "QCL": 237,
    "QDL": 84,
    "QAL": 179,
    "Probabilidade": 0.726
  },
  {
    "Nome": "ARLINDO FRANCISCO DE SOUSA",
    "Prefeitura": "CACHOEIRA DOS ÍNDIOS",
    "QCL": 0,
    "QDL": 0,
    "QAL": 0,
    "Probabilidade": 0.456
  },
  {
    "Nome": "GERALDO TERTO DA SILVA",
    "Prefeitura": "CACIMBAS",
    "QCL": 23,
    "QDL": 23,
    "QAL": 17,
    "Probabilidade": 0.24
  },
  {
    "Nome": "NILTON DE ALMEIDA",
    "Prefeitura": "CACIMBAS",
    "QCL": 246,
    "QDL": 36,
    "QAL": 4,
    "Probabilidade": 0.58
  },
  {
    "Nome": "EDUARDO RONIELLE GUIMARAES MARTINS DANTAS",
    "Prefeitura": "CUBATI",
    "QCL": 14,
    "QDL": 4,
    "QAL": 20,
    "Probabilidade": 0.346
  },
  {
    "Nome": "FERNANDA MARIA MARINHO DE MEDEIROS LOUREIRO",
    "Prefeitura": "EMAS",
    "QCL": 122,
    "QDL": 11,
    "QAL": 5,
    "Probabilidade": 0.66
  },
  {
    "Nome": "GILBERTO MUNIZ DANTAS",
    "Prefeitura": "FAGUNDES",
    "QCL": 305,
    "QDL": 7,
    "QAL": 1,
    "Probabilidade": 0.78
  },
  {
    "Nome": "FRANCIVALDO SANTOS DE ARAUJO",
    "Prefeitura": "FREI MARTINHO",
    "QCL": 85,
    "QDL": 0,
    "QAL": 13,
    "Probabilidade": 0.122
  },
  {
    "Nome": "AUSTERLIANO EVALDO ARAUJO",
    "Prefeitura": "GADO BRAVO",
    "QCL": 36,
    "QDL": 8,
    "QAL": 19,
    "Probabilidade": 0.096
  },
  {
    "Nome": "AUDIBERG ALVES DE CARVALHO",
    "Prefeitura": "ITAPORANGA",
    "QCL": 37,
    "QDL": 65,
    "QAL": 51,
    "Probabilidade": 0.48
  },
  {
    "Nome": "PAULO DALIA TEIXEIRA",
    "Prefeitura": "JURIPIRANGA",
    "QCL": 53,
    "QDL": 84,
    "QAL": 30,
    "Probabilidade": 0.302
  },
  {
    "Nome": "SUELI MADRUGA FREIRE",
    "Prefeitura": "LAGOA DE DENTRO",
    "QCL": 101,
    "QDL": 8,
    "QAL": 13,
    "Probabilidade": 0.446
  },
  {
    "Nome": "FABIANO PEDRO DA SILVA",
    "Prefeitura": "LAGOA DE DENTRO",
    "QCL": 29,
    "QDL": 47,
    "QAL": 61,
    "Probabilidade": 0.302
  },
  {
    "Nome": "OLIMPIO DE ALENCAR ARAUJO BEZERRA",
    "Prefeitura": "MATARACA",
    "QCL": 46,
    "QDL": 4,
    "QAL": 59,
    "Probabilidade": 0.354
  },
  {
    "Nome": "FRANCISCO ASSIS BRAGA JUNIOR",
    "Prefeitura": "NAZAREZINHO",
    "QCL": 212,
    "QDL": 22,
    "QAL": 27,
    "Probabilidade": 0.686
  },
  {
    "Nome": "MARIA DO CARMO SILVA",
    "Prefeitura": "NOVA OLINDA",
    "QCL": 78,
    "QDL": 5,
    "QAL": 2,
    "Probabilidade": 0.84
  },
  {
    "Nome": "JOSE DE ANCHIETA NOIA",
    "Prefeitura": "PEDRA BRANCA",
    "QCL": 18,
    "QDL": 9,
    "QAL": 51,
    "Probabilidade": 0.302
  },
  {
    "Nome": "RINALDO DE LUCENA GUEDES",
    "Prefeitura": "PIRPIRITUBA",
    "QCL": 212,
    "QDL": 0,
    "QAL": 9,
    "Probabilidade": 0.126
  },
  {
    "Nome": "ADAILMA FERNANDES DA SILVA",
    "Prefeitura": "SERRA DA RAIZ",
    "QCL": 26,
    "QDL": 8,
    "QAL": 33,
    "Probabilidade": 0.27
  },
  {
    "Nome": "MANOEL MARCELO DE ANDRADE",
    "Prefeitura": "SERRA REDONDA",
    "QCL": 65,
    "QDL": 0,
    "QAL": 7,
    "Probabilidade": 0.044
  },
  {
    "Nome": "EDMILSON ALVES DOS REIS",
    "Prefeitura": "TEIXEIRA",
    "QCL": 29,
    "QDL": 64,
    "QAL": 70,
    "Probabilidade": 0.374
  }
]


var findName = function(nome){
    data.forEach(function(i){
        if(i.Nome === nome){
            console.log(i)
            return i;
        }
        
    }) 
}
}])
