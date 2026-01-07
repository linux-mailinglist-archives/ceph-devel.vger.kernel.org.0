Return-Path: <ceph-devel+bounces-4293-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id EF296D00174
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 22:05:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 68B8730A4EEC
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 21:02:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C2B62D77EA;
	Wed,  7 Jan 2026 21:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dJEfy+e3"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA1D2D0292
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 21:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819732; cv=none; b=iRPbxK9b8z4NTgRN/miWq4izW1pM4zAf23pzdLFo+nsaTt6thrjqbMI5m94FNS19RR+luZKcsj6xS5A3mXTrBY2WvEe1emXRvKr7lm6MsOKRtwqRHQw0Ah3qOIoKfaQkQyqeWAAkDBAtWOX26Bk0yhZX6mFly9uC1q/SWbss7/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819732; c=relaxed/simple;
	bh=+OMCjLpYjNGGYfZdJjYQd5xrfdW6cvuAZrYjo1yzsPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSU1rTBYmhHVbq4EQ4Aqy2I5eCYm+zjn9+6ygNyg3wHt2XRsvhNp7YKrPyC5iHgCepHTIlza0h7WZ65q2auVKCFQoVu3XrUVYSyQ4yaA62WReqt6y6jVUJvML0E491GmKngkxBZHorC1VRTI7RpL0YCGUP+9wuoVmoeMyRktp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dJEfy+e3; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b053ec7d90so1714730eec.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jan 2026 13:02:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819730; x=1768424530; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GD9+M0L1TL+nHtGjY77JqppAv2xqxZhHU8cYw4+7xmc=;
        b=dJEfy+e331TidlLiFpSFFrBPOS797CIQ7A5F/1RdsRprkf5blG5ocgPphFXMjJ2VTs
         qldT2EHbWo8YF/XD0m80NbNlpgWufKWgXkhISKPnraVuy9NC1bPXSh9CqMmsdMVlqOmE
         y+EvALPA2oGkRtKzq3XcVULdycFe8x+i0KcIx3LjhDfoAIvbt2qK3sgGWiFRrqJKp174
         VttQxjx1vQirpmU0ndKAyrwlHe9NkZSLBQadvKYHFEA3yrzQIICuKh2gsiWqAibc6LE0
         +v8bk7nH+PqZDd+yURKNCoSB4QrX3pkVy6wHzidPgAMXS2d+x4n7p+LbmSDphuH7Fv9k
         ngJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819730; x=1768424530;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GD9+M0L1TL+nHtGjY77JqppAv2xqxZhHU8cYw4+7xmc=;
        b=aebMP7XCjf5isnHOv8WNlUVA/InCAmxuBzPQZf9y/COTTsrp1kllruGjP04nmvWs2f
         gMEnAagAd3Q4WZlsN/sDcH5uiW4QzGRZebRet2vuNeg3n+B1jy/fa2y36Kf383KLpUaD
         XVkuLKgluBmg2cUJHmTjehLJt41w8MogQtQCTee2q7MN6H7Lwzm+pyCr4dlu70Km8oIg
         TnQC0bznb7K+wjW/0cjWei0aHCW+lpu0L9pEgf5B+XPHNH4cK122oRUlQcpOwmZtKLzJ
         JTgt4JWaP3bEiJyfNbb+x7HeDvSVbe4ThNFapfUDdLuGvKvtzU/zoRRP3KlUfKj7I/pL
         tsJA==
X-Forwarded-Encrypted: i=1; AJvYcCVUrMRc4Lz61k8z9BibEp226nksJYfyW4EERSUdfVryEpagGU54f9dhJRv304+mvA2Cc0UCUiNhExH5@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5B+kS1ahOIe6Vyso8VrVBJtBz7rxoz6Hg6rqxH6/ylJWWc31j
	dsXP96NDOC/clYMcI/D8EocvfqjTZPjsPqbX6AoLZC6S/jnixO3D+ts5
X-Gm-Gg: AY/fxX4XI2VykdYtrF/slU2AEThssk1lJzTfhNxX5joZFz4K6/bjDdbqQM5lt5q37hz
	v7po66kL5EvtCN5gqBQowjgnp5SeBfsNP5JLZaMBoJe+RJ6Qp6kkXatJ4VmzL+7nGiAJxMOs8B1
	aZpECcugX61uApI3m22TWCAps5FzC0NrHYKK2fyWEfQGgXO6UUeTlncy1Fgh2f2lB2MreFDFuvd
	7Dq9+O/S+f4Pbh0xaASa9hF1/lEnJdpncB2WuLJP2ulH+yUu+mddNENJonSPOB/HeCZoYu0p002
	BZpdGG+TNQSvHngCuG961AeJv3/uu6BpdEpED/56iHhzBbmYXqV8gd2H3H1FezNs8L4JX6e1KOv
	hgPjSl/+mrwa0HWDwkMG9sXmTaNVxEGmuZi6rMsc0F2HMykZmWeYm/6okKh6vQzM5wVPh6wA7mC
	PddTM+QZ8kkuYv/KdLwHtFVwPbR6eM2YDjsBzSGuEpDMfmNbSxUgOZ7+D7WUGF
X-Google-Smtp-Source: AGHT+IFmRzf4pdV3GuAH14ZP8NjG8Wy8k2FewwYwSLBXQ+brWhVevt7B0bSV0EESgMlR/cm8NffJRQ==
X-Received: by 2002:a05:7300:8aa4:b0:2a4:3592:c612 with SMTP id 5a478bee46e88-2b17d2d6606mr1893273eec.35.1767819729839;
        Wed, 07 Jan 2026 13:02:09 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170673b2esm7730320eec.6.2026.01.07.13.02.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:09 -0800 (PST)
From: Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
	Christian Brauner <brauner@kernel.org>,
	Milind Changire <mchangir@redhat.com>,
	Jeff Layton <jlayton@kernel.org>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>
Subject: [PATCH v2 2/6] ceph: Remove error return from ceph_process_folio_batch()
Date: Wed,  7 Jan 2026 13:01:35 -0800
Message-ID: <20260107210139.40554-3-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260107210139.40554-1-CFSworks@gmail.com>
References: <20260107210139.40554-1-CFSworks@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Following the previous patch, ceph_process_folio_batch() no longer
returns errors because the writeback loop cannot handle them.

Since this function already indicates failure to lock any pages by
leaving `ceph_wbc.locked_pages == 0`, and the writeback loop has no way
to handle abandonment of a locked batch, change the return type of
ceph_process_folio_batch() to `void` and remove the pathological goto in
the writeback loop. The lack of a return code emphasizes that
ceph_process_folio_batch() is designed to be abort-free: that is, once
it commits a folio for writeback, it will not later abandon it or
propagate an error for that folio.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3462df35d245..2b722916fb9b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1283,16 +1283,16 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 }
 
 static
-int ceph_process_folio_batch(struct address_space *mapping,
-			     struct writeback_control *wbc,
-			     struct ceph_writeback_ctl *ceph_wbc)
+void ceph_process_folio_batch(struct address_space *mapping,
+			      struct writeback_control *wbc,
+			      struct ceph_writeback_ctl *ceph_wbc)
 {
 	struct inode *inode = mapping->host;
 	struct ceph_fs_client *fsc = ceph_inode_to_fs_client(inode);
 	struct ceph_client *cl = fsc->client;
 	struct folio *folio = NULL;
 	unsigned i;
-	int rc = 0;
+	int rc;
 
 	for (i = 0; can_next_page_be_processed(ceph_wbc, i); i++) {
 		folio = ceph_wbc->fbatch.folios[i];
@@ -1322,12 +1322,10 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = ceph_check_page_before_write(mapping, wbc,
 						  ceph_wbc, folio);
 		if (rc == -ENODATA) {
-			rc = 0;
 			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			continue;
 		} else if (rc == -E2BIG) {
-			rc = 0;
 			folio_unlock(folio);
 			ceph_wbc->fbatch.folios[i] = NULL;
 			break;
@@ -1369,7 +1367,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
-			rc = 0;
 			folio_redirty_for_writepage(wbc, folio);
 			folio_unlock(folio);
 			break;
@@ -1380,8 +1377,6 @@ int ceph_process_folio_batch(struct address_space *mapping,
 	}
 
 	ceph_wbc->processed_in_fbatch = i;
-
-	return rc;
 }
 
 static inline
@@ -1685,10 +1680,8 @@ static int ceph_writepages_start(struct address_space *mapping,
 			break;
 
 process_folio_batch:
-		rc = ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
+		ceph_process_folio_batch(mapping, wbc, &ceph_wbc);
 		ceph_shift_unused_folios_left(&ceph_wbc.fbatch);
-		if (rc)
-			goto release_folios;
 
 		/* did we get anything? */
 		if (!ceph_wbc.locked_pages)
-- 
2.51.2


