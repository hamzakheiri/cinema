<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Movie Sessions Administration</title>
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body { background-color: #f8f9fa; }
        .container { margin-top: 30px; }
        .header { margin-bottom: 20px; }
        .table-responsive { margin-top: 20px; }
        .form-container { margin-top: 40px; background-color: #fff; padding: 20px; border-radius: 5px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
    </style>
</head>
<body>
<div class="container">
    <h1 class="header text-center">Movie Sessions Administration</h1>

    <!-- Sessions List -->
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
            <tr>
                <th>Movie</th>
                <th>Hall</th>
                <th>Session Time</th>
                <th>Ticket Cost</th>
            </tr>
            </thead>
            <tbody>
            <#if sessions?? && (sessions?size > 0)>
                <#list sessions as session>
                    <tr>
                        <td>${session.film.title}</td>
                        <td>${session.hall.serialNumber}</td>
                        <td>${session.sessionTime}</td>
                        <td>${session.ticketCost}</td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="4" class="text-center">No sessions available.</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <!-- Form to Create a New Session -->
    <div class="form-container">
        <h3>Create New Session</h3>
        <#assign ctx = request.contextPath>
        <form action="${ctx}/admin/panel/sessions" method="post">
            <div class="form-group">
                <label for="filmId">Select Movie</label>
                <select id="filmId" name="filmId" class="form-control" required>
                    <#list films as movie>
                        <option value="${movie.id}">${movie.title}</option>
                    </#list>
                </select>
            </div>
            <div class="form-group">
                <label for="hallId">Select Movie Hall</label>
                <select id="hallId" name="hallId" class="form-control" required>
                    <#list halls as hall>
                        <option value="${hall.id}">${hall.serialNumber}</option>
                    </#list>
                </select>
            </div>
            <div class="form-group">
                <label for="sessionTime">Session Time</label>
                <input type="datetime-local" id="sessionTime" name="sessionTime" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="ticketPrice">Ticket Cost</label>
                <input type="number" id="ticketPrice" name="ticketPrice" class="form-control" placeholder="Enter Ticket Cost" required step="0.01">
            </div>
            <button type="submit" class="btn btn-primary">Create Session</button>
        </form>
    </div>
</div>
<!-- Bootstrap JS Bundle (includes Popper) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
