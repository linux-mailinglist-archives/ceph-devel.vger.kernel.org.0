Return-Path: <ceph-devel+bounces-1898-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED1899B7C1
	for <lists+ceph-devel@lfdr.de>; Sun, 13 Oct 2024 01:56:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 440A51C21385
	for <lists+ceph-devel@lfdr.de>; Sat, 12 Oct 2024 23:56:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E86AB19CD16;
	Sat, 12 Oct 2024 23:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="EhL+L7JE"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F04119CC09
	for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 23:55:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728777350; cv=none; b=Z95fODCFdFM8TqjNdVS3mBZUO+r8i58K5H+XKBH/tX0+uEvSH1hkAza15e4UXukE6hy5AmeAGfgTt+EMyusFXZW4I90juFXuVhSUlQYZtsg/Tdfvqr7zUhBgyJkjvwfBdq7ncFR6gdhbAU9vrFwGJlOexubsfK82QaG3Ek/sUkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728777350; c=relaxed/simple;
	bh=B4/JBdGM31QVKWtGy9/jYiS1rDqbLwKvIygE6O9yYRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pea0MglfIWNXQ8hwH8360fVv64MdXMfHmylVbN+4RAPi9GWH1So3E8fTskbHyR5vTHpAxSOjt5abR5RjkZVqyw+Cm3iIg/NX23u6Tf5GZSzca049a5ldkYGHzlaTQVmfA1REqOppV0S0O+RTk0r3agohEZzpdWYinxLLRxBj0/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=EhL+L7JE; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6cbf340fccaso13636006d6.1
        for <ceph-devel@vger.kernel.org>; Sat, 12 Oct 2024 16:55:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728777348; x=1729382148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ao33/Ao6F4cGAA89YWrjFOas+y1/CWWJL3mox+XBbjc=;
        b=EhL+L7JEQ+HBt1tDjoWXY1aObFGcUxWBK6pVZElAX9peoi+6I6qNJ4m+9wl7hb1On1
         UQZjwEEw5hjduWhTuXrGbuXnKHMAYTrY8GVE5sZQoFZdtQgsmAsLmEH6DD4g+fW4RDP/
         Nb8SRsS1PCb4REIKe8O9wwx96iDr9B+Vf3o+BKlNRHzeIBYL18sTIK6YDhgiPzMyptOV
         zn4l+v+D6hhMDHhC+kDSL9hvcUwadUCOI6cly+gd02JHiqZPf7+CLKjT0sHqa9txulsS
         96POCH/3rbIDIkcflHjUHrddddTsOg5HNMfb/z0nzVAVXNqZxf1Li8y7PMsWW7ER/Fmb
         pU+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728777348; x=1729382148;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ao33/Ao6F4cGAA89YWrjFOas+y1/CWWJL3mox+XBbjc=;
        b=Cv+PG1NQnwdC9QWU3BMk5cR1wpPi7EqPUt1e2RtVxymRRh7BTlCsWeC7gmPdp6ZZ9d
         4t9ARQVurE7dn1cx4MsNKpHjTkyuYrYn8C74yx7nzU8zYFW57hKiBQ1MOqyyWbWotK7M
         97XhGplGrHyRiN9heyEU5NmDchJWiEwwL9y2gpQF3wIPx6bTPSFWYJooz55LY14yvlxh
         QOZjs5QnDggZRq96kFYiKO60sAqFpnLX9VKg4d7C3avgJqFi5vXer4KtqT/W61SXJvpR
         ngq9aT/pnJzd9XY3TLXukS2wRdk/B1AWYbZnTcBzeLpliG9c57eCwVRUIJYGd/V61kTH
         XjXw==
X-Forwarded-Encrypted: i=1; AJvYcCVFhpunaB6onSQHUkoH7w/RUteQUC7Y0h6ITL4FotQP/FJM/f73URjn3TgwWZApOnMBNsE7uBYpHWLt@vger.kernel.org
X-Gm-Message-State: AOJu0YzOWiHwtOQ8bE/QKiU61xpuF/s1OysC67csMY27fG2X4caVGU5M
	U6FdGGbkpAMPxa3nNHzArIgfOmtjBv5pYKG6KqZC7oJTVw9r1CDT4fnAsSSeTg==
X-Google-Smtp-Source: AGHT+IFww6d66fpSJEHWX0d5peUSOnJLyx79wkR2Jg6vZqKhHo56VWU5vk3hFYXdUntOg5rHAC7VBA==
X-Received: by 2002:a05:6214:62f:b0:6cb:ee9c:7045 with SMTP id 6a1803df08f44-6cbee9c7dcfmr136861886d6.2.1728777348038;
        Sat, 12 Oct 2024 16:55:48 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85b7772sm30477966d6.49.2024.10.12.16.55.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2024 16:55:46 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <batrick@batbytes.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] ceph: correct ceph_mds_cap_peer field name
Date: Sat, 12 Oct 2024 19:55:26 -0400
Message-ID: <20241012235529.520289-2-batrick@batbytes.com>
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

See also ceph.git commit: "include/ceph_fs: correct ceph_mds_cap_peer field name".

See-also: https://tracker.ceph.com/issues/66704
Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/caps.c               | 23 ++++++++++++-----------
 include/linux/ceph/ceph_fs.h |  2 +-
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index bed34fc11c91..88a674cf27a8 100644
--- a/fs/ceph/caps.c
+++ b/fs/ceph/caps.c
@@ -4086,17 +4086,17 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	struct ceph_inode_info *ci = ceph_inode(inode);
 	u64 t_cap_id;
 	unsigned mseq = le32_to_cpu(ex->migrate_seq);
-	unsigned t_seq, t_mseq;
+	unsigned t_issue_seq, t_mseq;
 	int target, issued;
 	int mds = session->s_mds;
 
 	if (ph) {
 		t_cap_id = le64_to_cpu(ph->cap_id);
-		t_seq = le32_to_cpu(ph->seq);
+		t_issue_seq = le32_to_cpu(ph->issue_seq);
 		t_mseq = le32_to_cpu(ph->mseq);
 		target = le32_to_cpu(ph->mds);
 	} else {
-		t_cap_id = t_seq = t_mseq = 0;
+		t_cap_id = t_issue_seq = t_mseq = 0;
 		target = -1;
 	}
 
@@ -4134,12 +4134,12 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 	if (tcap) {
 		/* already have caps from the target */
 		if (tcap->cap_id == t_cap_id &&
-		    ceph_seq_cmp(tcap->seq, t_seq) < 0) {
+		    ceph_seq_cmp(tcap->seq, t_issue_seq) < 0) {
 			doutc(cl, " updating import cap %p mds%d\n", tcap,
 			      target);
 			tcap->cap_id = t_cap_id;
-			tcap->seq = t_seq - 1;
-			tcap->issue_seq = t_seq - 1;
+			tcap->seq = t_issue_seq - 1;
+			tcap->issue_seq = t_issue_seq - 1;
 			tcap->issued |= issued;
 			tcap->implemented |= issued;
 			if (cap == ci->i_auth_cap) {
@@ -4154,7 +4154,7 @@ static void handle_cap_export(struct inode *inode, struct ceph_mds_caps *ex,
 		int flag = (cap == ci->i_auth_cap) ? CEPH_CAP_FLAG_AUTH : 0;
 		tcap = new_cap;
 		ceph_add_cap(inode, tsession, t_cap_id, issued, 0,
-			     t_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
+			     t_issue_seq - 1, t_mseq, (u64)-1, flag, &new_cap);
 
 		if (!list_empty(&ci->i_cap_flush_list) &&
 		    ci->i_auth_cap == tcap) {
@@ -4268,14 +4268,14 @@ static void handle_cap_import(struct ceph_mds_client *mdsc,
 		doutc(cl, " remove export cap %p mds%d flags %d\n",
 		      ocap, peer, ph->flags);
 		if ((ph->flags & CEPH_CAP_FLAG_AUTH) &&
-		    (ocap->seq != le32_to_cpu(ph->seq) ||
+		    (ocap->seq != le32_to_cpu(ph->issue_seq) ||
 		     ocap->mseq != le32_to_cpu(ph->mseq))) {
 			pr_err_ratelimited_client(cl, "mismatched seq/mseq: "
 					"%p %llx.%llx mds%d seq %d mseq %d"
 					" importer mds%d has peer seq %d mseq %d\n",
 					inode, ceph_vinop(inode), peer,
 					ocap->seq, ocap->mseq, mds,
-					le32_to_cpu(ph->seq),
+					le32_to_cpu(ph->issue_seq),
 					le32_to_cpu(ph->mseq));
 		}
 		ceph_remove_cap(mdsc, ocap, (ph->flags & CEPH_CAP_FLAG_RELEASE));
@@ -4350,7 +4350,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	struct ceph_snap_realm *realm = NULL;
 	int op;
 	int msg_version = le16_to_cpu(msg->hdr.version);
-	u32 seq, mseq;
+	u32 seq, mseq, issue_seq;
 	struct ceph_vino vino;
 	void *snaptrace;
 	size_t snaptrace_len;
@@ -4375,6 +4375,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	vino.snap = CEPH_NOSNAP;
 	seq = le32_to_cpu(h->seq);
 	mseq = le32_to_cpu(h->migrate_seq);
+	issue_seq = le32_to_cpu(h->issue_seq);
 
 	snaptrace = h + 1;
 	snaptrace_len = le32_to_cpu(h->snap_trace_len);
@@ -4598,7 +4599,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 		cap->cap_id = le64_to_cpu(h->cap_id);
 		cap->mseq = mseq;
 		cap->seq = seq;
-		cap->issue_seq = seq;
+		cap->issue_seq = issue_seq;
 		spin_lock(&session->s_cap_lock);
 		__ceph_queue_cap_release(session, cap);
 		spin_unlock(&session->s_cap_lock);
diff --git a/include/linux/ceph/ceph_fs.h b/include/linux/ceph/ceph_fs.h
index 4ff3ad5e9210..2d7d86f0290d 100644
--- a/include/linux/ceph/ceph_fs.h
+++ b/include/linux/ceph/ceph_fs.h
@@ -808,7 +808,7 @@ struct ceph_mds_caps {
 
 struct ceph_mds_cap_peer {
 	__le64 cap_id;
-	__le32 seq;
+	__le32 issue_seq;
 	__le32 mseq;
 	__le32 mds;
 	__u8   flags;
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


