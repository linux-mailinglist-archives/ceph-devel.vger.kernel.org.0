Return-Path: <ceph-devel+bounces-1899-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2CD4999B7C3
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 01:56:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B7E821F223FB
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 23:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12C7A19E804;
	Sat, 12 Oct 2024 23:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="cYiQKSB7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CE1B19DF45
	for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728777353; cv=none; b=bzn7BfZFzgXp19QEyXU1QnY9S6FRJJettqVqr5Np//QO0sfDVgswhbwG98N9NxnRU/D3PCw0uezeGEMMw3PJ7M9IWU+JKduapx+ywUni69ap8DX+pFoZvdhWVddvnHI1h9WQQ0qdRisFdmMuINNOHKgxYF6BF1+Y2gn5QrmEJTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728777353; c=relaxed/simple;
	bh=4OEr5DlA2GJoYYQduLmLnz2yUHPnnHV7+HNBrHK40y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uWXuZ1Nw4dtPmX5nlqk8tCuMiH54WSfLaPZPv4VxTkgaTzP9ahPpYBz1Kll0Qo6uUCjGB5jvxGfkaew9iEoALKjf7ueRpvFJ1xz6hYPoiKfSLHZ2SBQufnBtwy9O0qNNk07zbRQ50RZ/t64t09XmyBzi8H2WLva1Io/wLqo9XQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=cYiQKSB7; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6cbe90c7c95so28244046d6.1
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:55:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728777351; x=1729382151; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JUIHvjCHyF6SlVUAxO2Vzn0YEoHF5gMFXLys0iHDmcY=;
        b=cYiQKSB7/lbjZRvjxIQ/HlCxlzVImfgnvVIJGe3KcovQJjOWpn/ZO4Kg1qsksiwjTo
         gX4DCaWCdWhStZMYDtc1hXG/MTOjQ613B77of8S5iMcv+RRwwWWrkH9nppkZmvdf1uTG
         4/E/Y3t2FX8A9YvnoBYa9htwZg+2rNo5I1YUS23CiFPxI7Bl9gLlPMER9lURMi1jWU5N
         xmTuMfVnLA45ePeVFEIrxIeYO9gSxFa4IYUS7zCDfh7fAHJY/hBnzOvY8BWCS6A19NwJ
         wg2TuUHR+qB/c4YwxBXmpVcypBAXt4oYNrhF/t+CTJ7uD6asSkvQ51sTHBHSDFm8SRst
         74qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728777351; x=1729382151;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JUIHvjCHyF6SlVUAxO2Vzn0YEoHF5gMFXLys0iHDmcY=;
        b=mzFt/Ni0tzJdjmG5ULosHl6R9pKVnelr6S450Ty7SAtJvn7a3H090lmYehbnlw+jvf
         iPLTw7us+x/4uNyaaSsFozRe4UXVY/mHmYAIPK+wFlYRYejzxSqi0F1LSJgx8qNwP+Hv
         +bySQqaTyf6t0xoFIeT5/NLYU7f8YmwY0zkCvCN+99Kw4HmC5KObuEwK+5GMx2t931JI
         LKrzdhLG8VWmWmcU9VXzXxe6qpVOZMjfCJNA9uOqp37afpgzGfUWtmaYWFdjw11vKCVC
         9PAWPoUpXMZxPdCDgzWk1WmvUExkg5AVPSrw7fVRy8ZE7s/aZU41Bh8fOejNLpsY4ygY
         No1A==
X-Forwarded-Encrypted: i=1; AJvYcCUMJgcja8Pa5hqat3j/oRft1RItsDlEMBS2FLUrEdXXd7Aig3TPrRPv8Lxp5+cospdO18O/VewPs8AO@vger.kernel.org
X-Gm-Message-State: AOJu0YxfHytaIRO26DndkJKRQZHR+S/kw4ixqhWnsZLwYlb17TDOepg6
	04YnqsmHSsIb2UJqgZokfuKUOi8jIMaths2NLbaE0StVB5h7BvAwvPVNAhtEZg==
X-Google-Smtp-Source: AGHT+IF7xbC6RydQ84ZvpD5OcH9md/BJ2GwQbW0K+Szes013pS6ywQ9fNubuSzit+OWKUzTm+/qj4g==
X-Received: by 2002:a05:6214:3c9a:b0:6cb:cedb:a37a with SMTP id 6a1803df08f44-6cbf9cb3165mr83449786d6.7.1728777351227;
        Sat, 12 Oct 2024 16:55:51 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85b7772sm30477966d6.49.2024.10.12.16.55.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:55:50 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] ceph: improve caps debugging output
Date: Sat, 12 Oct 2024 19:55:27 -0400
Message-ID: <20241012235529.520289-3-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241012235529.520289-1-batrick@batbytes.com>
References: <20241012235529.520289-1-batrick@batbytes.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

This improves uniformity and exposes important sequence numbers.

Now looks like:

    <7>[   73.749563] ceph:           caps.c:4465 : [c9653bca-110b-4f70-9f84-5a195b205e9a 15290]  caps mds2 op export ino 20000000000.fffffffffffffffe inode 0000000008d2e5ea seq 0 iseq 0 mseq 0
    ...
    <7>[   73.749574] ceph:           caps.c:4102 : [c9653bca-110b-4f70-9f84-5a195b205e9a 15290]  cap 20000000000.fffffffffffffffe export to peer 1 piseq 1 pmseq 1
    ...
    <7>[   73.749645] ceph:           caps.c:4465 : [c9653bca-110b-4f70-9f84-5a195b205e9a 15290]  caps mds1 op import ino 20000000000.fffffffffffffffe inode 0000000008d2e5ea seq 1 iseq 1 mseq 1
    ...
    <7>[   73.749681] ceph:           caps.c:4244 : [c9653bca-110b-4f70-9f84-5a195b205e9a 15290]  cap 20000000000.fffffffffffffffe import from peer 2 piseq 686 pmseq 0
    ...
    <7>[  248.645596] ceph:           caps.c:4465 : [c9653bca-110b-4f70-9f84-5a195b205e9a 15290]  caps mds1 op revoke ino 20000000000.fffffffffffffffe inode 0000000008d2e5ea seq 2538 iseq 1 mseq 1

See also: "mds: add issue_seq to all cap messages" in ceph.git

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/caps.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 88a674cf27a8..74ba310dfcc7 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4085,8 +4085,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	struct ceph_cap *cap, *tcap, *new_cap = NULL;
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 t_cap_id;
-	unsigned mseq = le32_to_cpu(ex->migrate_seq);
-	unsigned t_issue_seq, t_mseq;
+	u32 t_issue_seq, t_mseq;
 	int target, issued;
 	int mds = session->s_mds;
 
@@ -4100,8 +4099,8 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		target = -1;
 	}
 
-	doutc(cl, "%p %llx.%llx ci %p mds%d mseq %d target %d\n",
-	      inode, ceph_vinop(inode), ci, mds, mseq, target);
+	doutc(cl, " cap %llx.%llx export to peer %d piseq %u pmseq %u\n",
+	      ceph_vinop(inode), target, t_issue_seq, t_mseq);
 retry:
 	down_read(&mdsc->snap_rwsem);
 	spin_lock(&ci->i_ceph_lock);
@@ -4228,18 +4227,22 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 	u64 realmino = le64_to_cpu(im->realm);
 	u64 cap_id = le64_to_cpu(im->cap_id);
 	u64 p_cap_id;
+	u32 piseq = 0;
+	u32 pmseq = 0;
 	int peer;
 
 	if (ph) {
 		p_cap_id = le64_to_cpu(ph->cap_id);
 		peer = le32_to_cpu(ph->mds);
+		piseq = le32_to_cpu(ph->issue_seq);
+		pmseq = le32_to_cpu(ph->mseq);
 	} else {
 		p_cap_id = 0;
 		peer = -1;
 	}
 
-	doutc(cl, "%p %llx.%llx ci %p mds%d mseq %d peer %d\n",
-	      inode, ceph_vinop(inode), ci, mds, mseq, peer);
+	doutc(cl, " cap %llx.%llx import from peer %d piseq %u pmseq %u\n",
+	      ceph_vinop(inode), peer, piseq, pmseq);
 retry:
 	cap = __get_cap_for_mds(ci, mds);
 	if (!cap) {
@@ -4268,15 +4271,13 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 		doutc(cl, " remove export cap %p mds%d flags %d\n",
 		      ocap, peer, ph->flags);
 		if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
-		    (ocap->seq != le32_to_cpu(ph->issue_seq) ||
-		     ocap->mseq != le32_to_cpu(ph->mseq))) {
+		    (ocap->seq != piseq ||
+		     ocap->mseq != pmseq)) {
 			pr_err_ratelimited_client(cl, "mismatched seq/mseq: "
 					"%p %llx.%llx mds%d seq %d mseq %d"
 					" importer mds%d has peer seq %d mseq %d\n",
 					inode, ceph_vinop(inode), peer,
-					ocap->seq, ocap->mseq, mds,
-					le32_to_cpu(ph->issue_seq),
-					le32_to_cpu(ph->mseq));
+					ocap->seq, ocap->mseq, mds, piseq, pmseq);
 		}
 		ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
 	}
@@ -4360,8 +4361,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	bool close_sessions = false;
 	bool do_cap_release = false;
 
-	doutc(cl, "from mds%d\n", session->s_mds);
-
 	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
 		return;
 
@@ -4463,12 +4462,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
 	/* lookup ino */
 	inode = ceph_find_inode(mdsc->fsc->sb, vino);
-	doutc(cl, " op %s ino %llx.%llx inode %p\n", ceph_cap_op_name(op),
-	      vino.ino, vino.snap, inode);
+	doutc(cl, " caps mds%d op %s ino %llx.%llx inode %p seq %u iseq %u mseq %u\n",
+          session->s_mds, ceph_cap_op_name(op), vino.ino, vino.snap, inode,
+          seq, issue_seq, mseq);
 
 	mutex_lock(&session->s_mutex);
-	doutc(cl, " mds%d seq %lld cap seq %u\n", session->s_mds,
-	      session->s_seq, (unsigned)seq);
 
 	if (!inode) {
 		doutc(cl, " i don't have ino %llx\n", vino.ino);
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


