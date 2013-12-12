var color_scale_indicador = ["#006400","#92B879","#E0E0E0","#E0E0E0","#E0E0E0","#FFFF00","#FF7F00","#ff3333"];
var color_scale_cidades = ["#003300","#6b954f","#C0C0C0","#C0C0C0","#C0C0C0","#FFCC00","#CC5200","#670000"];

var color_scale_meso = ["#F0F0F0","#E0E0E0","#F0F0F0"];
var color_scale_cidades_meso = ["#F0F0F0","#C0C0C0","#F0F0F0"];
var estado_faixas = [];

function get_color_scale(indicador){
//	if (indicador == "INDICADOR_???"){
//		return outra_color_scale;
//	}
	return color_scale_cidades
}

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

	estado_faixas = bounds.map(function(d){ return {'x': d, 'y': h1};}).sort(function(a, b){ 
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
		
	plotTitulosGraficos(svg, indicador, current_year,cidade.NOME_MESO,cidade.NOME_MICRO);
	
	plot_bar(svg, estado, estado_faixas, x_start, x_end, color_scale_indicador,indicador);
	plot_bar(svg, meso, meso_faixas, x_start, x_end, color_scale_meso,indicador);
	plot_bar(svg, micro, micro_faixas, x_start, x_end, color_scale_meso,indicador);
	
	plot_cidades(svg,micro,micro_faixas,x_start, x_end, indicador, color_scale_cidades_meso);
	plot_cidades(svg,meso,meso_faixas,x_start, x_end, indicador, color_scale_cidades_meso);
	plot_cidades(svg,estado,estado_faixas,x_start, x_end, indicador, get_color_scale(indicador));
	
	plot_cidade(svg,estado_faixas, x_start, x_end,cidade,indicador);
	
}

function plot_bar(svg_element, cidades, faixas, x_start, x_end, color_scale,indicador){
	
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
					.tickFormat(function(d){return get_legend(d, indicador);});
	
	var g = svg_element.append("g").attr("class", "x axis").attr("transform", "translate(0," + (y_default + 13) + ")").call(xAxis);
	
	var line_bar = svg_element.append("g").attr("id", "estado_bar");
	
	var lines = line_bar.selectAll("line")
						.data(faixas)
						.enter()
						.append("line")
						.transition().duration(1000).delay(200)
						.attr("x1", x_scale(min_x))
						.attr("x2", function(d){ return x_scale(d.x);})
						.attr("y1",y_default)
						.attr("y2",y_default)
						.attr("id","barra_indicador_altura_" + y_default)
						.style("stroke",function(d,i){return color_scale[i]})
						.attr("stroke-width",25);
}

function plot_cidades(svg,cidades, faixas, x_start, x_end, indicador, color_scale){
    var min_x = faixas[faixas.length-1].x;
	var max_x = faixas[0].x;
	var y_default = faixas[0].y;
	
	cidades = cidades.filter(function(d){return d[indicador] != "NA";});
	var mapa_municipios = geraMapa(cidades,indicador);
	
	var x_scale = d3.scale.linear()
				    .domain([parseFloat(min_x), parseFloat(max_x)])
				    .range([x_start, x_end]);
	
	var cidade_line = svg.append("g").attr("id","cidade_bar");

	var lines = cidade_line.selectAll("line")
						.data(cidades)
						.enter()
						.append("line")
						.attr("x1", function(d){ return x_scale(d[indicador]);})
						.attr("x2", function(d){ return x_scale(d[indicador]) + 2;})
						.attr("y1",y_default)
						.attr("y2",y_default)
						.attr("id","barra_indicador_altura_" + y_default)
						.style("stroke",function(d){ return get_cor_indicador(indicador, d[indicador], faixas, color_scale); })
						.attr("opacity",0.6)
						.attr("stroke-width",25)
						.on("mouseover", function(d) {
                                                var key_valorIndicador = d3.format(".2f")(d[indicador]);
                                                var nomesMunicipios = d.NOME_MUNICIPIO;
												var tipo = dicionario.filter(function(d){return d.id == indicador;})[0].Porcentagem;
                                                if(typeof mapa_municipios[key_valorIndicador] == "object"){
                                                        nomesMunicipios = mapa_municipios[key_valorIndicador].join(", ");
                                                }                        
                                                
                                                var xPosition = $(this).offset().left;
                                                var yPosition = $(this).offset().top - 50;
												d3.select("#tooltip").style("left", xPosition + "px")
                                                .style("top", yPosition + "px")
                                                .select("#value").text(nomesMunicipios + ": " + get_legend(d[indicador], indicador));
                                                d3.select("#tooltip").classed("hidden", false);
                                        })
                                
                                        .on("mouseout", function() {
                                                d3.select("#tooltip").classed("hidden", true);
                                        });
										

}

function get_cor_indicador(indicador, valor, faixa, color_scale){
	var filtro = faixa.filter(function(d){
		return valor <= d.x;
	});

	var min_v_faixa = filtro[filtro.length-1]
	
	filtro = faixa.filter(function(d){
		return d.x == min_v_faixa.x 
	});
	
	return color_scale[faixa.indexOf(filtro[valor == min_v_faixa?0:filtro.length-1])];
}


function plot_cidade(svg, faixas, x_start, x_end, cidade, indicador){
	var min_x = faixas[faixas.length-1].x;
	var max_x = faixas[0].x;
	var y_default = faixas[0].y;
	
	var x_scale = d3.scale.linear()
				    .domain([parseFloat(min_x), parseFloat(max_x)])
				    .range([x_start, x_end]);

	svg.append("line")
			  .transition().duration(500).delay(1000)
			  .attr("x1", x_scale(cidade[indicador]))
			  .attr("x2", x_scale(cidade[indicador]) + 1)
			  .attr("y1" , 50)
			  .style("stroke-dasharray", ("5, 3"))
			  .attr("y2", 190)//256
			  .attr("stroke","black");
			  
    svg.append("text")
            .attr("x", x_scale(cidade[indicador]))
            .attr("y",40)
            .attr("text-anchor", "middle")
            .attr("font-weight", "bold")
            .transition().duration(500).delay(1000)
            .text( cidade.NOME_MUNICIPIO + ": " +get_legend(cidade[indicador], indicador));  
}

function get_legend(cidade, indicador){
	var tipo_indicador = dicionario.filter(function(d){return d.id == indicador;})[0];
	if(tipo_indicador.Porcentagem == "1"){
		return formatNum(parseFloat(cidade).toFixed(2))+"%";
	}else if(tipo_indicador.Porcentagem == "0"){
		return "R$ " + (formatNum(parseFloat(cidade).toFixed(2)));
	}
	return (formatNum(parseFloat(cidade).toFixed(2)));
}

function geraMapa(tabela,indicador){
        mapa = {}
        for(var i=0;i<tabela.length;i++){
                var obj = tabela[i];
                var id = d3.format(".2f")(obj[indicador]) + "";
                if(typeof mapa[id] == "undefined"){
                        mapa[id] = new Array(0);
                        mapa[id].push(obj["NOME_MUNICIPIO"]);
                }else{
                        mapa[id].push(obj["NOME_MUNICIPIO"]);
                }
        }
        return mapa
}

Array.prototype.contains = function(obj) {
    var i = this.length;
    while (i--) {
        if (this[i] === obj) {
            return true;
        }
    }
    return false;
}

function getCurrentYearNotNA(data, cidade, indicador) {
    
    var city = data.filter(function(d){return d.NOME_MUNICIPIO == cidade && d[indicador] != "NA";});
    var value = city.map(function(d){return d[indicador];});
    var years = city.map(function(d){return d.ANO;});

    return current_year = d3.max(years);   
}

function plotTitulosGraficos(svg,indicador, ano, micro, meso){

	var nome_indicador = dicionario.filter(function(d){if (d.id == indicador) return d.name;});
    nome_indicador = nome_indicador.map(function(d){return d.name;});	

	var legenda_regioes = [{'nome': "Paraíba", 'h': 60}, {'nome': meso, 'h': 120}, {'nome': micro, 'h': 180},
						{'nome': "(Mesorregião)", 'h': 134}, {'nome':"(Microrregião)",'h':194}];
	
    d3.select("#plot_area").selectAll("h1").remove();

    d3.select("#div_nome_cidade")
    .append("h1")
    .attr("class", "nome_cidade")
    .text(cidade + " - " + ano);
    
    d3.select("#div_indicador_titulo")
    .append("h1")
    .attr("class", "titulo_grafico")
    .text(nome_indicador);
		
	svg.selectAll("text").data(legenda_regioes).enter().append("text")
		.attr("y", function(d){return d.h;})
		.attr("x",10)
		.attr("font-weight", "bold")
		.style("text-align", "center")
		.text(function(d){return d.nome;});
}
