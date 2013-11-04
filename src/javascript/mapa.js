
//compara unicode characters
function sortComparer(a,b){
 return a.localeCompare(b);
};

/*Inicio - funcao para formatar os números - iury - 30/09*/
function formatNum(numero) {
    var n= numero.toString().split(".");
    n[0] = n[0].replace(/\B(?=(\d{3})+(?!\d))/g, ".");
    return n.join(",");
}
/*Fim - funcao para formatar os números - iury - 30/09*/

function resetMap(dataset) {
	$("#map_title").text("Escolha uma Cidade ou um Indicador para mais detalhes.");
	var todas_cidades = dataset.map(function(d){return d.NOME_MUNICIPIO;}).unique().sort(sortComparer);
	var div_municipios = d3.select("#Municípios");


	//laço que itera em todas as cidades do mapa
	for (var i = 0; i < todas_cidades.length; i++) {
		var cidade = todas_cidades[i].replace(/ /g, "_");
		if(cidade == "Mãe_d'Água" || cidade == "Olho_d'Água") {
			cidade = cidade.replace(/'/, "_");
		}


		var cidadeID = div_municipios.select("#" + cidade);
		cidadeID.attr("class", "fil5 str2");

		//mouse over
		cidadeID.on("mouseover", function(d) {
			var cidadeID = $(this);
			cidadeID.attr("class", "str2 " + "fil0");

			var xPosition = cidadeID.offset().left + 100;
			var yPosition = cidadeID.offset().top;

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}
			d3.select("#tooltip").style("left", xPosition + "px")
			.style("top", yPosition + "px")
			.select("#value").text(cidade);

			d3.select("#tooltip").classed("hidden", false);
		});
		
		//mouse out
		cidadeID.on("mouseout", function(d) {
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			cidadeID.attr("class", "fil5 str2");

			d3.select("#tooltip").classed("hidden", true);
		});

		cidadeID.on("click", function(d){
			var cidadeID = $(this);

			var cidade = cidadeID.attr("id").replace(/_/g, " ");

			if(cidade == "Mãe d Água" || cidade == "Olho d Água") {
				cidade = cidade.replace(/d Água/, "d'Água");
			}

			var selection = $("#myList").val(cidade);

			selection.change();

		});
	};
}