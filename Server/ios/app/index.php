<?php

function displayPage() 
{
	header('Location: http://www.lechateau.ro/ios/oferte');
}

function displayUpdate()
{
	echo 'A aparut o noua versiune a aplicatiei. O poti downloada de 
	<a href="https://itunes.apple.com/us/app/chateau-maison-de-beaute/id918863340?ls=1&mt=8">aici</a>. 
	';
}

function webResponse($response, $status = 0) 
{
    $webResponse = array(
        'Status'=> $status == 0 ? 'NOK' : 'OK',
        'Response'=>$response
    );
    echo json_encode($webResponse);
}

// *********************************

$secret = array(
	'1.0'=>"iS0LGjZdKO1E6ZY1JOrw",
	'2.0'=>"JSSeUgB6y9T7sgCRwJUs"
	);
$ver = array_search($_GET['client'], $secret);

if(!isset($ver) || empty($ver)) {
	exit;
}

if(empty($_POST)) {

	//afisare pagina pentru browser
	$update = false;
	if($ver) {
		foreach($secret as $key=>$value) {
			if($key > $ver) {
				$update = true;
				break;
			}
		}
		$update ? displayUpdate() : displayPage();
	}
} else {

	if(isset($_POST['request']) && $_POST['request'] == 'services') {
		$services = file_get_contents('services.json');
		$response = json_decode($services);
		webResponse($response,1);
		exit;
	}

	$from = $_POST['email'];
	$to = 'programari@lechateau.ro';
	$subject = 'Programare ' . $_POST['data'];
	$signature = "</br></br>Sent by Chateau iOS App";

	$headers = 'MIME-Version: 1.0' . "\r\n";
	$headers .= 'Content-type: text/html; charset=UTF-8' . "\r\n";
	$headers .= 'From: <' . $from . '>' . "\r\n";
	$headers .= 'Cc: <' . $from . '>' . "\r\n";
	$headers .= 'Bcc: <bcoticopol@gmail.com>' . "\r\n";
	$headers .= 'Return-Path:<' . $from . '>' . "\r\n";

	$message = '
		<html>
		<head>
			<title>Programare Chateau</title>
		</head>
		<body>
			<p>Programare noua:</p>
			<table style="font-family:Verdana">
				<tr>
					<td>Nume: </td>
					<td>' . $_POST['nume'] . '</td>
				</tr>
				<tr>
					<td>Telefon: </td>
					<td>' . $_POST['telefon'] . '</td>
				</tr>
				<tr>
					<td>Data programarii: </td>
					<td>' . $_POST['data'] . '</td>
				</tr>
				<tr>
					<td>Servicii: </td>
					<td>' . $_POST['servicii'] . '</td>
				</tr>
				<tr>
					<td>Email: </td>
					<td>' . $_POST['email'] . '</td>
				</tr>
			</table>
			' . $signature . '
		</body>
		</html>
	';

	$result = mail($to, $subject, $message, $headers);
	if($result) {
		webResponse('Programarea a fost trimisa. Va vom contacta in cel mai scurt timp',1);
	} else {
		webResponse('Eroare trimitere programare.',0);
	}
}

?>