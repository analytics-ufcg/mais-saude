
var dataset = [];
var dicionario = [];
var desvios = [];
var medianas = [];
var cidade = 0;
var cidades = [];
var dataset_cidade = [];
var cidade_ano_nao_na = [];
var verde = {
	'botao': "indicador_verde2",
	'faixa':  "#006400",
	'cidade': "#003300",
	'valor': 0
};
var verde_claro = {
	'botao': "indicador_verde",
	'faixa':  "#92B879",
	'cidade': "#6b954f",
	'valor': 1
};
var branco = {
	'botao': "indicador_branco",
	'faixa':  "#E0E0E0",
	'cidade': "#C0C0C0",
	'valor': 2
};
var amarelo = {
	'botao': "indicador_amarelo",
	'faixa':  "#FFFF00",
	'cidade': "#FFCC00",
	'valor': 3
};
var laranja = {
	'botao': "indicador_laranja",
	'faixa':  "#FF7F00",
	'cidade': "#CC5200",
	'valor': 4
};
var vermelho = {
	'botao': "indicador_vermelho",
	'faixa':  "#ff3333",
	'cidade': "#670000",
	'valor': 5
};
var cinza = {
	'botao': "indicador_cinza",
	'faixa':  "#FFFFFF",
	'cidade': "#FFFFFF",
	'valor': 6
};
var cinza_claro = {
	'botao': "indicador_cinza_claro",
	'faixa':  "#F0F0F0",
	'cidade': "#C0C0C0",
	'valor': 7
};

var color_scale_buttons_ascending = [verde, verde_claro, branco, branco, branco, amarelo, laranja, vermelho, vermelho];
var color_scale_buttons_descending = [vermelho, laranja, amarelo, branco, branco, branco, verde_claro, verde, verde];
var color_scale_buttons_middle = [vermelho, laranja, amarelo, branco, branco, amarelo, laranja, vermelho, vermelho];

var color_scale_meso = [cinza_claro, branco, cinza_claro, cinza_claro];


// carrega dados e preenche botões iniciais
function loadData() {

	d3.csv("data/indicadores.csv" , function (data){		
		dataset = data;
		
		cidades = data.filter(function(d){return d.ANO == "2012"})
			.map( function(d){
				return {
					'COD_MUNICIPIO' : d.COD_MUNICIPIO, 
					'NOME_MUNICIPIO' : d.NOME_MUNICIPIO
				};})
			.sort( function(a,b){ 
				return a.NOME_MUNICIPIO.localeCompare(b.NOME_MUNICIPIO);
			});
			
		cidades.unshift({COD_MUNICIPIO:"0", NOME_MUNICIPIO:"Visão Geral"})
		
		loadUpCities(cidades);
		
		resetMap(dataset);

	});

	d3.csv("data/dicionario.csv" , function (data){
		dicionario = data;
		// Carrega os buttons de indicadores no arquivo indicador.buttons.js
		loadUpButtons(dicionario);
	});

	d3.csv("data/desvios.csv" , function (data){
		desvios = data.map(function(d){ return {
			indicador: d.indicador,
			ano: d.ano,
			bounds: [d.min, d.q4neg, d.q3neg, d.q2neg, d.q0, d.q2, d.q3, d.q4, d.max].map(parseFloat).sort(d3.descending)
	    }});
	});

	d3.csv("data/centro.csv" , function (data){
		medianas = data;
	});

	// ativa o icone back to map
	$("#button_back_map").click(function() { 	
			var selection = $("#myList").val(0);
			selection.change();
	});

};

// preenche lista de cidades em ordem alfabética
function loadUpCities(cidades) {
		var myList = d3.selectAll("#myList");
		
		myList.selectAll("option").data(cidades).enter().append("option")
			.attr("value",function(d){return d.COD_MUNICIPIO;})
			.attr("label",function(d){return d.NOME_MUNICIPIO;})
			.attr("data-icon", "icon-map-marker")
			.text(function(d){return d.NOME_MUNICIPIO;})
		;
		$('.selectpicker').selectpicker({'selectedText': 'cat'});
}

// retorna o valor (não NA) do indicador para a cidade no ano mais atual 
function getCurrentYearNotNA(cod_cidade, indicador) {
    var tmp = dataset.filter(function(d){return d.COD_MUNICIPIO == cod_cidade && d[indicador] != "NA";});
    return current_year = d3.max(tmp.map(function(d){return d.ANO;}));   
}

// calcula índice para a cor do indicador (usado para escolher a cor do botão, faixa, cidade; e para ordenar)
function calc_index_cor_indicador(indicador, valor, faixa){
	var filtro = faixa.filter(function(d){
		return valor > d;
	});
	
	var index = faixa.indexOf(faixa[faixa.indexOf(filtro[0])-1]);
	
	return index == -1? faixa.indexOf(faixa[faixa.length-1]):index;
}

Array.prototype.unique = function() {
    var o = {}, i, l = this.length, r = [];
    for(i=0; i<l;i+=1) o[this[i]] = this[i];
    for(i in o) r.push(o[i]);
    return r;
};


function formatNum(numero) {
    var n= numero.toString().split(".");
    n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    return n.join(",");
}

// retorna a escala certa para o indicador
function get_color_scale_buttons(indicador){
	var referencial = dicionario.filter(function(d){
		return	d.id == indicador;
	})[0].referencial_maior;
	
	if( referencial == "melhor" ){
		return color_scale_buttons_ascending;
	} else if ( referencial == "pior") {
		return color_scale_buttons_descending;
	} else {
		return color_scale_buttons_ascending; // color_scale_buttons_middle
	}
}


