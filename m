Return-Path: <ceph-devel+bounces-3720-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 354A6B99461
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 11:58:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 87B1F3BE31F
	for <lists+ceph-devel@lfdr.de>; Wed, 24 Sep 2025 09:58:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 641682D9EDA;
	Wed, 24 Sep 2025 09:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ECp69F6G"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AF12D978D
	for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 09:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758707930; cv=none; b=icIcqrJf0r1qRSjH0gg9ZAO0HZDbzuvAP8aYlgb/2wjleXAGudCIWUHlgFtnyd47WtfhceX1Q39BELgU5pGvANY40tIjZBbbdy4U0K47iCnqOJoV2YuSJBWzv+RYlryjNZm77TCxI69zjuZku38GvwMjXgbn9jNZiehmK5OyXdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758707930; c=relaxed/simple;
	bh=h99sr49XVfS2Twq70fufWUoxB6aDr2wGAgz4bdhNOLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXri/HUWJspNOeFKK0zTvUeXHXS6Px4/+B13j75QR22IwYOuClxrhFQM/Ve1mE+Ww/2B7szZ24SGroK8Lwz1XMyw96Tz3el1EvuwZLWO9Yepbb4vVG8Mn7/YXNonl4Y1r9PzW+6Bwb7w4DULXr3wgLDcOUi8+1W1UZcYpzcuoSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ECp69F6G; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b54c86f3fdfso640798a12.1
        for <ceph-devel@vger.kernel.org>; Wed, 24 Sep 2025 02:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758707924; x=1759312724; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gHWSNr/3BXglEAdiihvLP/Iu0SoH+E5kfdfK2iRF2TA=;
        b=ECp69F6Glh+n2P5nK78OzpnLsseyQuvuJyMEJJ+62uVJ7UWwMxc+fGw5hoeIoMWTGV
         rMUv4ko40iJ9cn3aRrRSV2BV9e1gF+sgzof5S/1q2HvPzQ/+InlWWICUZLh1tJvWiwNU
         ObiRqR4fC6jD76RyqzzU/GL70+cKsQBo3zFTJWI3v3DyBiNUvTSn64qxKL++geQEu1kz
         s/pXYTtoOEzAiRnuFfYmVYwR7yJf/P8NFbELJEgcWYmux0TeZhuyLJA6syv0OEqFEG+A
         iXBwPMHFMfYvBh6ibfwfhev/Sw9CXDQoNI3bgcUoAj2z0ssOERJdHVkdCRtkw/W6MW89
         vtSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758707924; x=1759312724;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gHWSNr/3BXglEAdiihvLP/Iu0SoH+E5kfdfK2iRF2TA=;
        b=l0z2bNwbgnIYMT5FdhYgXNw7eVgppdYNtFocs56Nx1AxfTk5/Qoy18Y1AsSRe5cDty
         /+L6ghlQ9JlqctbyrHeVZqyb0UeVb9ZbA16kr3407tC+eoIXPICrMr8A0Keu8Ee2pjsW
         k/0V5ETmjfrzHsv4v788+XhAuyE3ChmDdlc/7msKf1AZjrlfiJfpv0BvHGtf8gy97Kkt
         hJK5J10RzWj955Q2byuF/OQcJwo9Rv0vXE8bNzrMu/I1ZBhexnxUK4MUaoxEXjbeTK+y
         pIQLeUlxHCVS9ju+5WTFQprUiK7oDukUS7vjroaebCmt0bC1wotSqrarKIyf3smmwJ1S
         1ldw==
X-Gm-Message-State: AOJu0YwDO0Sgs0MlLcCpi5/AmyRcjzyRMjwAy8cXlmpdRvpfxjkrWZgN
	v5X6hNwC57XOSeRc5J7tt/9TS1I9HdavAeCmtdHUw2aWqPbday3Pu37KQovaSWMsog4=
X-Gm-Gg: ASbGncsWps2GnF9xiJPMYYEzYFJclxYVbFm4FsE55o9CN9BbsOzdcXvzTrV7Bf8Gcwl
	Hfp2g7sTUEwfiBPFdn4bKmskR5QLH8qdZvpU+lq7tdasvj0Jm5c+RLNcKwVbBzXyLb8cq2ivo+z
	s0KdDP5DW7Ryt2QCws4yOpq3MqZSjri37EBkuWNWWO5IR8gzXgmtpBVLVPcYOyq9D7IGcWcDWmC
	BKWs46p3VrgIbUPHtDYOLcZ/WMszjsL0mujPdyP4lDbvZsIEiViiUdY3VWBVpVSYXo4BvwxwRx2
	fAsCAc1vxmfzJvx/hyEuDt7/49L0Ma+TsRgrZqiGRfBBDZjzhZpQR2uhzClZnwbcX7m3SzO9Tvk
	L67CKdOVIEZtoeLp2H3CohOo3dgmlVCOcJPFKa/ue3Ms0vFu6Csgk6RY33h1p2vg+ftK/
X-Google-Smtp-Source: AGHT+IFKc1Ina6XGZ/ESPvveY9MQ8L/0h5E4e48kY+y+xS+s81hKqkWfJTe63yIEaeKY1UcpXQ1DEA==
X-Received: by 2002:a17:903:3d07:b0:26e:43dd:ae77 with SMTP id d9443c01a7336-27ec1396fa5mr22046825ad.24.1758707923722;
        Wed, 24 Sep 2025 02:58:43 -0700 (PDT)
Received: from ethanwu-VM-ubuntu.. (203-74-127-94.hinet-ip.hinet.net. [203.74.127.94])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269803601a5sm187502035ad.141.2025.09.24.02.58.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 02:58:43 -0700 (PDT)
From: ethanwu <ethan198912@gmail.com>
X-Google-Original-From: ethanwu <ethanwu@synology.com>
To: ceph-devel@vger.kernel.org
Cc: xiubli@redhat.com,
	idryomov@gmail.com,
	ethanwu@synology.com
Subject: [PATCH] ceph: fix snapshot context missing in ceph_uninline_data
Date: Wed, 24 Sep 2025 17:58:06 +0800
Message-ID: <20250924095807.27471-3-ethanwu@synology.com>
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

The ceph_uninline_data function was missing proper snapshot context
handling for its OSD write operations. Both CEPH_OSD_OP_CREATE and
CEPH_OSD_OP_WRITE requests were passing NULL instead of the appropriate
snapshot context, which could lead to data inconsistencies in snapshots.

This fix properly acquiring the snapshot context from either pending
cap snaps or the inode's head snapc before performing write operations.

Signed-off-by: ethanwu <ethanwu@synology.com>
---
 fs/ceph/addr.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..a8aeca9654b6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -2202,6 +2202,7 @@ int ceph_uninline_data(struct file *file)
 	struct ceph_osd_request *req = NULL;
 	struct ceph_cap_flush *prealloc_cf = NULL;
 	struct folio *folio = NULL;
+	struct ceph_snap_context *snapc = NULL;
 	u64 inline_version = CEPH_INLINE_NONE;
 	struct page *pages[1];
 	int err = 0;
@@ -2229,6 +2230,19 @@ int ceph_uninline_data(struct file *file)
 	if (inline_version == 1) /* initial version, no data */
 		goto out_uninline;
 
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
 	folio = read_mapping_folio(inode->i_mapping, 0, file);
 	if (IS_ERR(folio)) {
 		err = PTR_ERR(folio);
@@ -2244,7 +2258,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 0, 1,
 				    CEPH_OSD_OP_CREATE, CEPH_OSD_FLAG_WRITE,
-				    NULL, 0, 0, false);
+				    snapc, 0, 0, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
 		goto out_unlock;
@@ -2260,7 +2274,7 @@ int ceph_uninline_data(struct file *file)
 	req = ceph_osdc_new_request(&fsc->client->osdc, &ci->i_layout,
 				    ceph_vino(inode), 0, &len, 1, 3,
 				    CEPH_OSD_OP_WRITE, CEPH_OSD_FLAG_WRITE,
-				    NULL, ci->i_truncate_seq,
+				    snapc, ci->i_truncate_seq,
 				    ci->i_truncate_size, false);
 	if (IS_ERR(req)) {
 		err = PTR_ERR(req);
@@ -2323,6 +2337,7 @@ int ceph_uninline_data(struct file *file)
 		folio_put(folio);
 	}
 out:
+	ceph_put_snap_context(snapc);
 	ceph_free_cap_flush(prealloc_cf);
 	doutc(cl, "%llx.%llx inline_version %llu = %d\n",
 	      ceph_vinop(inode), inline_version, err);
-- 
2.43.0


