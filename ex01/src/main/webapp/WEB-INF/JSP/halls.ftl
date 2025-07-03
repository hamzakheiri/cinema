<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Movie Halls Administration - Static Example</title>
    <!-- Bootstrap CSS CDN -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f8f9fa;
        }

        .container {
            margin-top: 30px;
        }

        .header {
            margin-bottom: 20px;
        }

        .table-responsive {
            margin-top: 20px;
        }

        .form-container {
            margin-top: 40px;
            background-color: #fff;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>
<body>
<div class="container">
    <h1 class="header text-center">Movie Halls Administration</h1>

    <!-- Static Halls List -->
    <div class="table-responsive">
        <table class="table table-bordered table-striped">
            <thead class="thead-dark">
            <tr>
                <th>Serial Number</th>
                <th>Number of Seats</th>
            </tr>
            </thead>
            <tbody>
            <#if halls?? && (halls?size > 0)>
                <#list halls as hall>
                    <tr>
                        <td>${hall.serialNumber}</td>
                        <td>${hall.seats}</td>
                    </tr>
                </#list>
            <#else>
                <tr>
                    <td colspan="2" class="text-center">No halls available.</td>
                </tr>
            </#if>
            </tbody>
        </table>
    </div>

    <!-- Form to Create a New Hall -->
    <div class="form-container">
        <h3>Create New Movie Hall</h3>
        <#assign ctx = request.contextPath>
        <form action="${ctx}/admin/panel/halls/" method="post">
            <div class="form-group">
                <label for="serialNumber">Serial Number</label>
                <input type="text" class="form-control" id="serialNumber" name="serialNumber"
                       placeholder="Enter Serial Number" required>
            </div>
            <div class="form-group">
                <label for="seats">Number of Seats</label>
                <input type="number" class="form-control" id="seats" name="seats" placeholder="Enter number of seats"
                       required min="1">
            </div>
            <button type="submit" class="btn btn-primary">Create Hall</button>
        </form>
    </div>
    <#if error??>
        <div class="alert alert-danger mt-3">${error}
        </div>
    </#if>
</div>
<!-- jQuery and Bootstrap JS Bundle (includes Popper) -->
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
