
<#assign ctx = request.contextPath>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Live Search - Movie Sessions</title>
    <!-- Bootstrap CSS CDN for styling -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <!-- jQuery CDN for AJAX -->
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <style>
        body { background-color: #f8f9fa; }
        .search-container { margin: 20px auto; max-width: 600px; }
        .results-container { margin-top: 30px; }
        .result-card {
            text-align: center;
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .result-card img {
            width: 120px;
            height: 120px;
            object-fit: cover;
            background-color: #eee;
            border-radius: 4px;
        }
        .result-card p { margin: 10px 0 5px; }
    </style>
    <script>
        // Expose the FreeMarker variable "ctx" to JavaScript
        var ctx = "${ctx}";

        $(document).ready(function() {
            $("#searchInput").on("keyup", function() {
                var filmName = $(this).val().trim();
                if (filmName.length > 1) {  // Trigger search if more than one character is entered
                    $.ajax({
                        url: ctx + "/sessions/search",
                        method: "GET",
                        data: { filmName: filmName },
                        dataType: "json",
                        success: function(data) {
                            $("#resultsList").empty();
                            if (data.sessions && data.sessions.length > 0) {
                                $.each(data.sessions, function(index, session) {
                                    var colDiv = $("<div class='col-md-3 col-sm-6 result-card'></div>");
                                    if (session.film && session.film.posterUrl) {
                                        colDiv.append("<img src='" + ctx + "/images/" + session.film.posterUrl + "' alt='Poster'>");
                                    } else {
                                        colDiv.append("<img src='https://via.placeholder.com/120x120?text=No+Poster' alt='Poster'>");
                                    }
                                    colDiv.append("<p><strong>Title:</strong> " + session.film.title+ "</p>");
                                    colDiv.append("<p><strong>Date & Time:</strong> " + session.dateTime + "</p>");
                                    colDiv.append("<p><strong>Ticket Cost:</strong> " + session.ticketCost + "</p>");
                                    // colDiv.append("<a href='" + ctx + "/sessions/" + session.id + "'>View Session</a>");
                                    $("#resultsList").append(colDiv);
                                });
                            } else {
                                $("#resultsList").append("<p class='col-12 text-center'>No matching sessions found.</p>");
                            }
                        },
                        error: function(xhr, status, error) {
                            console.error("AJAX error:", status, error);
                            $("#resultsList").html("<p class='col-12 text-center text-danger'>Error retrieving data.</p>");
                        }
                    });
                } else {
                    $("#resultsList").empty();
                }
            });
        });
    </script>
</head>
<body>
<div class="container">
    <!-- Search Bar -->
    <div class="search-container">
        <input type="text" id="searchInput" class="form-control" placeholder="Search by film title...">
    </div>
    <!-- Results Grid -->
    <div class="row results-container" id="resultsList">
        <!-- AJAX-injected session cards will appear here -->
    </div>
</div>
</body>
</html>
