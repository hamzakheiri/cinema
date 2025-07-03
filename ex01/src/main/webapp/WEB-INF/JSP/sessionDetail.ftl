<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Session Details</title>
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 30px; }
        .session-card {
            background-color: #fff;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 30px;
            margin-bottom: 30px;
        }
        .poster-container {
            text-align: center;
            margin-bottom: 20px;
        }
        .poster-img {
            max-width: 300px;
            max-height: 400px;
            object-fit: cover;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
        }
        .session-info h2 {
            color: #343a40;
            margin-bottom: 20px;
        }
        .info-row {
            margin-bottom: 15px;
            padding: 10px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
        .info-label {
            font-weight: bold;
            color: #495057;
        }
        .info-value {
            color: #212529;
        }
        .back-button {
            margin-top: 20px;
        }
        .error-message {
            text-align: center;
            margin-top: 50px;
        }
    </style>
</head>
<body>
<div class="container">
    <#assign ctx = request.contextPath>
    
    <#if error??>
        <div class="error-message">
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-heading">Error!</h4>
                <p>${error}</p>
            </div>
            <a href="${ctx}/sessions" class="btn btn-primary">Back to Search</a>
        </div>
    <#elseif session??>
        <div class="session-card">
            <div class="row">
                <!-- Movie Poster -->
                <div class="col-md-4">
                    <div class="poster-container">
                        <#if session.film.posterUrl?? && session.film.posterUrl != "">
                            <img src="${ctx}/images/${session.film.posterUrl}" alt="${session.film.title} Poster" class="poster-img">
                        <#else>
                            <img src="https://via.placeholder.com/300x400?text=No+Poster" alt="No Poster" class="poster-img">
                        </#if>
                    </div>
                </div>
                
                <!-- Session Information -->
                <div class="col-md-8">
                    <div class="session-info">
                        <h2>${session.film.title}</h2>
                        
                        <div class="info-row">
                            <span class="info-label">Session ID:</span>
                            <span class="info-value">#${session.id}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Movie Title:</span>
                            <span class="info-value">${session.film.title}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Release Year:</span>
                            <span class="info-value">${session.film.year}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Age Restrictions:</span>
                            <span class="info-value">${session.film.ageRestrictions}+</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Description:</span>
                            <span class="info-value">${session.film.description}</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Hall:</span>
                            <span class="info-value">${session.hall.serialNumber} (${session.hall.seats} seats)</span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Session Time:</span>
                            <span class="info-value">
                                <#if session.sessionTime?is_string>
                                    ${session.sessionTime?replace("T", " ")}
                                <#else>
                                    ${session.sessionTime?string("MMM dd, yyyy 'at' HH:mm")}
                                </#if>
                            </span>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Ticket Cost:</span>
                            <span class="info-value">$${session.ticketCost}</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Action Buttons -->
            <div class="row">
                <div class="col-12">
                    <div class="back-button">
                        <a href="${ctx}/sessions" class="btn btn-secondary">Back to Search</a>
                    </div>
                </div>
            </div>
        </div>
    <#else>
        <div class="error-message">
            <div class="alert alert-warning" role="alert">
                <h4 class="alert-heading">No Session Data</h4>
                <p>No session information available.</p>
            </div>
            <a href="${ctx}/sessions" class="btn btn-primary">Back to Search</a>
        </div>
    </#if>
</div>

<!-- Bootstrap JS Bundle -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
