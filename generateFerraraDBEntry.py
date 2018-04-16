#!/usr/bin/python3

import sys
from mysql import MySQL

try:
    db = MySQL("localhost", "3306", "web", "Password", "web", "utf8")
except Exception as e:
    raise Exception('Database Error')

if __name__ == "__main__":
    pageCategorieID = input("categorie + id (e.g. gRestaurants1): ")
    name = input("Name: ")
    address = input("Address: ")
    url = input("URL")
    textDEU = input("German Text: ")
    textENG = input("Engish Text: ")
    textIT = input("Italien Text: ")
    databaseIDforCarousel = input("Next Database ID (used for carousel): ")

    print("Pictures: Upload path is uploads/pictures (4 paths seperated with enter)")
    picture1 = input("1: ")
    picture2 = input("2: ")
    picture3 = input("3: ")
    picture4 = input("4: ")


    print("German Text:")
    print('<div class="col-md-6"><p class="undercatparagraph" data-toggle="modal" href="#' + pageCategorieID + '" style="color:rgb(255,255,255);background-image:url(&quot;' + picture1 + '&quot;);">' + name + '</p><div class="modal fade" role="dialog" tabindex="-1" id=\"' + pageCategorieID + '"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title">' + name + '</h4></div><div class="modal-body"><div class="carousel slide" data-ride="carousel" id="carousel-' + databaseIDforCarousel + '"><div class="carousel-inner" role="listbox"><div class="item active"><img src="' + picture2 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture3 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture4 + '" alt="Slide Image" class="slideimg"></div></div><div><a class="left carousel-control" href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="prev"><i class="glyphicon glyphicon-chevron-left" style="color:#ffffff;"></i><span class="sr-only">Previous</span></a><a class="right carousel-control"href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="next"><i class="glyphicon glyphicon-chevron-right" style="color:#ffffff;"></i><span class="sr-only">Next</span></a></div><ol class="carousel-indicators"><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="0" class="active"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="1"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="2"></li></ol></div><p class="modaltext">' + address + ' - ' + textDEU + '<br></p><p class="modaltextlink"><a href="' + url + '">' + url + '</a><br></p></div></div></div></div></div>')

    print("English Text:")
    print('<div class="col-md-6"><p class="undercatparagraph" data-toggle="modal" href="#' + pageCategorieID + '" style="color:rgb(255,255,255);background-image:url(&quot;' + picture1 + '&quot;);">' + name + '</p><div class="modal fade" role="dialog" tabindex="-1" id=\"' + pageCategorieID + '"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title">' + name + '</h4></div><div class="modal-body"><div class="carousel slide" data-ride="carousel" id="carousel-' + databaseIDforCarousel + '"><div class="carousel-inner" role="listbox"><div class="item active"><img src="' + picture2 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture3 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture4 + '" alt="Slide Image" class="slideimg"></div></div><div><a class="left carousel-control" href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="prev"><i class="glyphicon glyphicon-chevron-left" style="color:#ffffff;"></i><span class="sr-only">Previous</span></a><a class="right carousel-control"href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="next"><i class="glyphicon glyphicon-chevron-right" style="color:#ffffff;"></i><span class="sr-only">Next</span></a></div><ol class="carousel-indicators"><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="0" class="active"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="1"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="2"></li></ol></div><p class="modaltext">' + address + ' - ' + textENG + '<br></p><p class="modaltextlink"><a href="' + url + '">' + url + '</a><br></p></div></div></div></div></div>')

    print("Italian Text:")
    print('<div class="col-md-6"><p class="undercatparagraph" data-toggle="modal" href="#' + pageCategorieID + '" style="color:rgb(255,255,255);background-image:url(&quot;' + picture1 + '&quot;);">' + name + '</p><div class="modal fade" role="dialog" tabindex="-1" id=\"' + pageCategorieID + '"><div class="modal-dialog" role="document"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title">' + name + '</h4></div><div class="modal-body"><div class="carousel slide" data-ride="carousel" id="carousel-' + databaseIDforCarousel + '"><div class="carousel-inner" role="listbox"><div class="item active"><img src="' + picture2 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture3 + '" alt="Slide Image" class="slideimg"></div><div class="item"><img src="' + picture4 + '" alt="Slide Image" class="slideimg"></div></div><div><a class="left carousel-control" href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="prev"><i class="glyphicon glyphicon-chevron-left" style="color:#ffffff;"></i><span class="sr-only">Previous</span></a><a class="right carousel-control"href="#carousel-' + databaseIDforCarousel + '" role="button" data-slide="next"><i class="glyphicon glyphicon-chevron-right" style="color:#ffffff;"></i><span class="sr-only">Next</span></a></div><ol class="carousel-indicators"><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="0" class="active"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="1"></li><li data-target="#carousel-' + databaseIDforCarousel + '" data-slide-to="2"></li></ol></div><p class="modaltext">' + address + ' - ' + textIT + '<br></p><p class="modaltextlink"><a href="' + url + '">' + url + '</a><br></p></div></div></div></div></div>')

    if (input("Write changes to database? (Write YES): ") == "YES"):
        lastinsertedid = db.update("UPDATE CONTENT SET de = %s, en = %s, it = %s WHERE id = %s" % textDEU, textENG, textIT, databaseIDforCarousel):
        print("Done, last inserted ID: %d" % lastinsertedid)
        sys.exit();
    else:
        print("Database unchanged!")
        sys.exit();
