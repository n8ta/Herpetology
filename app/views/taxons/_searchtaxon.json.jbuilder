json.id taxon.id
json.name taxon.sci_name
json.venomous taxon.venomous if taxon.rank == "species"
json.common_name taxon.common_name