
function plot_barra_indicador(cidade, indicador_nome) {
   //console.log(cidade);
  
  if(dataset!='null'){
    plot_bars(dataset, cidade, indicador_nome);
  }
  else{
    d3.csv("data/tabela_com_todos_os_indicadores_selecionados_e_desvios.csv" , function (data){   
      plot_bars(data, cidade, indicador_nome);
    });
  }
}

var bounds;

function plot_bars(data, cidade_nome, indicador){

	var h1 = 60;
	var	h2 = h1 + 60;
	var h3 = h2 + 60;
	var h4 = h3 + 60;

	var current_year = getCurrentYearNotNA(data, cidade_nome, indicador);
	
	var rawdata = data.filter(function(d){return d.ANO == current_year;});
	console.log(rawdata);

	bounds = desvios.filter(function(d){return d.indicador == indicador && d.ano == current_year});

	var estado = rawdata;
	
	var cidade = estado.filter(function(d){return d.NOME_MUNICIPIO == cidade_nome})[0];

	var meso = estado.filter(function(d){return d.NOME_MESO == cidade.NOME_MESO;});

	var micro = rawdata.filter(function(d){return d.NOME_MICRO == cidade.NOME_MICRO;});

	var line_estado = bounds.bounds.map(function(d){ return {'x': d, 'y': h1};});
					
	var line_meso =[{'x' : d3.min(meso,function(d){return parseFloat(d[indicador]);}) , 'y' : h2}, 
						{'x': (d3.max(meso,function(d){return parseFloat(d[indicador]);})), 'y' : h2}];
		
	var line_micro = [{'x' :d3.min(micro,function(d){return parseFloat(d[indicador]);}) , 'y' : h3},
						  {'x': (d3.max(micro,function(d){return parseFloat(d[indicador]);})), 'y' : h3}];

	console.log(line_estado);
}


function getCurrentYearNotNA(data, cidade, indicador) {
    

    var city = data.filter(function(d){return d.NOME_MUNICIPIO == cidade && d[indicador] != "NA";});
    var value = city.map(function(d){return d[indicador];});
    var years = city.map(function(d){return d.ANO;});

    return current_year = d3.max(years);

   
}

