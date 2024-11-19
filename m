Return-Path: <ceph-devel+bounces-2178-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 024D69D1E44
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 03:29:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6FBD283CD1
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Nov 2024 02:29:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63CCC149C7B;
	Tue, 19 Nov 2024 02:28:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="NzHdh1fd"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C12146A71
	for <ceph-devel@vger.kernel.org>; Tue, 19 Nov 2024 02:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731983295; cv=none; b=alfU8qHWsxgCDbPUSiPItbquZd/FXpivtlAbbWRQQH0i/OE18QMZJY1b8ZM0zuauIxQGusC6B2+282C4Nww7Ca3YwzyNGw45cPZWNiDqSErV3mf5dgGpfaF/N1p0B7wy3qOE4GjUvHLGgVIbWecgIOVglyzu31Fps07C1YSntoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731983295; c=relaxed/simple;
	bh=UccQ+prik4fjQkC8oH/YJPmgnEYnbjg/FRuiAZaLDKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KcdbtSAtDjCTM48RDtALcbHj0Yjjbp8LGTdHLDTw0t66gX3BKuZJYi6KCqv0VUKY741bWXYrOb+fD5pinecYPsVXQkiVka72tQjcV3rcmZ/WuAktKzOvSjQsGQ8tiZBCdvM/wgiDKT5WmHPirEpA3jD9pK7vuvLyroGs28bauBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=NzHdh1fd; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-462d8b29c14so2553401cf.1
        for <ceph-devel@vger.kernel.org>; Mon, 18 Nov 2024 18:28:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1731983292; x=1732588092; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hi9UHqDjN8Ni6rhq09eAG7OKaykNr6weeLf4m29aeTQ=;
        b=NzHdh1fdUPWgGcBCU2JOLeTc3LZkaARV1dJjT3KLJXHyNa4ArQ8MERYAxfY9+FfNB6
         KE3BQthteZuV2mhcpkn/3qZ645kVFjALSR4AURxaeZoqngUssPvreD1Kao8IFbSSMHu/
         t8Fm5sjr4sJVdNsYg4XhxYutwYbxYSuP064zqiyfVEINCTl4be4xlyR/QjVCk36RazyO
         bEVm1/AlOpUCCA0cEpaUvcdHhvZ04rGZ/CannL2aLmr4BRwTmAG+aAxIT/TjuF+qcC2C
         czKdkeUIwokIqs9Vte1fQfKtf4KM0EUqFT7ulLt1Pp2poP/JqTplH7tAkG0p6mXCt+Bl
         gqPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731983292; x=1732588092;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hi9UHqDjN8Ni6rhq09eAG7OKaykNr6weeLf4m29aeTQ=;
        b=GcOnCDLY/GiBhCXo6m5RjFCVZDXJ1d7N3FDxaK6OWrwIVmSf2oncyCpu2EWkWODRXA
         0tjW9fVggjfmDiftvC2Y8NtkA3gCBP16HDFViDijxmg2q7R6OvD+1t4mBXR9WSzjmSqc
         ckpigytFpc+gxhSPukIWIAyJhC1wKhUtZ5hMvMdyfiPjWQPhQPJViyRL1tdZFS1X+QNn
         /UKHgzSkp1mBl1UUhq3Rxa8v4sNHHs0li28WEPtltQLCOdxaaVwSynHX2NQfKVMc/eI9
         OroI3Sezgie48xMoRNON4Rk20KCDJC2hY+nIe+GnNRr/h3tEpQjXRaNt17jU9UOEh8gg
         LFEg==
X-Forwarded-Encrypted: i=1; AJvYcCUbPpbhA5jY+6bOnCsyqJi79kq7ahUCcmFJQrBZuwhSSY3dExeCvpZ3qN8kKvHlCWg/UcATObK0ymGV@vger.kernel.org
X-Gm-Message-State: AOJu0YxEkdeATQjm4wZFA27AT+drGIwyayZoxALSLsCuTgxzScvmzPMJ
	yXuBHs9kAZ/tt56cEvzstDrzg2DU9rMz61pJowchpi+J3oUMK36NM66iktNHCw==
X-Google-Smtp-Source: AGHT+IGWVd9s0tTOzkt/L9+H/nMMqNCNUSOHI3hwM03OUxXzbfjHm/cnEHga8/2MuOW51g+LHySeXg==
X-Received: by 2002:a05:6214:2029:b0:6d4:f77:613c with SMTP id 6a1803df08f44-6d40f776480mr185856656d6.25.1731983292642;
        Mon, 18 Nov 2024 18:28:12 -0800 (PST)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b37a8a9fdesm48293485a.124.2024.11.18.18.28.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Nov 2024 18:28:12 -0800 (PST)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v2 3/3] ceph: improve caps debugging output
Date: Mon, 18 Nov 2024 21:27:50 -0500
Message-ID: <20241119022752.1256662-4-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241119022752.1256662-1-batrick@batbytes.com>
References: <20241119022752.1256662-1-batrick@batbytes.com>
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
 fs/ceph/caps.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
index 27410bc9ce15..810abf6f7d2c 100644
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
@@ -4350,7 +4351,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	struct ceph_snap_realm *realm = NULL;
 	int op;
 	int msg_version = le16_to_cpu(msg->hdr.version);
-	u32 seq, mseq;
+	u32 seq, mseq, issue_seq;
 	struct ceph_vino vino;
 	void *snaptrace;
 	size_t snaptrace_len;
@@ -4360,8 +4361,6 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	bool close_sessions = false;
 	bool do_cap_release = false;
 
-	doutc(cl, "from mds%d\n", session->s_mds);
-
 	if (!ceph_inc_mds_stopping_blocker(mdsc, session))
 		return;
 
@@ -4375,6 +4374,7 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 	vino.snap = CEPH_NOSNAP;
 	seq = le32_to_cpu(h->seq);
 	mseq = le32_to_cpu(h->migrate_seq);
+	issue_seq = le32_to_cpu(h->issue_seq);
 
 	snaptrace = h + 1;
 	snaptrace_len = le32_to_cpu(h->snap_trace_len);
@@ -4462,12 +4462,11 @@ void ceph_handle_caps(struct ceph_mds_session *session,
 
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


