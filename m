Return-Path: <ceph-devel+bounces-1508-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AD5192B873
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2024 13:39:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 157B41F2184B
	for <lists+ceph-devel@lfdr.de>; Tue,  9 Jul 2024 11:39:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9A5ED157A6C;
	Tue,  9 Jul 2024 11:39:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ixObtDEA"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0931149C79
	for <ceph-devel@vger.kernel.org>; Tue,  9 Jul 2024 11:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720525147; cv=none; b=mSz3iMGghQg+0pX8n1srwcG6tyqwTOsPaN7gz9PsXTUH7H2uvF66GNItaIQ9nK1MZUW9YuIDcuDTQjnJYOjqX37SZ8iHF3ebYCeIUK6iDKhICgQwQByEPAgvd6ZGSbKx6TDw2ffPBjxW9/nDaaLZi8nm3+DQQSmBMvnqer8+KpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720525147; c=relaxed/simple;
	bh=ENJSSZ1eAgVeaWtWrVeKUX1XFtIaWW6JC43PV4Wscok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GnesudJ4S4zrfvZoUDnGoUVjZ0FxKo0Le4lA0Dkb3J+YytuvI2Iw8zvha8E5ZoORN/g4PZ6hAy2Ret9J00I/3xnV5RSgQuNXVBdhpAHhskymUyIxKe5FVfXzETOcYNmeDL3F5DSa1h+gt89EdM+F0ZjPrxCR5xWLfkAP7O12u7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ixObtDEA; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4266ed6c691so8587125e9.3
        for <ceph-devel@vger.kernel.org>; Tue, 09 Jul 2024 04:39:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720525144; x=1721129944; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=07CwLjHeyvixvwmAVL3VgM5mpy8NCPZJG69pkFSBWJg=;
        b=ixObtDEA5Ow03dy0tMdEOzbQPwGui0NHH9+HiWgr1nB0HRVv+ylHkvby/X4tp8NWAL
         /OsqcuCIH0JsW2u0mEkN/lsz5a3HSe1UH7uT9+WHnBnEIQZxj5NM/YHz08KEzEI3X7i7
         0VyAArrUHsXX8C6COaTzLJ5jn7hEVrHuHR0PyFOILrdqwdal7xmWAYwpFRRtDz8g2KEv
         acrqOdomoyTblRM5oAeNyxjZ5ynoEevTJMSnVMj5Ipx+GqTS8O+kNjR/n6hd+xZGLUco
         EPSNgBb/psNtyRNQj6ccvxnrHiY6udcgE6WmKzcghIRVwsZbPRJmn7mwTsK4VAuAh7b1
         ZE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720525144; x=1721129944;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=07CwLjHeyvixvwmAVL3VgM5mpy8NCPZJG69pkFSBWJg=;
        b=GAT0BaivKcSx8UH4nxbrePq5F5zE+hRTTnFCojjYlLaB+U6lUPPCZvL5vvZKJbZf79
         ZqPgM4RqSB3xVJIWrS0Bq7IHoTlhR4yJwRFYaAZvdyfbX5AmGXAzde+ZhuzECHPHJl9u
         HrTJXLzHeXSv0QA2s2Rmylb+tXIkLJFQn1cJM7WyZ7a2G5gTmZUhvTH3Kk+ZySoKTjZU
         M0SUAlN+G2fjOp7y9qlDVr0Q5ruhXBLndqu9FBZLF2eDPPpLqq6KfZW5CJ7x664VtZSX
         p9MvtqRgcsPVeeHg9mw5Cjl16dgLrgKfAAhjJOqfjCk8aKminjUilGNKfJLKJBanaiTz
         VCbg==
X-Gm-Message-State: AOJu0YzuHQu9HB+L+xm8q3KbXB+hsHQgio3hKnvhFxacPZ9eWIao4v7y
	O9JK2nwBya+UMAO1wK4opEtevA7liCBapJgk24paeSI4oQ8EkFL+eYjgrg==
X-Google-Smtp-Source: AGHT+IFJ9JZySp1S+ZFj3wuXXj7v2XNeo33RqUbLBuRRQOUovZAzt+Io0CwkVf8btmY4aI3xXt/ECw==
X-Received: by 2002:a05:600c:4998:b0:426:5b21:9801 with SMTP id 5b1f17b1804b1-426708f2197mr15537465e9.27.1720525143781;
        Tue, 09 Jul 2024 04:39:03 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4266a38f5a5sm75124905e9.43.2024.07.09.04.39.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 04:39:02 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] libceph: fix race between delayed_work() and ceph_monc_stop()
Date: Tue,  9 Jul 2024 13:38:46 +0200
Message-ID: <20240709113848.336103-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The way the delayed work is handled in ceph_monc_stop() is prone to
races with mon_fault() and possibly also finish_hunting().  Both of
these can requeue the delayed work which wouldn't be canceled by any of
the following code in case that happens after cancel_delayed_work_sync()
runs -- __close_session() doesn't mess with the delayed work in order
to avoid interfering with the hunting interval logic.  This part was
missed in commit b5d91704f53e ("libceph: behave in mon_fault() if
cur_mon < 0") and use-after-free can still ensue on monc and objects
that hang off of it, with monc->auth and monc->monmap being
particularly susceptible to quickly being reused.

To fix this:

- clear monc->cur_mon and monc->hunting as part of closing the session
  in ceph_monc_stop()
- bail from delayed_work() if monc->cur_mon is cleared, similar to how
  it's done in mon_fault() and finish_hunting() (based on monc->hunting)
- call cancel_delayed_work_sync() after the session is closed

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/66857
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/mon_client.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index f263f7e91a21..ab66b599ac47 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -1085,13 +1085,19 @@ static void delayed_work(struct work_struct *work)
 	struct ceph_mon_client *monc =
 		container_of(work, struct ceph_mon_client, delayed_work.work);
 
-	dout("monc delayed_work\n");
 	mutex_lock(&monc->mutex);
+	dout("%s mon%d\n", __func__, monc->cur_mon);
+	if (monc->cur_mon < 0) {
+		goto out;
+	}
+
 	if (monc->hunting) {
 		dout("%s continuing hunt\n", __func__);
 		reopen_session(monc);
 	} else {
 		int is_auth = ceph_auth_is_authenticated(monc->auth);
+
+		dout("%s is_authed %d\n", __func__, is_auth);
 		if (ceph_con_keepalive_expired(&monc->con,
 					       CEPH_MONC_PING_TIMEOUT)) {
 			dout("monc keepalive timeout\n");
@@ -1116,6 +1122,8 @@ static void delayed_work(struct work_struct *work)
 		}
 	}
 	__schedule_delayed(monc);
+
+out:
 	mutex_unlock(&monc->mutex);
 }
 
@@ -1232,13 +1240,15 @@ EXPORT_SYMBOL(ceph_monc_init);
 void ceph_monc_stop(struct ceph_mon_client *monc)
 {
 	dout("stop\n");
-	cancel_delayed_work_sync(&monc->delayed_work);
 
 	mutex_lock(&monc->mutex);
 	__close_session(monc);
+	monc->hunting = false;
 	monc->cur_mon = -1;
 	mutex_unlock(&monc->mutex);
 
+	cancel_delayed_work_sync(&monc->delayed_work);
+
 	/*
 	 * flush msgr queue before we destroy ourselves to ensure that:
 	 *  - any work that references our embedded con is finished.
-- 
2.45.1


