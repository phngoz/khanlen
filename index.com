<!DOCTYPE html>
<html lang="vi">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<title>Tính giá khăn len</title>
<style>
:root{--bg:#FFF8EC;--card:#ffffff;--ink:#2E2A2A;--muted:#7a7068;--line:#eadfce;--accent:#E8553D;--hl:#FFE08A;--on-accent:#ffffff;
box-sizing:border-box;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px);color-scheme:light}
@media (prefers-color-scheme:dark){:root:not([data-theme="light"]){--bg:#1f1c1a;--card:#2a2623;--ink:#f3ece2;--muted:#b3a899;--line:#3d3732;--accent:#f0694f;--hl:#4a3f1a;color-scheme:dark}}
:root[data-theme="dark"]{--bg:#1f1c1a;--card:#2a2623;--ink:#f3ece2;--muted:#b3a899;--line:#3d3732;--accent:#f0694f;--hl:#4a3f1a;color-scheme:dark}
*{box-sizing:border-box}
html{scroll-padding-top:env(safe-area-inset-top,0px)}
body{margin:0;background:var(--bg);color:var(--ink);font-family:system-ui,-apple-system,"Segoe UI",Roboto,sans-serif;line-height:1.4}
main{max-width:480px;margin:0 auto;padding:20px 16px 32px}
h1{font-size:22px;margin:4px 0 4px}
p.sub{margin:0 0 16px;color:var(--muted);font-size:14px}
.card{background:var(--card);border:1px solid var(--line);border-radius:16px;padding:16px;margin-bottom:14px}
label{display:block;font-size:14px;font-weight:600;margin:12px 0 4px}
label:first-child{margin-top:0}
small{display:block;font-weight:400;color:var(--muted);font-size:12px}
input{width:100%;font-size:18px;padding:10px 12px;border:1.5px solid var(--line);border-radius:10px;background:var(--bg);color:var(--ink)}
input:focus{outline:none;border-color:var(--accent)}
.row{display:flex;justify-content:space-between;gap:12px;padding:8px 0;border-bottom:1px dashed var(--line);font-size:15px}
.row:last-of-type{border-bottom:none}
.row b{font-variant-numeric:tabular-nums}
.total{background:var(--hl);border-radius:14px;padding:16px;text-align:center;margin-top:10px}
.total span{display:block;font-size:13px;color:var(--muted)}
.total strong{display:block;font-size:34px;color:var(--accent);margin-top:2px;font-variant-numeric:tabular-nums}
.round{margin-top:6px;font-size:14px}
</style>
</head>
<body>
<main>
<h1>🧶 Tính giá khăn len</h1>
<p class="sub">Nhập số liệu, giá bán tự động hiện bên dưới.</p>

<div class="card">
<label for="gLen">Số lượng len<small>Tính theo đơn vị 100g (ví dụ 3 = 300g)</small></label>
<input id="gLen" type="number" inputmode="decimal" min="0" step="0.1" value="3">

<label for="giaLen">Giá 100g len (đ)</label>
<input id="giaLen" type="number" inputmode="decimal" min="0" step="1000" value="45000">

<label for="gio">Số giờ đan</label>
<input id="gio" type="number" inputmode="decimal" min="0" step="0.5" value="6">

<label for="cong">Công 1 giờ (đ)</label>
<input id="cong" type="number" inputmode="decimal" min="0" step="1000" value="40000">

<label for="dongGoi">Đóng gói (đ)<small>Túi, hộp, thiệp cảm ơn...</small></label>
<input id="dongGoi" type="number" inputmode="decimal" min="0" step="1000" value="10000">

<label for="loiNhuan">Lợi nhuận (%)<small>Cộng thêm trên tổng vốn</small></label>
<input id="loiNhuan" type="number" inputmode="decimal" min="0" step="1" value="25">
</div>

<div class="card">
<div class="row"><span>Tiền len</span><b id="rLen">0đ</b></div>
<div class="row"><span>Công đan</span><b id="rCong">0đ</b></div>
<div class="row"><span>Đóng gói</span><b id="rGoi">0đ</b></div>
<div class="row"><span>Tổng vốn</span><b id="rVon">0đ</b></div>
<div class="row"><span>Lợi nhuận</span><b id="rLoi">0đ</b></div>
<div class="total"><span>Giá bán</span><strong id="rGia">0đ</strong>
<div class="round">Làm tròn gợi ý: <b id="rTron">0đ</b></div></div>
</div>
</main>
<script>
(function(){
  var ids=['gLen','giaLen','gio','cong','dongGoi','loiNhuan'];
  function num(id){var v=parseFloat(document.getElementById(id).value);return isFinite(v)&&v>0?v:0;}
  function fmt(n){return Math.round(n).toLocaleString('vi-VN')+'đ';}
  function tinh(){
    var tienLen=num('gLen')*num('giaLen');
    var tienCong=num('gio')*num('cong');
    var goi=num('dongGoi');
    var von=tienLen+tienCong+goi;
    var loi=von*num('loiNhuan')/100;
    var gia=von+loi;
    document.getElementById('rLen').textContent=fmt(tienLen);
    document.getElementById('rCong').textContent=fmt(tienCong);
    document.getElementById('rGoi').textContent=fmt(goi);
    document.getElementById('rVon').textContent=fmt(von);
    document.getElementById('rLoi').textContent=fmt(loi);
    document.getElementById('rGia').textContent=fmt(gia);
    document.getElementById('rTron').textContent=fmt(Math.ceil(gia/1000)*1000);
  }
  ids.forEach(function(id){document.getElementById(id).addEventListener('input',tinh);});
  tinh();
})();
</script>
</body>
</html>
