Return-Path: <ceph-devel+bounces-3480-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB755B389FC
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 21:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D950462609
	for <lists+ceph-devel@lfdr.de>; Wed, 27 Aug 2025 19:02:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74582239E75;
	Wed, 27 Aug 2025 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b="Z+AtUD9l"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383B97464
	for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 19:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756321315; cv=none; b=m1nLwlt0zJPpeA4ZGsf9JrAlnB4K7QYzNmT89z3nX6iVdOuui8CWlSjIFaK9BOC0UDHEhU54fyKn2CMPRqVTOYM22cLwMCvqx+S6I7TgB3tA7pDglcGkrt/z2NVcK1zxoiwGwC0e9QGic3UFQCDOpOSz/xcC1Fw3bNAw1+KQOTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756321315; c=relaxed/simple;
	bh=jTXCrqurI35lVDo9byI/H5H5ftA0NEhdYNk09tAKuDk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Blqq5Mx5Ue0QRbiDqwd+mvbgk3nQsQYQYerBl+fAEJaHUcQ6nG6+PakTB7jviFwvfehNussf/5PKbgQinkYy/Z8/taJEVZ11AWY22MqOv68yMqH1bTjcjN70+BJzFcYRH7Jj4d/Z3tXgo4dzkIuGTqGGjWARJ9WBb/S6TyYE8ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com; spf=pass smtp.mailfrom=dubeyko.com; dkim=pass (2048-bit key) header.d=dubeyko-com.20230601.gappssmtp.com header.i=@dubeyko-com.20230601.gappssmtp.com header.b=Z+AtUD9l; arc=none smtp.client-ip=209.85.128.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dubeyko.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dubeyko.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d603b60cbso1286667b3.1
        for <ceph-devel@vger.kernel.org>; Wed, 27 Aug 2025 12:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1756321312; x=1756926112; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W6gehJLOxzkyNftXjEdQOXi6ukSj/HJus3mrt7hMc1g=;
        b=Z+AtUD9lIHHTQgHBSFoAtNxq7of4yQuLEDSLqWfxxPSpRuuUaifXZztx5kGJcex/AC
         fl+/9f4sJDiC7xKOnAdE56IHFQhajRnvBl/PU7jJ2IscFiM/awFGzi3x5SSXqjCdy86U
         Hs7M1m+CbK+pmJlPWC6Um6DrZcoJwYeZ17M/Lm0cBKr6tgh7JrEusXzlrXbSHFtu2x6G
         0bEeaCwNAB91lZ0Mue7y8Qe0P1KeR0K9Gn3KexbPdOOuj/Ncl7jVM9+eOXohneAA9OEo
         ccAo60kt9AZf/Yn2yZAgNnuShcSj+9Is2F1ikrE1mM7uEE+bzkYl01gCadPVYglL4Xrr
         OARg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756321312; x=1756926112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W6gehJLOxzkyNftXjEdQOXi6ukSj/HJus3mrt7hMc1g=;
        b=dxHQB3VoNIFDRo7QUmfU1+TSJMAh/E144rRXnIV25bG7Rr1WzcP1d3ub0ZXBbi7O1W
         pHvG8S3T16MLHFn7uSFQ2U22Xx6CYe/tyazjWKFZ3jBZ0bAd8fsaloBsP4qI9qpOYEFr
         cHuKUuZNoxfxeKmAPFgJR5CRhp/0jkv42c709goqYuoF+5CL3f1rlWfOMYDUn/fM5GIR
         knlUi2lrHjlH8vfyqSxPijkaEdnNBp+dULDxbTP9sEatF+Ysh5W71W9oH+XMlfvthjh/
         agMrwnexWH5lV6+Wx+6Zs2DoleSSOH0Bz/UNqkDzQUwLDAFgq4nDqZu4Ou/4Ie/d7JWY
         BmFA==
X-Gm-Message-State: AOJu0YwE4q9GDV5sOrCJvtKWkBb+3uwlvH2UTnbDFBP90DpNVbZ67pzq
	gzsJUxJCKTeyGaTqP5djkHchme/108y8vdS5xN28VE6nezxG3GN7RWqEmN8P/fLSDnQ3WxVT9Q1
	bZYz8/JOmvQ==
X-Gm-Gg: ASbGncu+hRpJyeqb8xJ5Bezy5YOwW6Efg31/uQ7c3e03NLl5nlw6Un7a37bZkx1A3lQ
	x2O6Q4hJ/PDaj26P4fhM+Bg8a+3gq2sXm6tCDuK/ALseviG2eRDnbneFkOXUvdQctoOkhmi5HEo
	pWIvP2zuBdHfT/orMtWPbr6wFDqfcWuOkQO/upnPG6E/I9QRx20eza2vIvJzOYosN82Si5eFaBq
	+A021v57C9CGBGQB3iIz6kay8Kh8lquCwG3cY5mqwA5UJS+k+cgrDvSJRl2h3qsqe6Q0XSlr5D9
	rLi10EC2svHLw6eKXYYXBOhHmbVxlRyMIkfy1yxhCNF4X6oJ+18v5dBW7iqrqQiRwzEUQkw+4ss
	Xfhh5MIagDoeUOtPyaVgQWN0Fxa61P73OaveC1I++
X-Google-Smtp-Source: AGHT+IHwoKF0+aFawZrS0k1KCAl1JFeBaHRBi5bmOFhJNIPcL8cXpeT52Jm5OpxDriusRFF4u/5jJA==
X-Received: by 2002:a05:690c:6106:b0:720:4ec:3f89 with SMTP id 00721157ae682-72004ec4967mr133070077b3.46.1756321311471;
        Wed, 27 Aug 2025 12:01:51 -0700 (PDT)
Received: from system76-pc.attlocal.net ([2600:1700:6476:1430:4e16:8eb2:d704:13fb])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-71ff18aea32sm32951437b3.53.2025.08.27.12.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Aug 2025 12:01:50 -0700 (PDT)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: ceph-devel@vger.kernel.org
Cc: idryomov@gmail.com,
	linux-fsdevel@vger.kernel.org,
	pdonnell@redhat.com,
	amarkuze@redhat.com,
	Slava.Dubeyko@ibm.com,
	slava@dubeyko.com
Subject: [PATCH] ceph: fix potential NULL dereferenced issue in ceph_fill_trace()
Date: Wed, 27 Aug 2025 12:01:23 -0700
Message-ID: <20250827190122.74614-2-slava@dubeyko.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>

The Coverity Scan service has detected a potential dereference of
an explicit NULL value in ceph_fill_trace() [1].

The variable in is declared in the beggining of
ceph_fill_trace() [2]:

struct inode *in = NULL;

However, the initialization of the variable is happening under
condition [3]:

if (rinfo->head->is_target) {
    <skipped>
    in = req->r_target_inode;
    <skipped>
}

Potentially, if rinfo->head->is_target == FALSE, then
in variable continues to be NULL and later the dereference of
NULL value could happen in ceph_fill_trace() logic [4,5]:

else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
            req->r_op == CEPH_MDS_OP_MKSNAP) &&
            test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
             !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
<skipped>
     ihold(in);
     err = splice_dentry(&req->r_dentry, in);
     if (err < 0)
         goto done;
}

This patch adds the checking of in variable for NULL value
and it returns -EINVAL error code if it has NULL value.

[1] https://scan5.scan.coverity.com/#/project-view/64304/10063?selectedIssue=1141197
[2] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1522
[3] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1629
[4] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1745
[5] https://elixir.bootlin.com/linux/v6.17-rc3/source/fs/ceph/inode.c#L1777

Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
cc: Alex Markuze <amarkuze@redhat.com>
cc: Ilya Dryomov <idryomov@gmail.com>
cc: Ceph Development <ceph-devel@vger.kernel.org>
---
 fs/ceph/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index fc543075b827..dee2793d822f 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1739,6 +1739,11 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 			goto done;
 		}
 
+		if (!in) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		/* attach proper inode */
 		if (d_really_is_negative(dn)) {
 			ceph_dir_clear_ordered(dir);
@@ -1774,6 +1779,12 @@ int ceph_fill_trace(struct super_block *sb, struct ceph_mds_request *req)
 		doutc(cl, " linking snapped dir %p to dn %p\n", in,
 		      req->r_dentry);
 		ceph_dir_clear_ordered(dir);
+
+		if (!in) {
+			err = -EINVAL;
+			goto done;
+		}
+
 		ihold(in);
 		err = splice_dentry(&req->r_dentry, in);
 		if (err < 0)
-- 
2.51.0


