Return-Path: <ceph-devel+bounces-3566-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 765B4B51479
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 12:51:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3FD2188EA4D
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Sep 2025 10:51:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB76E2D062D;
	Wed, 10 Sep 2025 10:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MRR1zLef"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86D025A320
	for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 10:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757501459; cv=none; b=F9fMRLG1ns50TEw1JG4lLG+KMaeirrIG776tpyh4tUru0yEjidsfyKSvBBcHhbkkwBPrzVmUvRTr0Y7abh8klkia2+/0ZTSPd9q3r/1nyYcydoYbMi3c9FuN83X/T3FRdj4u3VW04bnzTgXVysAdMinMs0uefSZpfzsmAJwh4wI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757501459; c=relaxed/simple;
	bh=b655CRmzLZ1j+pFnhZgoLNZn55bheXgLDm1gwzIyUhg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=q4BavrANH99f6MfDpecrxSXyMZ1oG0BWzS8h8+jGpGaW5uyErDXHlqtNJO0qlsATS33948M2lTsRmP/xUUgOj2I6ppfr+0oXbZorymxw3l449J1HVt/lDat8u28pxOuCbkx9yHNKluPfbVuOKgZVIpoemA9lr54nhXN9u2fimpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MRR1zLef; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45dde353b47so19876665e9.3
        for <ceph-devel@vger.kernel.org>; Wed, 10 Sep 2025 03:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757501456; x=1758106256; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4OVc8Z9l9sLTjtmycfXALbuYPEScr3vKm/GzyXvSLnE=;
        b=MRR1zLefqEWw4i34hbr1plmZ+agyLD8YmGwSFC1OFKntlCXyJByd7YTYlFwOa8LzBY
         tel7EXb2isCjJ0e9ks6nZR1t3b9xqYR7BbDAlvL07VjZJBFjiroQhBC2aKzsFcnbfADS
         0RgmRXeM10oHYpi0DmMMl0yMkN50dssC7RBZVB5ulz/DNa5TiEMC0OtTU1yMHmkELdNH
         UMVz/sm8iwMGIHr5qQjUt2adRDj45DgcEGlaw7wNTUrYOEs3iKpFZo43Hd4NAFJ4jaJm
         wb5cgm00WKEFqibENocF0rt9NwnHcPE2+jozKGpa0QKUTbEACFp2AN45A43TqiL7XDp7
         dzzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757501456; x=1758106256;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4OVc8Z9l9sLTjtmycfXALbuYPEScr3vKm/GzyXvSLnE=;
        b=Pi2mo+W72juN9KNWtEvb6pu38qIEPmdnJpG258w+Enn7no0rJfdDOVPGzusA6QtBrJ
         KJImjDXYAmLJxepwmSGvh6tYe1bDhv3I6o571hM+VohuXT6x4WZce9vrbUBgK9o5nxnk
         uN94LNNrdMNxlL1+W/k5vGNEyRjIsvgsDrTHiEGEW8lVD8Y00kPdsA3JETJ+l8Bihx7t
         SYNZ9wLKIEG85tiJqBFr5F+mp9iWeGBimHuqthK9XQPhKOvUOFvJqdlfP4x3UA+3gENl
         L743zCmbX9Jn973qAnIfGMQZxoC0ui9/SkOrZfMTBDXPQ1XF3He7BTfgcxkyo4nBXpqy
         scqg==
X-Gm-Message-State: AOJu0YyqQn7o0EUbxIve6KNZjP338mYILZKItNQJQQ09obAfVpluQvgI
	VFSg6S5T7xzMnDEMS2FGIW9hRwwTkpBzHRqf4AK5cA4Y2WbkCKCfxbbn5/7tBA==
X-Gm-Gg: ASbGncv9DBmXcVd1l8VZF4itynOmI+1jERNOmdfbcESazG8TLln0tnieZPOZc/XmJA7
	PoT2l3jEEbtA2Wrl70ApehAVB0FwBEtepnguprsLXnv5Didt8CcMjhAdyRuJSuomf2ff0SKAKmD
	CFSfiAQLvty96GHrB1TWD5FPLNe+ZHNKqWdT/J3tUeKycbvVAydKPW5PooD/+j+mNeTlZB0xuSs
	Uv75LJQ/15gk85PhLxkEJt7WLB5SBl96aV2TnadOWaUrh+oj+1zuX0kQWNjbs4w3SBTJNCtkul5
	Y9iknBQz0hfhg15xjPbTESDVW6c8uIu8FmNWQP+WeyZrUm5JB8VO0+kSvi7wQmVqyqwoGidMo8A
	MYEobjsR/6ZETQbs1Lq35tpi4PKTvHDTteJ4371y72ZXipH9I3USyI5s/A/Pr3DZ99GxVQDJ1sL
	DQdt7c1Ujasmc=
X-Google-Smtp-Source: AGHT+IH86zJT1kJn3gVeVWeKioZRLb1uGykzmzp9FJ0F00Ys8lz/0siUSUzlz091LjwxhkEwt2nrBA==
X-Received: by 2002:a05:600c:5254:b0:45b:891f:afc3 with SMTP id 5b1f17b1804b1-45dddecdad9mr125167965e9.20.1757501455917;
        Wed, 10 Sep 2025 03:50:55 -0700 (PDT)
Received: from localhost.localdomain (ip-94-112-167-15.bb.vodafone.cz. [94.112.167.15])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45df16d099bsm25999325e9.8.2025.09.10.03.50.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 03:50:54 -0700 (PDT)
From: Ilya Dryomov <idryomov@gmail.com>
To: ceph-devel@vger.kernel.org
Cc: Xiubo Li <xiubli@redhat.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH] libceph: fix invalid accesses to ceph_connection_v1_info
Date: Wed, 10 Sep 2025 12:50:36 +0200
Message-ID: <20250910105041.4161529-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a place where generic code in messenger.c is reading and
another place where it is writing to con->v1 union member without
checking that the union member is active (i.e. msgr1 is in use).

On 64-bit systems, con->v1.auth_retry overlaps with con->v2.out_iter,
so such a read is almost guaranteed to return a bogus value instead of
0 when msgr2 is in use.  This ends up being fairly benign because the
side effect is just the invalidation of the authorizer and successive
fetching of new tickets.

con->v1.connect_seq overlaps with con->v2.conn_bufs and the fact that
it's being written to can cause more serious consequences, but luckily
it's not something that happens often.

Cc: stable@vger.kernel.org
Fixes: cd1a677cad99 ("libceph, ceph: implement msgr2.1 protocol (crc and secure modes)")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
---
 net/ceph/messenger.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index d1b5705dc0c6..9f6d860411cb 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -1524,7 +1524,7 @@ static void con_fault_finish(struct ceph_connection *con)
 	 * in case we faulted due to authentication, invalidate our
 	 * current tickets so that we can get new ones.
 	 */
-	if (con->v1.auth_retry) {
+	if (!ceph_msgr2(from_msgr(con->msgr)) && con->v1.auth_retry) {
 		dout("auth_retry %d, invalidating\n", con->v1.auth_retry);
 		if (con->ops->invalidate_authorizer)
 			con->ops->invalidate_authorizer(con);
@@ -1714,9 +1714,10 @@ static void clear_standby(struct ceph_connection *con)
 {
 	/* come back from STANDBY? */
 	if (con->state == CEPH_CON_S_STANDBY) {
-		dout("clear_standby %p and ++connect_seq\n", con);
+		dout("clear_standby %p\n", con);
 		con->state = CEPH_CON_S_PREOPEN;
-		con->v1.connect_seq++;
+		if (!ceph_msgr2(from_msgr(con->msgr)))
+			con->v1.connect_seq++;
 		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_WRITE_PENDING));
 		WARN_ON(ceph_con_flag_test(con, CEPH_CON_F_KEEPALIVE_PENDING));
 	}
-- 
2.49.0


