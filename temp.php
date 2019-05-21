<?php
class temp {
/**
     * insert blob into the files table
     * @param string $filePath
     * @param string $mime mimetype
     * @return bool
     */
    public function insertBlob($filePath, $mime) {
        $blob = fopen($filePath, 'rb');
 
        $sql = "INSERT INTO files(mime,data) VALUES(:mime,:data)";
        $stmt = $this->pdo->prepare($sql);
 
        $stmt->bindParam(':mime', $mime);
        $stmt->bindParam(':data', $blob, PDO::PARAM_LOB);
 
        return $stmt->execute();
    }
    
     /**
     * update the files table with the new blob from the file specified
     * by the filepath
     * @param int $id
     * @param string $filePath
     * @param string $mime
     * @return bool
     */
    function updateBlob($id, $filePath, $mime) {
 
        $blob = fopen($filePath, 'rb');
 
        $sql = "UPDATE files
                SET mime = :mime,
                    data = :data
                WHERE id = :id;";
 
        $stmt = $this->pdo->prepare($sql);
 
        $stmt->bindParam(':mime', $mime);
        $stmt->bindParam(':data', $blob, PDO::PARAM_LOB);
        $stmt->bindParam(':id', $id);
 
        return $stmt->execute();
    }
    
    /**
     * select data from the the files
     * @param int $id
     * @return array contains mime type and BLOB data
     */
    public function selectBlob($id) {
 
        $sql = "SELECT mime,
                        data
                   FROM files
                  WHERE id = :id;";
 
        $stmt = $this->pdo->prepare($sql);
        $stmt->execute(array(":id" => $id));
        $stmt->bindColumn(1, $mime);
        $stmt->bindColumn(2, $data, PDO::PARAM_LOB);
 
        $stmt->fetch(PDO::FETCH_BOUND);
 
        return array("mime" => $mime,
            "data" => $data);
    }
}  


//Storing a blob
$mysqli=mysqli_connect('localhost','user','password','db');
if (!$mysqli) die("Can't connect to MySQL: ".mysqli_connect_error());
$stmt = $mysqli->prepare("INSERT INTO images (image) VALUES(?)");
$null = NULL;
$stmt->bind_param("b", $null);
$stmt->send_long_data(0, file_get_contents("osaka.jpg"));
$stmt->execute();


//Retrieving
$mysqli=mysqli_connect('localhost','user','password','db');
if (!$mysqli)die("Can't connect to MySQL: ".mysqli_connect_error());
$id=1;  
$stmt = $mysqli->prepare("SELECT image FROM images WHERE id=?"); 
$stmt->bind_param("i", $id);
$stmt->execute();
$stmt->store_result();
$stmt->bind_result($image);
$stmt->fetch();
header("Content-Type: image/jpeg");
echo $image; 



