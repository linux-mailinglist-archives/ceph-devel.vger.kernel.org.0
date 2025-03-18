Return-Path: <ceph-devel+bounces-2954-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CF73CA67CDA
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 20:12:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1603218879FA
	for <lists+ceph-devel@lfdr.de>; Tue, 18 Mar 2025 19:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C36CA212FBD;
	Tue, 18 Mar 2025 19:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mZcjZnpk"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6C4212F9F
	for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 19:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742325147; cv=none; b=hZcMTrF+bZdLQESuLrwEDvPWoEhnqHhh0Rp542KsHLRBvReQr4mv/6oVnc1bWNAErI/y2Agfzo47X6knVfLZJRfAw/Jhgs0ZU+wxVTAKaZFXX1fBKQaVu6M4uVLtQ3zYZ0Mq2fb2StVCW+UK1ea7PqobKepe529Y83r53IeUk34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742325147; c=relaxed/simple;
	bh=tXl01hmni6T7r4BjqyE9K6WlhGrDQQDbAgv8vNqJzxM=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EXaiVmI9+PajkeEcK+SjKtNxi2BBuCE5nvp/GrV+LUfYVlMyEPRwwYJHFTZAXHd/vC8P6zopYhWZydRovHgsAvL+fesfBoiZTrbMpGb/wZLqiJythebhKBoTlmPGaOg4inprNln5I/AN1fWuiqoVfvkIxXAZWKJxozUeiX6rKiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mZcjZnpk; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2ff80290debso5602073a91.3
        for <ceph-devel@vger.kernel.org>; Tue, 18 Mar 2025 12:12:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1742325145; x=1742929945; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jMQSjeRiVVlPbntyfgaXxcc07tel+34n336i8xAzIS0=;
        b=mZcjZnpkPeGa7iSvnrYGYPruV23/sclsnfrAA1pzMgNnZ6ujLqlImsOZcK3a9RCh/3
         0nW2Jypaq1CCsHxZ6a1TDDA1Aw8McrsdEGJmCHot1eEImw8ag8cLfiGZPzaHORcQR258
         YjMeLxo9qWf1urQEbkjbSopsWesfTmNd4W7wnKw13pZuXih3rcQvm3YCmbX9+LMUL+Vk
         DGaCGtGoMhZr6CEM4+pI62VSb4rbY4HduNj0zgT1gaOdxXxURbUtzEBDtXGmUp+1BG/Y
         TmFVOWZS0Ly53wmt8tIz+OOfmv8HUieU7iEZY/FkJj0tmrsCrXMPfvN+AzTGEHpmQVGp
         0X5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742325145; x=1742929945;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jMQSjeRiVVlPbntyfgaXxcc07tel+34n336i8xAzIS0=;
        b=lfsj1iWIEEKkR/nJYjORv6tmLxLPmOytF/DEV58mvP8YWVoPeKuH1mIqT12eIOaXYX
         h8pVpq605WbN6FFspn/URnQwSOyMzwwSXWwY/h7hgvs6a0fKxPX/CnRv9HsLNLgsY5bp
         hQsPAwtuMi2LMcWsxHkWPUQuoHE0WMYDmXeM4D5psFBU2NfXmcRlEEQYfZqAevfTVEmm
         x+/VjNvndPD/QUWwQ7xRtyL9cZpGxgMLfhdOgms1iRcR8E3Mq4UR3dDtUU9fsd/RS0mL
         EXIL+Y+Lp9R7mZnqCSf8oY80NqWQG2utr44pwKfoV6dvOhc+iv5IUqu/Qk65WvSifjW8
         vCAA==
X-Forwarded-Encrypted: i=1; AJvYcCVAlJpqvMNAyummKzEdF+EV3tzShqJvmm8CEOKL0lSgPzTY4jeBil01f6EsBq0FPxA2/eq0vs0bPlWD@vger.kernel.org
X-Gm-Message-State: AOJu0YwVyHU5dAVfy3KoZU/F5H0Lp4Tbe+FVZG+rIbZs/omSqU8TfB2L
	cSeg5ta70aQlxhRGqsrZg++TkaxINS7nhpEPS/8km1g92YdI7kf3GCtXSQ==
X-Gm-Gg: ASbGncvJnXz8Imt/qWZ1IJuUtUmXn5bE6952645HovvNzMQg2kUPHtweQ1xvO7hk2mD
	mOo9O6WE24s08es+RSz4Jj5gMgE1N3I2e/EKBfX0L/zjn8ZorGflZEs5ldvHIUB+cYz6gCKJLrk
	9GrB0mKLw41sqsivKErqfU9eGH6Nf+rGbMK9fBsiu9ir8aID5mlqjjM9HuiDkCflIlRl9gHfvp8
	BhOL4YOF6+oODvuz3XLBvRdyvMMb6zNpAFNBxfJkMGf35Xtv87UFHdH3ZfEopICWU01IEuXKJed
	C0Khn5LPNzPVwD+nI6qMVniNWB+0BpFg7tO4gRIzw0hqqmc76w==
X-Google-Smtp-Source: AGHT+IG9e6nwzRU47QdwpzlEONYmkhcmoq5i14Pb9kr72QWphiQ2e5j+VvsPwNt6uYSdLR73W2vEjQ==
X-Received: by 2002:a17:90b:1648:b0:2ee:9b2c:3253 with SMTP id 98e67ed59e1d1-301ba15d98amr446204a91.30.1742325145127;
        Tue, 18 Mar 2025 12:12:25 -0700 (PDT)
Received: from debian ([2601:646:8f03:9fee:5e33:e006:dcd5:852d])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-301539ed03fsm8608471a91.16.2025.03.18.12.12.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 12:12:24 -0700 (PDT)
From: Fan Ni <nifan.cxl@gmail.com>
X-Google-Original-From: Fan Ni <fan.ni@samsung.com>
Date: Tue, 18 Mar 2025 12:12:22 -0700
To: slava@dubeyko.com
Cc: Fan Ni <nifan.cxl@gmail.com>, David Howells <dhowells@redhat.com>,
	ceph-devel@vger.kernel.org, Slava.Dubeyko@ibm.com
Subject: Re: Question about code in fs/ceph/addr.c
Message-ID: <Z9nFlkVcXIII8Zdi@debian>
References: <Z9m7wY8dGAlq4z0K@debian>
 <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <80300ccacebc13ee67100fe256b03f08dfd2819e.camel@dubeyko.com>

On Tue, Mar 18, 2025 at 12:00:52PM -0700, slava@dubeyko.com wrote:
> Hi Fan,
> 
> + CC David Howells <dhowells@redhat.com>
> + CC ceph-devel@vger.kernel.org
> 
> On Tue, 2025-03-18 at 11:30 -0700, Fan Ni wrote:
> > Hi Viacheslav,
> > 
> > This is Fan Ni. Recently I started to work on some mm work. One thing
> > that I am working on is to reduce the use of &folio->page. When I
> > check
> > the fs/ceph code, I find some code that may be good candidate for the
> > work to be done.
> > 
> > I see you sent some patches to add ceph_submit_write(), since the
> > change
> > I am planning to do is closely related to it, so I reach out to you
> > to
> > see if you have some input for me.
> > 
> > Based on my reading of the code, it seems ceph_wbc->pages[i] will
> > always be the head page of the folio involved. I am thinking maybe we
> > can
> > keep folios instead of pages here, do you see any reason we should
> > not
> > use folios here and must be pages?
> > 
> 
> I believe we need to switch from pages to folios in CephFS code. But it
> is painful modification. We need to be really careful in this.
> 
> As far as I know, David Howells is making significant modification
> namely in this direction. I think you need to synchronize the
> implementation activity with him. I'd love to be involved but,
> currently, I am focused on fixing other issues in CephFS code. :)
> 
> Thanks,
> Slava.
> 

Thanks Slava,

Let me add more context here. 
I have a patch as below, which only handle case 1 as mentioned in 
the commit log. The question I am asking here is related to the
handling of case 2 as the page passed to ceph_fscrypt_pagecache_page
is from ceph_wbc->pages[i]. After checking the code, I think it can
be folio instead of page.
My goal is to remove page_snap_context() and use folio_snap_context().

Fan


From 02b26cad4f5cb0b43047cf6e343ba5257f95c6ee Mon Sep 17 00:00:00 2001
From: Fan Ni <fan.ni@samsung.com>
Date: Mon, 17 Mar 2025 14:29:06 -0700
Subject: [PATCH] fs/ceph: Introduce folio_snap_context to avoid passing
 &folio->page

The functions that call page_snap_context() either passes in
1) &folio->page, which is the common case; or
2) ceph_fscrypt_pagecache_page(page), which only happens in
get_writepages_data_length().

We separate the handling of the call to page_snap_context for the two cases.
For the first case, we remove the use of &folio->page by introducing an
equivalent function folio_snap_context() which consumes struct folio directly.
For the second case, it involves more changes to convert, we leave it
unchanged for now.

Signed-off-by: Fan Ni <fan.ni@samsung.com>
---
 fs/ceph/addr.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 29be367905a1..aa0ad730059a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -67,6 +67,13 @@
 static int ceph_netfs_check_write_begin(struct file *file, loff_t pos, unsigned int len,
 					struct folio **foliop, void **_fsdata);
 
+static inline struct ceph_snap_context *folio_snap_context(struct folio *folio)
+{
+	if (folio_test_private(folio))
+		return (void *)folio->private;
+	return NULL;
+}
+
 static inline struct ceph_snap_context *page_snap_context(struct page *page)
 {
 	if (PagePrivate(page))
@@ -729,7 +736,7 @@ static int write_folio_nounlock(struct folio *folio,
 		return -EIO;
 
 	/* verify this is a writeable snap context */
-	snapc = page_snap_context(&folio->page);
+	snapc = folio_snap_context(folio);
 	if (!snapc) {
 		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
@@ -1140,7 +1147,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	/* only if matching snap context */
-	pgsnapc = page_snap_context(&folio->page);
+	pgsnapc = folio_snap_context(folio);
 	if (pgsnapc != ceph_wbc->snapc) {
 		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
@@ -1586,7 +1593,7 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 					     struct writeback_control *wbc,
 					     struct ceph_writeback_ctl *ceph_wbc)
 {
-	struct page *page;
+	struct folio *folio;
 	unsigned i, nr;
 
 	if (wbc->sync_mode != WB_SYNC_NONE &&
@@ -1601,10 +1608,10 @@ void ceph_wait_until_current_writes_complete(struct address_space *mapping,
 						     PAGECACHE_TAG_WRITEBACK,
 						     &ceph_wbc->fbatch))) {
 			for (i = 0; i < nr; i++) {
-				page = &ceph_wbc->fbatch.folios[i]->page;
-				if (page_snap_context(page) != ceph_wbc->snapc)
+				folio = ceph_wbc->fbatch.folios[i];
+				if (folio_snap_context(folio) != ceph_wbc->snapc)
 					continue;
-				wait_on_page_writeback(page);
+				folio_wait_writeback(folio);
 			}
 
 			folio_batch_release(&ceph_wbc->fbatch);
@@ -1793,7 +1800,7 @@ ceph_find_incompatible(struct folio *folio)
 
 		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(&folio->page);
+		snapc = folio_snap_context(folio);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 
-- 
2.47.2


