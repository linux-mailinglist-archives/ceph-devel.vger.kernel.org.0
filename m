Return-Path: <ceph-devel+bounces-2190-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C3BA9D6805
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Nov 2024 08:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C4A6281DF2
	for <lists+ceph-devel@lfdr.de>; Sat, 23 Nov 2024 07:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5401417A5A4;
	Sat, 23 Nov 2024 07:21:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Uk05GTB8"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6505E16DEA9
	for <ceph-devel@vger.kernel.org>; Sat, 23 Nov 2024 07:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732346488; cv=none; b=DpXgzvQPCai5sDArWH/V1nGxfyePDAMmWUyw74eqal1kgrocIgN2yo28tHMcnLjTyYw32OWzXw7KFMUH0znL0cF7/TX4zPWVtLDwemjtqVtp6wke+ZAEzZuFuj8opu3Ia8B3ifb8apvRuKzf5NZgynRwKYjk4eDeaY6NK4KH0GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732346488; c=relaxed/simple;
	bh=+Uh18BnwWLPB7ox5dDwpLR/2M4WjGNtc7pg5MyVHUEY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=oYjrBf/zAqmoqo0Opdy0noBkCALJSeuxufsSKd4Y5e6kEBpzAVKZhqNuWU3+1Tb2PCS7wLDYKhnE8GVci5B2zB7rbmQwxEZsaagi/UDz3Ck0DbDnSQBQsT+MxUHLb2XSB6OKGxbR2JEbzqjfZvpLqDc78j38KnhPbk4SPgi8Rvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Uk05GTB8; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5cef772621eso3620681a12.3
        for <ceph-devel@vger.kernel.org>; Fri, 22 Nov 2024 23:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732346484; x=1732951284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/YTNmEWfSDtA7h9QFVeEH/ye6CcFDrvL5f8PLeF/T+E=;
        b=Uk05GTB8nUAMRYjwQvNPtk8cpgWtM72DeYgoQl6V+I+VxYK9UJja+pzd3XeKoB0TcJ
         E3KfMXbp0gsMqUZwvs/r54HryN5+awdj5BlQvcNZ4DNtepozyP26+iutPXhuu+kT3lXi
         Y5oqNJPgaVmwjI8icDHZH19aNMlz1G4iB+XPX+NbNtV3OM50Y1LETOYzLNjIkm3QkDSs
         q2yiZliz2N7e3ZEsR5P+j9rDeMAwX1RBS3xEvLvb5ZKP2gxpNE6ESSGaxXurXl1XLPJ1
         y45QHho7KNouBRpvt+59WEv/QW7vVzOPYt4W0Bm6Fo4kYMTGAaZsYHuyUpQsmCD8bYsH
         uJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732346484; x=1732951284;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/YTNmEWfSDtA7h9QFVeEH/ye6CcFDrvL5f8PLeF/T+E=;
        b=E8nyHEdXQTNnDkfrGUpA2HiRy9GRFKBcSqcaxk5ClW45OQcrFWC3yPGZ5qrPzXzsOg
         lX9rHdXsfqfzDh7/66Cb83W4ytEPzQoISJDEVRdFRnoo/2+a67f27+zVT9VntANv6VcW
         2Q3pBBJth8gdXwDrzIZhr99hfnUXoAqgkmuT6Os+yrsYNXOGidIuF+aRb6BjNgcit/pL
         R/jYUH87+BvNmqkYzBuT2MZely4lxOESzvG2OsBJ9WWkFq4E4QFBVBXxPiwFYeMpyF7B
         doksDQKkWvdsIUS0jtAYkYgMEO+aI8H2zY4Cx5EtwtpkNRSVa/LpzC2Ao3fU9n2AGp1G
         OCKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUDYi8LSzcIoDRFv6szwoHSUyZMMetBxQ4rtn+T+src3pQ9de2aPJfpiTzA/Wd+wvXDZg9P+kil8K0F@vger.kernel.org
X-Gm-Message-State: AOJu0YyfnxMhm9csokYmMHs8DYvOuPWxYzEysCD7faX3LdWSfsjVYqRa
	YCuOOlza9S5gD2FNd9fVtnEK4ftoknRu94KCxC8HcisttD29pIHsY8pP8HJxooo=
X-Gm-Gg: ASbGncvp2pAbsMXJgllLT7hZAmyQJKxkqvAB/tUs8/I2/7HR3YlnCzIC80AGnKQTmO9
	d33S3Ppdik+BFERy8V8lZ9zJpQPScXBjmUZ5tAiemD7BpSX0RfFNA/3cqlFiPFS35ojSmD+qk+z
	l5vRX76QhTTteWNlWlx2X6WvQh8G10fmhTzjYs4bRhdUqadryXJeeVNm6QXd5MTed6EiDxljdcd
	fUK4xyPzA+RQ8sPSJybDvS1dPnEVaRPRkUVoRk+CDobJ/3VH7ymYz+QJHkYqO6NWPC8yI6ypmzn
	KcKeuGjAtnIIR9EeCJZO8h3pFuY1p/KZofCyMwfd9iUoQBAXjw==
X-Google-Smtp-Source: AGHT+IHXLdLmo1tmtjgCD0qXUsxAXVAd8FLm9qOjaiXqI+c53wWX0tVyWhZvrhtWm4ABhSfP9OWgKg==
X-Received: by 2002:a05:6402:5212:b0:5cf:bb9e:cca7 with SMTP id 4fb4d7f45d1cf-5d0207b2521mr4251606a12.28.1732346483822;
        Fri, 22 Nov 2024 23:21:23 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f12b600023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f12:b600:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d01ffd96e4sm1590029a12.60.2024.11.22.23.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 23:21:23 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: xiubli@redhat.com,
	idryomov@gmail.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org,
	Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 1/2] fs/ceph/mds_client: pass cred pointer to ceph_mds_auth_match()
Date: Sat, 23 Nov 2024 08:21:20 +0100
Message-ID: <20241123072121.1897163-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This eliminates a redundant get_current_cred() call, because
ceph_mds_check_access() has already obtained this pointer.

As a side effect, this also fixes a reference leak in
ceph_mds_auth_match(): by omitting the get_current_cred() call, no
additional cred reference is taken.

Fixes: 596afb0b8933 ("ceph: add ceph_mds_check_access() helper")
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/mds_client.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 6baec1387f7d..e8a5994de8b6 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -5615,9 +5615,9 @@ void send_flush_mdlog(struct ceph_mds_session *s)
 
 static int ceph_mds_auth_match(struct ceph_mds_client *mdsc,
 			       struct ceph_mds_cap_auth *auth,
+			       const struct cred *cred,
 			       char *tpath)
 {
-	const struct cred *cred = get_current_cred();
 	u32 caller_uid = from_kuid(&init_user_ns, cred->fsuid);
 	u32 caller_gid = from_kgid(&init_user_ns, cred->fsgid);
 	struct ceph_client *cl = mdsc->fsc->client;
@@ -5740,7 +5740,7 @@ int ceph_mds_check_access(struct ceph_mds_client *mdsc, char *tpath, int mask)
 	for (i = 0; i < mdsc->s_cap_auths_num; i++) {
 		struct ceph_mds_cap_auth *s = &mdsc->s_cap_auths[i];
 
-		err = ceph_mds_auth_match(mdsc, s, tpath);
+		err = ceph_mds_auth_match(mdsc, s, cred, tpath);
 		if (err < 0) {
 			return err;
 		} else if (err > 0) {
-- 
2.45.2


