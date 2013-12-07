
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

function plot_bars(data, cidade_nome, indicador){

	var h1 = 60;
	var	h2 = h1 + 60;
	var h3 = h2 + 60;
	var h4 = h3 + 60;

	var current_year = getCurrentYearNotNA(data, cidade_nome, indicador);
	
	var bounds = desvios.filter(function(d){return d.indicador == indicador && d.ano == current_year})[0]
					.bounds
					.map(parseFloat);
	
	var estado = data.filter(function(d){return d.ANO == current_year;});
	
	var cidade = estado.filter(function(d){return d.NOME_MUNICIPIO == cidade_nome})[0];

	var meso = estado.filter(function(d){return d.NOME_MESO == cidade.NOME_MESO;});

	var micro = rawdata.filter(function(d){return d.NOME_MICRO == cidade.NOME_MICRO;});

	var estado_faixas = bounds.map(function(d){ return {'x': d, 'y': h1};}).sort(function(a, b){ 
		return d3.descending(a.x, b.x); 
	});;
					
	var meso_faixas =[
	                  {'x': (d3.max(estado,function(d){return parseFloat(d[indicador]);})), 'y' : h2},
	                  {'x': (d3.max(meso,function(d){return parseFloat(d[indicador]);})), 'y' : h2},
	               	  {'x' : d3.min(meso,function(d){return parseFloat(d[indicador]);}) , 'y' : h2}, 
	                  {'x' : d3.min(estado,function(d){return parseFloat(d[indicador]);}) , 'y' : h2}
					];
		
	var micro_faixas = [
	                    {'x': (d3.max(estado,function(d){return parseFloat(d[indicador]);})), 'y' : h3},
	                    {'x': (d3.max(micro,function(d){return parseFloat(d[indicador]);})), 'y' : h3},
    					{'x' :d3.min(micro,function(d){return parseFloat(d[indicador]);}) , 'y' : h3},
						{'x' : d3.min(estado,function(d){return parseFloat(d[indicador]);}) , 'y' : h3}
						];
	
	var width = 800;
	var height = 300;
	var x_start = 120;
	var x_end = 750;
	    
	var svg = d3.select('#div_indicador')
		.append("svg")
		.attr('width', width)
		.attr('height', height);
	
	plot_bar(svg, estado, estado_faixas, x_start, x_end, color_scale_indicador);
	//plot_bar(svg, meso, meso_faixas, x_start, x_end, color_scale_meso);
	//plot_bar(svg, micro, micro_faixas, x_start, x_end, color_scale_meso);

}

var color_scale_indicador = [
	"#006400",
	"#92B879", 
	"#FFFF00", 
	"#FF7F00", 
	"#E0E0E0", 
	"#FF0000",
	"#F0F0F0" 
];

var color_scale_meso = [
	"#F0F0F0",
	"#E0E0E0",
	"#F0F0F0"
];



function plot_bar(svg_element, cidades, faixas, x_start, x_end, color_scale){
	
	var min_x = faixas[faixas.length-1].x;
	var max_x = faixas[0].x;
	var y_default = faixas[0].y;
	
	var x_scale = d3.scale.linear()
				    .domain([parseFloat(min_x), parseFloat(max_x)])
				    .range([x_start, x_end]);	
	
	var xAxis = d3.svg.axis()
					.scale(x_scale)
					.orient("bottom")
					.tickValues([parseFloat(min_x),parseFloat(max_x)])
					.tickFormat(function(d){return formatNum(  (d3.format(".2f")(d)) );});
	
	var g = svg_element.append("g").attr("class", "x axis").attr("transform", "translate(0," + (y_default + 13) + ")").call(xAxis);
	
	var line_bar = svg_element.append("g").attr("id", "estado_bar");
	
	var lines = line_bar.selectAll("line")
						.data(faixas)
						.enter()
						.append("line")
						.attr("x1", x_scale(min_x))
						.attr("x2", function(d){ return x_scale(d.x);})
						.attr("y1",y_default)
						.attr("y2",y_default)
						.attr("id","barra_indicador_altura_" + y_default)
						.style("stroke",function(d,i){return color_scale[i]})
						//.attr("opacity",0.2)
						.attr("stroke-width",25)
	
	
}

function getCurrentYearNotNA(data, cidade, indicador) {
    

    var city = data.filter(function(d){return d.NOME_MUNICIPIO == cidade && d[indicador] != "NA";});
    var value = city.map(function(d){return d[indicador];});
    var years = city.map(function(d){return d.ANO;});

    return current_year = d3.max(years);

   
}

