Return-Path: <ceph-devel+bounces-3719-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D6FB5B9945A
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 11:58:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3813E16F067
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 09:58:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D548F2D738B;
	Wed, 24 Sep 2025 09:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHwYKe9U"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C9192D94AC
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 09:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707924; cv=none; b=nkJmSCtzMF7LoPWdUvJxLEutodnfUdto6X6U2BAoZWEH0RhwR6/9VpjueRteqEMyUSGwnGF4i8Lx0PYTjRMwnwtCketB3T6bxD7+jHXjQ5OBYHmzil77Cqce9lFyJhXX1Qf/O0N3qXcmh73dsEyngsaJKE/rVgpNkwHmbl86sN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707924; c=relaxed/simple;
	bh=9akiXI8dyqT/zCp1HSjhEav1rEGFRJojaO06WevmjjY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cYrrjz2M8EBmC5uovNsg/Vmd1DinTvDNn3V4S2zC5TCkrDsQEP30/4kPqoBPdV1HovwDCikMKWd+VOYk61NfjW0GadizjmwhexzxrWtWFYFx2P6Vjy9o6wCZIqe2QnI9EuEShaRyHtAxsMee5tof4CLKG4uXUWzg7K0CWxLHNlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nHwYKe9U; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b5515eaefceso5154409a12.2
        for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 02:58:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758707917; x=1759312717; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9z8dYJIA4WbpOairw6ohtfi0RRmP+Tul9thRN5SBjio=;
        b=nHwYKe9UBdyJibtU345XK7thsjXjY/zBbkLi/QbO8h+TF1cdPllQoQm1ul7NFYAFQ7
         AGzhtik2TeZHnww+PHfnAzblZqRrcc3R5FxFBpcTh63ZAtdoU+BJGOEBQT8XOy08RNOx
         rtFkNeuZfiUfvs+GzogYDRbzrMwawPBxDNZWFLpjG8ZJE6DtPuiMP4zzpEci/frIS5X4
         1JRhAhD/Orv1L+IB42JkcLov6ao+s50h4JHf3HINus9Gdsr4mIYGdzq50iC49wpz6/wp
         HBF7uVbmzwZHlz9/MxZ70IKpf+y5/ZacC/JJBmCqKEG/d2B4ztcOnL4aLLiSesZoagUj
         xXvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707917; x=1759312717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9z8dYJIA4WbpOairw6ohtfi0RRmP+Tul9thRN5SBjio=;
        b=l2dtk/WWywYhBDZxi8e2KQP68AIeyDKTZ36bnrqD1lptwbOUDf8LNE497RQ+S1WYV2
         1PNPhpvMNo8PDToXwnacHdxSk1u5ExGLC87tvKbf8viRXLu9a2/+pv62+UGYkb3PZOJI
         MrZ3H4PbO0puQrE1KesSp6nNbsd8oPfnC/dZM7YDVo+ZJBWXfDzu/6ap6HntocO+enlB
         X9DPOGSmpyYLDkGQ0Th7Hk2vHz9PmtE7ToBWnRTtIbo8s161MWgHThgULLx4dFG8Kz5Q
         uIwqq1zIZjEIWapfhqffE+4u+f2GxyHOccPMh/r5KHx2epm6bNrmt9tUiH/siavh/vCd
         FCkQ==
X-Gm-Message-State: AOJu0YxOgdjX04ZUuR5GEUJUKMVeY7945ODsFcFYQFqBhkgpq5Pd/51q
	7kBgUp5i2jpkN1YjjkQYWjLWZ0XqbtKWc77+xwUJX6zD3/zPDQPnMEgDm+KIAgHh+7s=
X-Gm-Gg: ASbGncvk/qd5tBv/F/7RBzATsz/T1c5sOfpDWesNPRcldiiw/f0/TiOjsVFxgXwJp5r
	wFCUxtGcuQwx4vaICn4hHskZSt09aPBogMlL6DgjEgEVtKlJpYXgl5D+iLl56E0QTozc4q+wpLL
	gLtj9HJINdbzgpL5sAzvHZHbTI96ZbmqdpCTQ5ZJCONfTOVxXUC3HXGy84D0WjtqZYZXQD5zKzz
	jf3Gd8uDEMWOaPXtdveygv25ispl9LK9XHMDxNijDJS/Eg5vdKtHpAHXzyLT2M/QpPxEs/yEnbf
	hhmZ80PZa/ujMaANGUAYl8ejVE5W254x977KkftQPLR7g074ufkI526muN+yWHuZIShYZGxSlN+
	qE5ItHw4gfAPI10TQx03IN5WTrrFv5BzK17FStNDtvrDFeCFxn+f1VK1mTIGzfoqyPFEc
X-Google-Smtp-Source: AGHT+IGQYvlzE/2pcHvM0LjcOklOyufHnopyz9aMOvCRsXMOw1ecd7gI5ZzmUJgsTtxhp9JL20NDXA==
X-Received: by 2002:a17:903:3c25:b0:26b:3aab:f6b8 with SMTP id d9443c01a7336-27cc98a13f3mr75495115ad.58.1758707917500;
        Wed, 24 Sep 2025 02:58:37 -0700 (PDT)
Received: from ethanwu-VM-ubuntu.. (203-74-127-94.hinet-ip.hinet.net. [203.74.127.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803601a5sm187502035ad.141.2025.09.24.02.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 02:58:37 -0700 (PDT)
From: ethanwu <ethan198912@gmail.com>
X-Google-Original-From: ethanwu <ethanwu@synology.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com,
	ethanwu@synology.com
Subject: [PATCH] ceph: fix snapshot context missing in ceph_zero_partial_object
Date: Wed, 24 Sep 2025 17:58:05 +0800
Message-ID: <20250924095807.27471-2-ethanwu@synology.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250924095807.27471-1-ethanwu@synology.com>
References: <20250924095807.27471-1-ethanwu@synology.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ceph_zero_partial_object function was missing proper snapshot
context for its OSD write operations, which could lead to data
inconsistencies in snapshots.

Reproducer:
dd if=/dev/urandom of=/mnt/mycephfs/foo bs=64K count=1
mkdir /mnt/mycephfs/.snap/snap1
md5sum /mnt/mycephfs/.snap/snap1/foo
fallocate -p -o 0 -l 4096 /mnt/mycephfs/foo
echo 3 > /proc/sys/vm/drop/caches
md5sum /mnt/mycephfs/.snap/snap1/foo # get different md5sum!!

will get the same

Fixes: ad7a60de882ac ("ceph: punch hole support")
Signed-off-by: ethanwu <ethanwu@synology.com>
---
 fs/ceph/file.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index c02f100f8552..58cc2cbae8bc 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2572,6 +2572,7 @@ static int ceph_zero_partial_object(struct inode *inode,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_osd_request *req;
+	struct ceph_snap_context *snapc;
 	int ret = 0;
 	loff_t zero = 0;
 	int op;
@@ -2586,12 +2587,25 @@ static int ceph_zero_partial_object(struct inode *inode,
 		op = CEPH_OSD_OP_ZERO;
 	}
 
+	spin_lock(&ci->i_ceph_lock);
+	if (__ceph_have_pending_cap_snap(ci)) {
+		struct ceph_cap_snap *capsnap =
+				list_last_entry(&ci->i_cap_snaps,
+						struct ceph_cap_snap,
+						ci_item);
+		snapc = ceph_get_snap_context(capsnap->context);
+	} else {
+		BUG_ON(!ci->i_head_snapc);
+		snapc = ceph_get_snap_context(ci->i_head_snapc);
+	}
+	spin_unlock(&ci->i_ceph_lock);
+
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 					ceph_vino(inode),
 					offset, length,
 					0, 1, op,
 					CEPH_OSD_FLAG_WRITE,
-					NULL, 0, 0, false);
+					snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		ret = PTR_ERR(req);
 		goto out;
@@ -2605,6 +2619,7 @@ static int ceph_zero_partial_object(struct inode *inode,
 	ceph_osdc_put_request(req);
 
 out:
+	ceph_put_snap_context(snapc);
 	return ret;
 }
 
-- 
2.43.0


