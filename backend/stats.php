<?php
// =============================================
//   IST LMS - Dashboard Stats API
//   GET /backend/stats.php           → admin stats
//   GET /backend/stats.php?student=X → student stats
// =============================================

require 'db.php';

if ($_SERVER['REQUEST_METHOD'] !== 'GET') {
    http_response_code(405);
    echo json_encode(["error" => "Method not allowed"]);
    exit;
}

// ── STUDENT STATS ─────────────────────────────
if (isset($_GET['student'])) {
    $sid = $_GET['student'];

    $borrowed = $pdo->prepare("SELECT COUNT(*) FROM borrowings WHERE student_id=? AND status='issued'");
    $borrowed->execute([$sid]);

    $returned = $pdo->prepare("SELECT COUNT(*) FROM borrowings WHERE student_id=? AND status='returned'");
    $returned->execute([$sid]);

    $overdue = $pdo->prepare("SELECT COUNT(*) FROM borrowings WHERE student_id=? AND status='issued' AND due_date < CURDATE()");
    $overdue->execute([$sid]);

    $sinfo = $pdo->prepare("SELECT full_name, department FROM students WHERE student_id=?");
    $sinfo->execute([$sid]);
    $info = $sinfo->fetch();

    echo json_encode([
        "borrowed"   => (int)$borrowed->fetchColumn(),
        "returned"   => (int)$returned->fetchColumn(),
        "overdue"    => (int)$overdue->fetchColumn(),
        "name"       => $info['full_name'] ?? 'Student',
        "department" => $info['department'] ?? 'CS'
    ]);
}

// ── ADMIN STATS ───────────────────────────────
else {
    $totalBooks    = $pdo->query("SELECT COUNT(*) FROM books")->fetchColumn();
    $totalIssued   = $pdo->query("SELECT COUNT(*) FROM borrowings WHERE status='issued'")->fetchColumn();
    $totalReturned = $pdo->query("SELECT COUNT(*) FROM borrowings WHERE status='returned'")->fetchColumn();
    $totalUsers    = $pdo->query("SELECT COUNT(*) FROM students")->fetchColumn();

    echo json_encode([
        "total_books"    => (int)$totalBooks,
        "books_assigned" => (int)$totalIssued,
        "books_returned" => (int)$totalReturned,
        "total_users"    => (int)$totalUsers
    ]);
}
?>
