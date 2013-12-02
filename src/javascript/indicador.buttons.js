



//Carrega os botoes da parte de cima
function loadUpButtons(data) {
	
		data.sort(function (a, b) {
				return a.name.localeCompare(b.name);
		});

		var div_buttons = d3.select("#div_indicador_options");

		div_buttons.selectAll("input")
			.data(data)
			.enter()
			.insert("span")
			.attr("class", "tooltips")
			.attr("title", function (d){return d.big_description;})
			.attr("id", function (d, i){return "span"+d.id;})
			.each(function(d) {
				d3.select(this).append("input")
				.attr("type","button")
				.attr("value", function (d){return d.name.replace("(%)","").replace("(em Reais)","");})
				.attr("id", function (d, i){return d.id;})
		        .attr("class", "indicador indicador_map")
		        .on("click", function(d) {
		        	
					if(cidade == "Visão Geral"){
						$("#map_title")
						.text(d.name.replace("(%)","").replace("(em Reais)",""));
						plotColorMap(d.id, d.desvio, dataset);

					}
				
				});
			});

}

