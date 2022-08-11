<html>

<head>
    <meta charset="UTF-8" />
    <title>Visits Statistics</title>
</head>

<body>
    <div align="center">
        <h1>Vists Statistics</h1>

        <table>

            <?php
            require_once('config.php');

            try {
                $connection = new PDO("mysql:host={$host};dbname={$database};charset=utf8", $user, $password);
                $query = $connection->query("INSERT INTO visits (dummy) VALUES (1)");
                $query = $connection->query("SELECT COUNT(*) cnt, MAX(ts) mts FROM visits");
                $rows = $query->fetchAll();

                if (empty($rows)) {
                    echo "<tr><td>No data.</td></tr>\n";
                } else {
                    foreach ($rows as $row) {
                        print "<tr><td>{$row['cnt']}</td><td align=\"right\">{$row['mts']}</td></tr>\n";
                    }
                }
            } catch (PDOException $e) {
                print "<tr><td><div align='center'>\n";
                print "No connetion to database. Try again later <a href=\"#\" onclick=\"document.getElementById('error').style = 'display: block;';\">Details</a><br/>\n";
                print "<span id='error' style='display: none;'><small><i>" . $e->getMessage() . " <a href=\"#\" onclick=\"document.getElementById('error').style = 'display: none;';\">Hide</a></i></small></span>\n";
                print "</div></td></tr>\n";
            }
            ?>
        </table>
    </div>
</body>

</html>