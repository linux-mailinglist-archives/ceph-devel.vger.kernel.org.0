Return-Path: <ceph-devel+bounces-4253-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E7AECF5AFF
	for <lists+ceph-devel@lfdr.de>; Mon, 05 Jan 2026 22:36:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 145B03027E39
	for <lists+ceph-devel@lfdr.de>; Mon,  5 Jan 2026 21:35:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 472242BEFF6;
	Mon,  5 Jan 2026 21:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dDrUu/7d"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A1F26F289
	for <ceph-devel@vger.kernel.org>; Mon,  5 Jan 2026 21:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767648928; cv=none; b=EiX6ONcSoivxK0xwA+bNJnvRhhpMDn70tgsanwHCujXptUf1PwCErd/Dm8oXc7SVkt+/O54Gpn0RUMhajtYDqTvkHdQcTQQu00aUd8LIiCzMuK+l+U31Jvg4FJywswHW4jMcRV4AlRjLW+5lO76JyFi4KtHnCnWG9T15bqKz0uE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767648928; c=relaxed/simple;
	bh=X/xzMcRs07oTTbw/sp4X/hH51PTkyJuZQgWNhreAP8s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tzTIHJI1bet9KHbeMXXfa4qvkqpoRMVnGJ1mKXS/7SLqSWll9NKuGWQpZK53OnnpjlzJZEFhN4Bta8DdkLHKCkRQHMdpR4K2+dXer/m2UxPLKQXezL+TqoT6uTLPJr2ldmfGSQrwMRfp9DIo/vv0+hjLnsT7hiKgfNGV/9683JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dDrUu/7d; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8b2d32b9777so44104985a.2
        for <ceph-devel@vger.kernel.org>; Mon, 05 Jan 2026 13:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767648925; x=1768253725; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=AFZ0GFsW5GugAefKE3Q0lyMj26m6J2eoj+hTmCbvigg=;
        b=dDrUu/7dm7/uoZmEBwnKQpS0RJc4mIjgFEuTJhtTC4RkxThXEu6hxoE+oOrmDMnMGW
         y2boMsaXVjyZhegy4cGHPP1Nhj6ANWreQ4wiZ3ATNHxihl3pTthNrbOG5M2/FmnYYBmA
         wgaQ6/0SvMOUAZp+Ptc7nTlUIShqUWWCexQD9hY2p3nkZ+tjaS4ra6vKfRiXxbjROHEa
         rxS2I4ThEvWeLM8p7OgrhrXISLIDy1Wy2dLO/SQdKL7czKlNv7sfUxD2TKCXyF4378/j
         3Jtoz3igCNFBFPxf8OWc3G58UJHeEyEtdT4nlUCiCQCy5dEhGkeA8eR8DTfj6HvXJI3v
         5Jfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767648925; x=1768253725;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AFZ0GFsW5GugAefKE3Q0lyMj26m6J2eoj+hTmCbvigg=;
        b=dbLK3tR0Mwsb8gXzURThG+vmCqSmd11MDKdLuK/HJt+zx66zzwl2eAfDjEnwUDmPNA
         xEvb+USxwEfrdu79KxATIU8KSBtP+TQirVaNXSBmwauM31Q28WkP6XRsB1l3lJVfOKAU
         N57JaLUS+uC20hAQtqjOX2VKqVp+AK9SVgpkbPxSEymLcrupIucsaBArHX4wS9ni4HaJ
         fclTCtnUYgqiucnKYMLRL7rvAJu8J50Fz+G+R0UoeUj+wuppkXTpq1DwbZ3TMHRI7wFV
         3jI/tkqnhJ6ggobI/EhLvOUOGYweMbGkI4/phz1WA+TiU8KjUSl6c9uhNV5GPLb4JYvQ
         ovZA==
X-Gm-Message-State: AOJu0YwY+uU4dH6JP7NcH2CIOzafx8i5Mpko9JDvtYL+105RrCWy9vBk
	wgXvRAs4Kt1qA37+/TEQQltHsPrZB5g3dd4MdrdounpDGwjJRK0fq99Mz4AQVQ==
X-Gm-Gg: AY/fxX5Qp78ezZ06U30EOc53hehz0hPViHX4weluEHFIlw5ujKYCsnQfNLCeAhvGxbk
	ay5SXfGy4ewgy1AAdafQROSrdwSmsGrVY/F1hR06+AXf9II7h/JEF2/vh9YKS9xMgOClkeadksA
	GN3dD7M8yC+tFC1OX/YzrBZEOWZuLQd2OMgQjSk9kDqa8Te0hkbZWMDjCtYh06GkiydZ2UsdbJ5
	VowiZOl0WH1zB78gGi25GMUdCA2TcHhXdEqBC2sM2MPf6Qv7q3h/JaSqYgKMfj/mny1rG0ZfQEW
	ezeD/n29EGvxIYLTYddPdKcTL9Agqt+Z1xB9WgstC/A1CTggyTzAoLPqHun0V3lLunJOuJSQ7xn
	LhjrwjNLdCqV3dJT8UpdmwS6IALSoJtIc5/23iskGaKww1O6059jGyVzULQVJTDC83lA1BVoc28
	2ZtqlC7zguRqbjISefutD4QF7wIdBK05pZ20ERhVluJnNG6jM1/dKa/w==
X-Google-Smtp-Source: AGHT+IHzTYZYtRarButBeYT6Tp72T6AAOXh4hIybDzWxD1o34SeRCI+IMXbHejSg2f37xG25/HUcwA==
X-Received: by 2002:a05:620a:f0b:b0:8b2:ef2d:f74b with SMTP id af79cd13be357-8c37eb71eb8mr129975685a.29.1767648925320;
        Mon, 05 Jan 2026 13:35:25 -0800 (PST)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c37f4a7962sm35380785a.11.2026.01.05.13.35.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jan 2026 13:35:24 -0800 (PST)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Subject: [PATCH] libceph: make calc_target() set t->paused, not just clear it
Date: Mon,  5 Jan 2026 22:34:29 +0100
Message-ID: <20260105213509.24587-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently calc_target() clears t->paused if the request shouldn't be
paused anymore, but doesn't ever set t->paused even though it's able to
determine when the request should be paused.  Setting t->paused is left
to __submit_request() which is fine for regular requests but doesn't
work for linger requests -- since __submit_request() doesn't operate
on linger requests, there is nowhere for lreq->t.paused to be set.
One consequence of this is that watches don't get reestablished on
paused -> unpaused transitions in cases where requests have been paused
long enough for the (paused) unwatch request to time out and for the
subsequent (re)watch request to enter the paused state.  On top of the
watch not getting reestablished, rbd_reregister_watch() gets stuck with
rbd_dev->watch_mutex held:

  rbd_register_watch
    __rbd_register_watch
      ceph_osdc_watch
        linger_reg_commit_wait

It's waiting for lreq->reg_commit_wait to be completed, but for that to
happen the respective request needs to end up on need_resend_linger list
and be kicked when requests are unpaused.  There is no chance for that
if the request in question is never marked paused in the first place.

The fact that rbd_dev->watch_mutex remains taken out forever then
prevents the image from getting unmapped -- "rbd unmap" would inevitably
hang in D state on an attempt to grab the mutex.

Cc: stable@vger.kernel.org
Reported-by: Raphael Zimmer <raphael.zimmer@tu-ilmenau.de>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/osd_client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 1a7be2f615dc..610e584524d1 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -1586,6 +1586,7 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 	struct ceph_pg_pool_info *pi;
 	struct ceph_pg pgid, last_pgid;
 	struct ceph_osds up, acting;
+	bool should_be_paused;
 	bool is_read = t->flags & CEPH_OSD_FLAG_READ;
 	bool is_write = t->flags & CEPH_OSD_FLAG_WRITE;
 	bool force_resend = false;
@@ -1654,10 +1655,16 @@ static enum calc_target_result calc_target(struct ceph_osd_client *osdc,
 				 &last_pgid))
 		force_resend = true;
 
-	if (t->paused && !target_should_be_paused(osdc, t, pi)) {
-		t->paused = false;
+	should_be_paused = target_should_be_paused(osdc, t, pi);
+	if (t->paused && !should_be_paused) {
 		unpaused = true;
 	}
+	if (t->paused != should_be_paused) {
+		dout("%s t %p paused %d -> %d\n", __func__, t, t->paused,
+		     should_be_paused);
+		t->paused = should_be_paused;
+	}
+
 	legacy_change = ceph_pg_compare(&t->pgid, &pgid) ||
 			ceph_osds_changed(&t->acting, &acting,
 					  t->used_replica || any_change);
-- 
2.49.0


