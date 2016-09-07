app.controller("IndexController", ["$scope", "$http", function($scope, $http){
    
    $scope.nome = "";
    $scope.value = 0;
    $scope.info = {}
    $scope.featureData = {}
    var mediaFeature = [
                        {
                            "value": "38"
                        }, 
                        {
                            "value": "61"
                        }
                    ]

    //figuras representando reacoes a cada probabilidade
    $scope.emotion = "emotion/1.png";
    var emotions = [
        {p: 0.2, src:"emotion/1.png"},
        {p: 0.4, src:"emotion/2.png"},
        {p: 0.6, src:"emotion/3.png"},
        {p: 0.8, src:"emotion/4.png"},
        {p: 1.0, src:"emotion/5.png"}];

    //atualizando as figuras
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


    //grafico do termometro/corruptometro
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

    //busca pelo nome no do candidato
    $scope.search = function(nome){
        //busca por nome nos dados
        $scope.dados.forEach(function(i){
        if(i.Nome === nome){
            $scope.info = i;
        }
        
        }) 

        //deixa campo de pesquisa em branco
        $scope.nome = "";

        //atualizando valor do termometro
        $scope.value = $scope.info.Probabilidade * 100;
        $scope.termometro.value = $scope.value;
        

        //pega a cor segundo a porcentagem 
        //(quanto maior a probabilidade mais proxima a vermelho sera a cor) 
        color = getColorForPercentage($scope.value/100);
        color = colorToHex(color);
        $scope.termometro.chart.thmFillColor = color;
        updateEmotion($scope.value/100);

        //atualizando os valores dos indicadores
        $scope.featureData=[{
            label: "NAV",
            value: $scope.info.NAV
        },
        {
            label: "NAT",
            value: $scope.info.NAV
        }]

        $scope.features.dataset[0].data = $scope.featureData;
    }

    //grafico das features/indicadores
    $scope.features = {
        "chart": {
                "caption": "Indicadores de corrupção",
                "paletteColors": "#0075c2,#1aaf5d",
                "bgColor": "#ffffff",
                "showBorder": "0",
                "showHoverEffect":"1",
                "showCanvasBorder": "0",
                "usePlotGradientColor": "0",
                "plotBorderAlpha": "10",
                "legendBorderAlpha": "0",
                "legendShadow": "0",
                "placevaluesInside": "1",
                "valueFontColor": "#ffffff",
                "showXAxisLine": "1",
                "xAxisLineColor": "#999999",
                "divlineColor": "#999999",               
                "divLineIsDashed": "1",
                "showAlternateVGridColor": "0",
                "subcaptionFontBold": "0",
                "subcaptionFontSize": "14",
                "yAxisMaxValue": "400"
            },            
            "categories": [
                {
                    "category": [
                        {
                            "label": "Aditivos de Valor"
                        }, 
                        {
                            "label": "Aditivos Totais"
                        }
                    ]
                }
            ],            
            "dataset": [
                {
                    "seriesname": "Resultado",
                    "data": $scope.featureData
                }, 
                {
                    "seriesname": "Média",
                    "data": mediaFeature
                }
            ]

    };

    //Cores do termometro segundo a probabilidade
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

    //convertendo cor em rgb para hexadecimal
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

    //dados
    $scope.dados = [{"Nome":"JOSE ADEMAR DE FARIAS","Prefeitura":"ALCANTIL","NAV":20,"NAT":40,"Probabilidade":0.178},{"Nome":"RENATO MENDES LEITE","Prefeitura":"ALHANDRA","NAV":108,"NAT":178,"Probabilidade":0.06},{"Nome":"MARCELO RODRIGUES DA COSTA","Prefeitura":"ALHANDRA","NAV":75,"NAT":130,"Probabilidade":0.568},{"Nome":"JOSE ARNALDO DA SILVA","Prefeitura":"AMPARO","NAV":16,"NAT":22,"Probabilidade":0.216},{"Nome":"PAULO GOMES PEREIRA","Prefeitura":"AREIA","NAV":7,"NAT":11,"Probabilidade":0.072},{"Nome":"CICERO PEDRO MEDA DE ALMEIDA","Prefeitura":"AREIAL","NAV":35,"NAT":53,"Probabilidade":0.38},{"Nome":"MYLTON DOMINGUES DE AGUIAR MARQUES","Prefeitura":"AROEIRAS","NAV":45,"NAT":81,"Probabilidade":0.632},{"Nome":"DOUGLAS LUCENA MOURA DE MEDEIROS","Prefeitura":"BANANEIRAS","NAV":46,"NAT":86,"Probabilidade":0.496},{"Nome":"MANOEL ALMEIDA DE ANDRADE","Prefeitura":"BARRA DE SANTANA","NAV":14,"NAT":20,"Probabilidade":0.26},{"Nome":"EXPEDITO PEREIRA DE SOUZA","Prefeitura":"BAYEUX","NAV":134,"NAT":208,"Probabilidade":0.082},{"Nome":"GERVAZIO GOMES DOS SANTOS","Prefeitura":"BERNARDINO BATISTA","NAV":48,"NAT":84,"Probabilidade":0.218},{"Nome":"MARIA LEONICE LOPES VITAL","Prefeitura":"BOA VENTURA","NAV":22,"NAT":44,"Probabilidade":0.004},{"Nome":"ROBERTO BANDEIRA DE MELO BARBOSA","Prefeitura":"BOM JESUS","NAV":4,"NAT":8,"Probabilidade":0.332},{"Nome":"MARIA PAULA GOMES PEREIRA","Prefeitura":"BORBOREMA","NAV":30,"NAT":52,"Probabilidade":0.14},{"Nome":"FRANCISCO DUTRA SOBRINHO","Prefeitura":"BREJO DO CRUZ","NAV":68,"NAT":112,"Probabilidade":0.138},{"Nome":"LAURI FERREIRA DA COSTA","Prefeitura":"BREJO DOS SANTOS","NAV":42,"NAT":55,"Probabilidade":0.29},{"Nome":"LUIZ VIEIRA DE ALMEIDA","Prefeitura":"BREJO DOS SANTOS","NAV":59,"NAT":99,"Probabilidade":0.512},{"Nome":"ORISMAN FERREIRA DA NOBREGA","Prefeitura":"CACIMBA DE AREIA","NAV":11,"NAT":22,"Probabilidade":0.164},{"Nome":"NILTON DE ALMEIDA","Prefeitura":"CACIMBAS","NAV":4,"NAT":6,"Probabilidade":0.92},{"Nome":"GERALDO TERTO DA SILVA","Prefeitura":"CACIMBAS","NAV":17,"NAT":32,"Probabilidade":0.076},{"Nome":"FRANCISCA DENISE ALBUQUERQUE DE OLIVEIRA","Prefeitura":"CAJAZEIRAS","NAV":100,"NAT":167,"Probabilidade":0.084},{"Nome":"ROMERO RODRIGUES VEIGA","Prefeitura":"CAMPINA GRANDE","NAV":325,"NAT":588,"Probabilidade":0.214},{"Nome":"VENEZIANO VITAL DO REGO SEGUNDO NETO","Prefeitura":"CAMPINA GRANDE","NAV":115,"NAT":170,"Probabilidade":0.064},{"Nome":"EDVALDO CARLOS FREIRE JUNIOR","Prefeitura":"CAPIM","NAV":22,"NAT":32,"Probabilidade":0.174},{"Nome":"JOSE ARDISON PEREIRA","Prefeitura":"CARRAPATEIRA","NAV":0,"NAT":0,"Probabilidade":0.79},{"Nome":"CAIO RODRIGO BEZERRA PAIXAO","Prefeitura":"CONDADO","NAV":25,"NAT":45,"Probabilidade":0.018},{"Nome":"EDILSON PEREIRA DE OLIVEIRA","Prefeitura":"COREMAS","NAV":111,"NAT":170,"Probabilidade":0.104},{"Nome":"ANTONIO CARLOS CAVALCANTI LOPES","Prefeitura":"COREMAS","NAV":73,"NAT":105,"Probabilidade":0.658},{"Nome":"GIVALDO LIMEIRA DE FARIAS","Prefeitura":"COXIXOLA","NAV":32,"NAT":53,"Probabilidade":0.348},{"Nome":"GUILHERME CUNHA MADRUGA JUNIOR","Prefeitura":"CUITEGI","NAV":27,"NAT":41,"Probabilidade":0.582},{"Nome":"JOAQUIM ALVES BARBOSA FILHO","Prefeitura":"CURRAL VELHO","NAV":1,"NAT":3,"Probabilidade":0.834},{"Nome":"DILSON DE ALMEIDA","Prefeitura":"DESTERRO","NAV":0,"NAT":0,"Probabilidade":0.79},{"Nome":"EDSON GOMES DE LUNA","Prefeitura":"DUAS ESTRADAS","NAV":38,"NAT":69,"Probabilidade":0.382},{"Nome":"AGUIFAILDO LIRA DANTAS","Prefeitura":"FREI MARTINHO","NAV":70,"NAT":140,"Probabilidade":0.262},{"Nome":"MARIA DE FATIMA DE AQUINO PAULINO","Prefeitura":"GUARABIRA","NAV":456,"NAT":648,"Probabilidade":0.492},{"Nome":"ZENOBIO TOSCANO DE OLIVEIRA","Prefeitura":"GUARABIRA","NAV":116,"NAT":181,"Probabilidade":0.026},{"Nome":"ALDO LUSTOSA DA SILVA","Prefeitura":"IMACULADA","NAV":19,"NAT":38,"Probabilidade":0.054},{"Nome":"ANTONIO CARLOS RODRIGUES DE MELO JUNIOR","Prefeitura":"ITABAIANA","NAV":1,"NAT":3,"Probabilidade":0.834},{"Nome":"ARON RENE MARTINS DE ANDRADE","Prefeitura":"ITATUBA","NAV":42,"NAT":73,"Probabilidade":0.42},{"Nome":"ANTONIO MAROJA GUEDES FILHO","Prefeitura":"JURIPIRANGA","NAV":8,"NAT":9,"Probabilidade":0.56},{"Nome":"PAULO DALIA TEIXEIRA","Prefeitura":"JURIPIRANGA","NAV":30,"NAT":52,"Probabilidade":0.14},{"Nome":"FABIANO PEDRO DA SILVA","Prefeitura":"LAGOA DE DENTRO","NAV":60,"NAT":107,"Probabilidade":0.168},{"Nome":"WILMESON EMMANUEL MENDES SARMENTO","Prefeitura":"LASTRO","NAV":8,"NAT":15,"Probabilidade":0.092},{"Nome":"MANOEL BENEDITO DE LUCENA FILHO","Prefeitura":"MALTA","NAV":44,"NAT":87,"Probabilidade":0.59},{"Nome":"MARCOS AURELIO MARTINS DE PAIVA","Prefeitura":"MARI","NAV":39,"NAT":65,"Probabilidade":0.836},{"Nome":"ANTONIO GOMES DA SILVA","Prefeitura":"MARI","NAV":22,"NAT":26,"Probabilidade":0.694},{"Nome":"PAULO FRACINETTE DE OLIVEIRA","Prefeitura":"MASSARANDUBA","NAV":0,"NAT":0,"Probabilidade":0.79},{"Nome":"OLIMPIO DE ALENCAR ARAUJO BEZERRA","Prefeitura":"MATARACA","NAV":58,"NAT":106,"Probabilidade":0.696},{"Nome":"MARIA DE FATIMA SILVA","Prefeitura":"MATINHAS","NAV":7,"NAT":12,"Probabilidade":0.07},{"Nome":"JAIRO HERCULANO DE MELO","Prefeitura":"MONTADAS","NAV":15,"NAT":29,"Probabilidade":0.088},{"Nome":"CLAUDIA APARECIDA DIAS","Prefeitura":"MONTE HOREBE","NAV":26,"NAT":30,"Probabilidade":0.192},{"Nome":"SALVAN MENDES PEDROZA","Prefeitura":"NAZAREZINHO","NAV":53,"NAT":84,"Probabilidade":0.204},{"Nome":"JOSE FELIX DE LIMA FILHO","Prefeitura":"NOVA PALMEIRA","NAV":3,"NAT":4,"Probabilidade":0.764},{"Nome":"GRIGORIO DE ALMEIDA SOUTO","Prefeitura":"OLIVEDOS","NAV":8,"NAT":15,"Probabilidade":0.092},{"Nome":"NATALIA CARNEIRO NUNES DE LIRA","Prefeitura":"OURO VELHO","NAV":40,"NAT":56,"Probabilidade":0.39},{"Nome":"MAGNO SILVA MARTINS","Prefeitura":"PASSAGEM","NAV":17,"NAT":34,"Probabilidade":0.6},{"Nome":"JOSE ANTONIO VASCONCELOS DA COSTA","Prefeitura":"PEDRA LAVRADA","NAV":0,"NAT":0,"Probabilidade":0.79},{"Nome":"DERIVALDO ROMAO DOS SANTOS","Prefeitura":"PEDRAS DE FOGO","NAV":55,"NAT":92,"Probabilidade":0.03},{"Nome":"CLAUDIO CHAVES COSTA","Prefeitura":"POCINHOS","NAV":15,"NAT":30,"Probabilidade":0.476},{"Nome":"JOAQUIM HUGO VIEIRA CARNEIRO","Prefeitura":"RIACHO DOS CAVALOS","NAV":53,"NAT":96,"Probabilidade":0.186},{"Nome":"EMMANUEL FELIPE LUCENA MESSIAS","Prefeitura":"SANTA HELENA","NAV":9,"NAT":15,"Probabilidade":0.066},{"Nome":"JAIRO HALLEY DE MOURA CRUZ","Prefeitura":"SERRA GRANDE","NAV":65,"NAT":106,"Probabilidade":0.114},{"Nome":"FLAVIO AURELIANO DA SILVA NETO","Prefeitura":"SOLEDADE","NAV":33,"NAT":60,"Probabilidade":0.242},{"Nome":"ANDRE AVELINO DE PAIVA GADELHA NETO","Prefeitura":"SOUSA","NAV":65,"NAT":109,"Probabilidade":0.088},{"Nome":"AILTON NIXON SUASSUNA PORTO","Prefeitura":"TAVARES","NAV":67,"NAT":102,"Probabilidade":0.25},{"Nome":"EDMILSON ALVES DOS REIS","Prefeitura":"TEIXEIRA","NAV":70,"NAT":118,"Probabilidade":0.148},{"Nome":"WENCESLAU SOUZA MARQUES","Prefeitura":"TEIXEIRA","NAV":34,"NAT":65,"Probabilidade":0.924}]
}])
