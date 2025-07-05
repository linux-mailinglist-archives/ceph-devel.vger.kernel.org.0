Return-Path: <ceph-devel+bounces-3269-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD876AFA0C8
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Jul 2025 17:54:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A6EF43A511E
	for <lists+ceph-devel@lfdr.de>; Sat,  5 Jul 2025 15:54:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B6B21FCFF1;
	Sat,  5 Jul 2025 15:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QSOqrcY7"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4817D1DE3DB;
	Sat,  5 Jul 2025 15:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751730888; cv=none; b=JvIxjpn/Y5GwPkVwiK8MpO1Tti9Lvxg7vC6+CMtNcTQIS2lvU94gNSxLYqIUYH62OzvF0vb8gcpAroAWEHZxihmoeNKys+e1Z1LJz2RJrBErEuAQ3NL3zx8GQ9ZYvUcND4sEVGfd/3QltEsz7CL5VGsrJsbDQWqbRiE8P8T6GPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751730888; c=relaxed/simple;
	bh=QoDGogeRYTYrueryHPf4IWax+j0Vn0fX9BSWLqdqtds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tUbNoE9Eldn+L6WxcmGGridudQsrVVIygZtViCaXa25phuNAZv6rJfry1kR1WQ9ZzWLVNU5TPyNusi9JrVvZjzjCnFzq3yp1BCFlBJGCS7nQhzuX55HDgYZYlxfIvk9zyhmt1HIcAjUNR7N6JRGX3prDDQthWR1qdhf/7YlNFF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QSOqrcY7; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-235ef62066eso27508475ad.3;
        Sat, 05 Jul 2025 08:54:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751730886; x=1752335686; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OKXOhgR8Rxk7mTQK33CJ7OCCW5PMDPG1TwJy9Oc8MUk=;
        b=QSOqrcY7wW940bOw/xCMeDf2Tm7XvlvFZFuo5254zHXkMMq5UdMp4wZlP6sVw1T9oS
         GM5sHUJonIR4FOJigjPKi6opgogGgpFWCj0qrH3iL6mShyePpeII11XsskZWd7w3lcWr
         GdggfSOAMY0ReslhIuPD1WEVIcig0c6I6a/aOq72noSTy9adVP7jdRUqjeoqQBCV0ZoJ
         m6sOWnJA+h//mAEEnzrYpGaRQjYnyM7Vu7vilP5c+Bjxvv0O/427MgPGNmav/dgqgeJQ
         CyuPlWEWkyN5PCgSegpQbim6v9UikXCqgYmtS5wmamXf7tNhZezT94EcE/EvTOGk+4J4
         mQsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751730886; x=1752335686;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKXOhgR8Rxk7mTQK33CJ7OCCW5PMDPG1TwJy9Oc8MUk=;
        b=mZKdaGDAdWVmzJ63PVPdnqKhfo2JVv/KEfcasedv3npgA5X71WCd2ZIvfk+Cg1h/2c
         FgiOnobTR/zzSr0UOq7wkxLpImqDk/BY91ER+Nl+8pfNHwSRkctsCOliuTLnv8Ri7Paw
         FHk4IKlrz+TsoEFSfb8StBU4hKrJIiO9nSol+A+TxaTqAPCFKYzFA7P/bM/09Q9BHaf5
         49nts+4fUDz4A694a9eYUtgEKxN8oCrq7Q0XP9rBYdH/1r1TAsiEiasTVpvHZARZ1g4X
         kUssU1CTBWPtxHBL+b240wTjOaEmToP7ZnoIqjLIaO2Q/TzsINVe9VwhOyP5/ZeHeBOh
         3Qow==
X-Forwarded-Encrypted: i=1; AJvYcCVKo9ncZ6mM9OBTB1rTpOEv8kuKTedClf+MdI/8h9vAH0FVozUhMI6N1na1VG7pFZ2/vO3StNt8iv2M4Yo=@vger.kernel.org
X-Gm-Message-State: AOJu0Yyev1+Hd79J4CTn/7ejKRqQYGhgTTiMYoM+Eq1IMUgtCHF4jdim
	Cps6rxZX88CU7BioypxbtPsVTiWg2bRLmtOA6E/wffdGFWPR4CLEBCQDquJckw==
X-Gm-Gg: ASbGncuiNxlITcLqaj+3eE3B85tLQqmmU1PzlJ9/ovdkEDBMicw81eyk0vQpsO7jFon
	W60wtdxD9QWND+KyKtNrIuTWGag9GRXgk/9JLBENpRZddbYGOPZDvP4NxpD3ptYwlOe6dU0g04m
	3gTq4oHeAhcz3kteP4zZn6zhV5QEzdFljYLULqvHazAJfT0jmkbRCV/h3S2NCHXZXUhzvxvfWR1
	7f4mvmhxjTmWJjbLUd9Dy4KsCE9jvl9DEnrizIq1SSgEMullbBYGEh8GTCD38jIyYLSRkpkKfZW
	S+CYNWp9A/S0hiat8vYyrRQnlzjQH+j/AVZB3k8BPkUlzm7fTO4CdH5tOeou1jk5D4fvJagabFh
	7H4Tadozgf61MB/8=
X-Google-Smtp-Source: AGHT+IEUKaeAeD1PyKCw8Vb7Uuu4b8zUNH1TFe785TFSy0lODfTG+ODrDrMOrE53KrSqL3ve9AIz0w==
X-Received: by 2002:a17:902:e54a:b0:238:f2a:8893 with SMTP id d9443c01a7336-23c90fdb5acmr38491375ad.42.1751730886371;
        Sat, 05 Jul 2025 08:54:46 -0700 (PDT)
Received: from localhost.localdomain ([2401:4900:882f:293:70ba:30fe:2559:8217])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23c84593e0asm44143855ad.193.2025.07.05.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Jul 2025 08:54:45 -0700 (PDT)
From: Abinash Singh <abinashlalotra@gmail.com>
X-Google-Original-From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: xiubli@redhat.com,
	idryomov@gmail.com
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Abinash Singh <abinashsinghlalotra@gmail.com>
Subject: [PATCH RFC] fs/ceph : fix build warning in ceph_writepages_start()
Date: Sat,  5 Jul 2025 21:24:22 +0530
Message-ID: <20250705155422.802775-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function `ceph_writepages_start()` triggers
a large stack frame warning:
ld.lld: warning:
	fs/ceph/addr.c:1632:0: stack frame size (1072) exceeds limit (1024) in function 'ceph_writepages_start.llvm.2555023190050417194'

fix it by dynamically allocating `ceph_writeback_ctl` struct.

Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
---
The high stack usage of ceph_writepages_start() was further 
confirmed by using -fstack-usage flag :
...
fs/ceph/addr.c:1837:ceph_netfs_check_write_begin        104     static
fs/ceph/addr.c:1630:ceph_writepages_start       648     static
...
After optimzations it may go upto 1072 as seen in warning.
After allocating `ceph_writeback_ctl` struct it is reduced to:
...
fs/ceph/addr.c:1630:ceph_writepages_start       288     static
fs/ceph/addr.c:81:ceph_dirty_folio      72      static
...
Is this fun used very frequently ?? or dynamic allocation is 
a fine fix for reducing the stack usage ?

Thank You
---
 fs/ceph/addr.c | 82 ++++++++++++++++++++++++++------------------------
 1 file changed, 43 insertions(+), 39 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 60a621b00c65..503a86c1dda6 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1633,9 +1633,13 @@ static int ceph_writepages_start(struct address_space *mapping,
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_client *cl = fsc->client;
-	struct ceph_writeback_ctl ceph_wbc;
+	struct ceph_writeback_ctl *ceph_wbc __free(kfree) = NULL;
 	int rc = 0;
 
+	ceph_wbc = kmalloc(sizeof(*ceph_wbc), GFP_NOFS);
+	if (!ceph_wbc)
+		return -ENOMEM;
+
 	if (wbc->sync_mode == WB_SYNC_NONE && fsc->write_congested)
 		return 0;
 
@@ -1648,7 +1652,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 		return -EIO;
 	}
 
-	ceph_init_writeback_ctl(mapping, wbc, &ceph_wbc);
+	ceph_init_writeback_ctl(mapping, wbc, ceph_wbc);
 
 	if (!ceph_inc_osd_stopping_blocker(fsc->mdsc)) {
 		rc = -EIO;
@@ -1656,7 +1660,7 @@ static int ceph_writepages_start(struct address_space *mapping,
 	}
 
 retry:
-	rc = ceph_define_writeback_range(mapping, wbc, &ceph_wbc);
+	rc = ceph_define_writeback_range(mapping, wbc, ceph_wbc);
 	if (rc == -ENODATA) {
 		/* hmm, why does writepages get called when there
 		   is no dirty data? */
@@ -1665,55 +1669,55 @@ static int ceph_writepages_start(struct address_space *mapping,
 	}
 
 	if (wbc->sync_mode == WB_SYNC_ALL || wbc->tagged_writepages)
-		tag_pages_for_writeback(mapping, ceph_wbc.index, ceph_wbc.end);
+		tag_pages_for_writeback(mapping, ceph_wbc->index, ceph_wbc->end);
 
-	while (!has_writeback_done(&ceph_wbc)) {
-		ceph_wbc.locked_pages = 0;
-		ceph_wbc.max_pages = ceph_wbc.wsize >> PAGE_SHIFT;
+	while (!has_writeback_done(ceph_wbc)) {
+		ceph_wbc->locked_pages = 0;
+		ceph_wbc->max_pages = ceph_wbc->wsize >> PAGE_SHIFT;
 
 get_more_pages:
-		ceph_folio_batch_reinit(&ceph_wbc);
+		ceph_folio_batch_reinit(ceph_wbc);
 
-		ceph_wbc.nr_folios = filemap_get_folios_tag(mapping,
-							    &ceph_wbc.index,
-							    ceph_wbc.end,
-							    ceph_wbc.tag,
-							    &ceph_wbc.fbatch);
+		ceph_wbc->nr_folios = filemap_get_folios_tag(mapping,
+							    &ceph_wbc->index,
+							    ceph_wbc->end,
+							    ceph_wbc->tag,
+							    &ceph_wbc->fbatch);
 		doutc(cl, "pagevec_lookup_range_tag for tag %#x got %d\n",
-			ceph_wbc.tag, ceph_wbc.nr_folios);
+			ceph_wbc->tag, ceph_wbc->nr_folios);
 
-		if (!ceph_wbc.nr_folios && !ceph_wbc.locked_pages)
+		if (!ceph_wbc->nr_folios && !ceph_wbc->locked_pages)
 			break;
 
 process_folio_batch:
-		rc = ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
+		rc = ceph_process_folio_batch(mapping, wbc, ceph_wbc);
 		if (rc)
 			goto release_folios;
 
 		/* did we get anything? */
-		if (!ceph_wbc.locked_pages)
+		if (!ceph_wbc->locked_pages)
 			goto release_folios;
 
-		if (ceph_wbc.processed_in_fbatch) {
-			ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
+		if (ceph_wbc->processed_in_fbatch) {
+			ceph_shift_unused_folios_left(&ceph_wbc->fbatch);
 
-			if (folio_batch_count(&ceph_wbc.fbatch) == 0 &&
-			    ceph_wbc.locked_pages < ceph_wbc.max_pages) {
+			if (folio_batch_count(&ceph_wbc->fbatch) == 0 &&
+			    ceph_wbc->locked_pages < ceph_wbc->max_pages) {
 				doutc(cl, "reached end fbatch, trying for more\n");
 				goto get_more_pages;
 			}
 		}
 
-		rc = ceph_submit_write(mapping, wbc, &ceph_wbc);
+		rc = ceph_submit_write(mapping, wbc, ceph_wbc);
 		if (rc)
 			goto release_folios;
 
-		ceph_wbc.locked_pages = 0;
-		ceph_wbc.strip_unit_end = 0;
+		ceph_wbc->locked_pages = 0;
+		ceph_wbc->strip_unit_end = 0;
 
-		if (folio_batch_count(&ceph_wbc.fbatch) > 0) {
-			ceph_wbc.nr_folios =
-				folio_batch_count(&ceph_wbc.fbatch);
+		if (folio_batch_count(&ceph_wbc->fbatch) > 0) {
+			ceph_wbc->nr_folios =
+				folio_batch_count(&ceph_wbc->fbatch);
 			goto process_folio_batch;
 		}
 
@@ -1724,38 +1728,38 @@ static int ceph_writepages_start(struct address_space *mapping,
 		 * we tagged for writeback prior to entering this loop.
 		 */
 		if (wbc->nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE)
-			ceph_wbc.done = true;
+			ceph_wbc->done = true;
 
 release_folios:
 		doutc(cl, "folio_batch release on %d folios (%p)\n",
-		      (int)ceph_wbc.fbatch.nr,
-		      ceph_wbc.fbatch.nr ? ceph_wbc.fbatch.folios[0] : NULL);
-		folio_batch_release(&ceph_wbc.fbatch);
+		      (int)ceph_wbc->fbatch.nr,
+		      ceph_wbc->fbatch.nr ? ceph_wbc->fbatch.folios[0] : NULL);
+		folio_batch_release(&ceph_wbc->fbatch);
 	}
 
-	if (ceph_wbc.should_loop && !ceph_wbc.done) {
+	if (ceph_wbc->should_loop && !ceph_wbc->done) {
 		/* more to do; loop back to beginning of file */
 		doutc(cl, "looping back to beginning of file\n");
 		/* OK even when start_index == 0 */
-		ceph_wbc.end = ceph_wbc.start_index - 1;
+		ceph_wbc->end = ceph_wbc->start_index - 1;
 
 		/* to write dirty pages associated with next snapc,
 		 * we need to wait until current writes complete */
-		ceph_wait_until_current_writes_complete(mapping, wbc, &ceph_wbc);
+		ceph_wait_until_current_writes_complete(mapping, wbc, ceph_wbc);
 
-		ceph_wbc.start_index = 0;
-		ceph_wbc.index = 0;
+		ceph_wbc->start_index = 0;
+		ceph_wbc->index = 0;
 		goto retry;
 	}
 
-	if (wbc->range_cyclic || (ceph_wbc.range_whole && wbc->nr_to_write > 0))
-		mapping->writeback_index = ceph_wbc.index;
+	if (wbc->range_cyclic || (ceph_wbc->range_whole && wbc->nr_to_write > 0))
+		mapping->writeback_index = ceph_wbc->index;
 
 dec_osd_stopping_blocker:
 	ceph_dec_osd_stopping_blocker(fsc->mdsc);
 
 out:
-	ceph_put_snap_context(ceph_wbc.last_snapc);
+	ceph_put_snap_context(ceph_wbc->last_snapc);
 	doutc(cl, "%llx.%llx dend - startone, rc = %d\n", ceph_vinop(inode),
 	      rc);
 
-- 
2.43.0


