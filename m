Return-Path: <ceph-devel+bounces-3484-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AB532B39B4B
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 13:16:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6755E466630
	for <lists+ceph-devel@lfdr.de>; Thu, 28 Aug 2025 11:16:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEEBE2D738E;
	Thu, 28 Aug 2025 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="UzYBM3Yp"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F02815B0FE
	for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756379766; cv=none; b=oDwBpMkR0cozQTR+xJPUIjZl7+E9XRqB9lEPoCo1b4RdlVg6JecCW7Q9UOkxMyTTpRZTtArwrR7fzDd7KgElspw+tAyIt75jR8qP1JJMVmLAbvEhyjY9pdo/82fUeqRP/LQ42sxZbJdWaR0uqgQdP0dBMPx0b5H3Fk0A2NLTjJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756379766; c=relaxed/simple;
	bh=x2CwY0f27ONX+8fmDC68h7bPHgxl9g7WINlENPZM7FQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ULKjfd2ne2YqEEpTZec/iP0g6ZGvH+cIlzSwz5ITYvHiqin2ulYqddds7M7297MrtrQ/ai6AyWMFyomSpaOOcMVm8GmdYnuNtPj97O1uj9Tg0L1fJH1ePomNHz9nnu+mWt76u3IX+y65OFzUxL+ArQUp/quKn0IUwJwnFT5r5dk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=UzYBM3Yp; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45b7da4101fso123215e9.3
        for <ceph-devel@vger.kernel.org>; Thu, 28 Aug 2025 04:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756379763; x=1756984563; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/QHBOrXAja8iWLDpJiD9eodym9F/g93zNuwCDVC3UT0=;
        b=UzYBM3YpxrIrUDUDvNEAWw2vlcnHMx9856CwgCzIbpqufWz5OIC7H3YnE9AEr+5ViS
         CX0GWtKb0n7Rke7qJPva1KgsXh7vscFoPb9p955qR5TqOlqnGH99lfR9htG0G+yoZfVP
         wWaXDhQCVi+E/lshbryHpuCGuFUB6qUIu23Xi7K4Up92Tws8mHzDJm4Wip5NA0axCmt7
         WcTcEbMjBpxuJBxhdaXo6XEUx67BWrIP3HYEs6FjNoO62dUJuncyzJLJbYhLvVOFVMaS
         YFdGN6iYOJ9culihj1bkvcuzxY1IDmnAYuAdwrMhrTxIkUBtUgYREytBFt8MQO6UhAUq
         gj3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756379763; x=1756984563;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QHBOrXAja8iWLDpJiD9eodym9F/g93zNuwCDVC3UT0=;
        b=oTu/gUJDfXrYzw8kshyY8nHWZ0/qsfIaEpoHOSyAkT6r/7lBtbDJesg2E/madnYSBM
         Cd5OH3uD3ZsCgmNqMIwEQ+szFrK7iCIWMKsrgrN8W6uP9UK5LiVmZViV85VBwoOgk9TI
         GYyZaDz9a614IQldYOtjG8A+SdBcAsfp9GK2VKtMJl4KBZIiLyw5spUSk/7mscOalbEc
         v9yG6zYsN80HX845+NgxbfgKRg0lldBfj6W+WupGsgWNMOWRjHd457RKTRBmiShX8Y0z
         KdADM7NBIhbXCYf3Jgfr6Nmag/Z5ilCnVvuXcf/qfFK/bMPfvPzJjtJfEvHnajzhR55/
         2sfQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+OsIKqG/3GDvjDaspEqNBFvZlNgA//kN+ut2Dv851kzJ9VX3ojpbLkzIfjQIdXa0BD2C42Hg0Hsu0@vger.kernel.org
X-Gm-Message-State: AOJu0YznwJWRXfWRXIZSIiV3Eb92BXVjSDmb8gJZ0hJ2lv78RyTwarHq
	X+sLXtUL6nQuE3QOAOXvdNzxx2+pbq0x4OMaz9hdakMWaiHrXK+3+pHMbnkA12l8yrE=
X-Gm-Gg: ASbGnctx38R5crBpxQvlX44+EXfkETVrdnP1sQzRxzGzwItdgUKi0EgHmk9mdk0b88q
	q3SkXgFnQLcXkXZdkoLgx5ZMgVdDsajBbmdqAkg7mzjWS/dlhIWaLvHtiflQPzNDEH3yo+tEbTp
	B6xTIV6yHtuOqWCDPwJ/UsS5Ij7CWsuBp9q4YWKg7//ELkCGEgUpmUSS9GURvZgwkoW1VB13VC2
	uMUTAMcd750HVxSJgGRAh1/++2tFqnRQ/I5rKcZLTAVDyFYCc0I2mvoCQMDcJO6MHlCbfOP2tSk
	8YNHmixUxDQ3W734ykRJr9hadVC37auU/lrvFXs7A33+pZzqxqc5rlVeuezkKKmC1Ib2jIP9ddT
	a4qFlKOhTsj3wEm4y6LtvVJwaXNhnCVFzChQhEhC2vY0hPW8Ieqvr469l0eb1O3JqPD1rakHFJL
	iwAERMcXHjVxd0oUX3v7A9El+S/tDBSWPd
X-Google-Smtp-Source: AGHT+IErHCmWbg2YMUeSrTBCHGmKcPBhN8tMdoOfMQOVPGyHr5ox98O0LhP5cUl5kKNQOFlN8MsLNw==
X-Received: by 2002:a05:600c:35c9:b0:458:b7d1:99f9 with SMTP id 5b1f17b1804b1-45b517a0655mr207154405e9.11.1756379762476;
        Thu, 28 Aug 2025 04:16:02 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f306c93sm69608945e9.14.2025.08.28.04.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 04:16:01 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: Slava.Dubeyko@ibm.com,
	xiubli@redhat.com,
	idryomov@gmail.com,
	amarkuze@redhat.com,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	brauner@kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>,
	stable@vger.kernel.org
Subject: [PATCH] fs/ceph/addr: fix crash after fscrypt_encrypt_pagecache_blocks() error
Date: Thu, 28 Aug 2025 13:15:52 +0200
Message-ID: <20250828111552.686973-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function move_dirty_folio_in_page_array() was created by commit
ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method") by
moving code from ceph_writepages_start() to this function.

This new function is supposed to return an error code which is checked
by the caller (now ceph_process_folio_batch()), and on error, the
caller invokes redirty_page_for_writepage() and then breaks from the
loop.

However, the refactoring commit has gone wrong, and it by accident, it
always returns 0 (= success) because it first NULLs the pointer and
then returns PTR_ERR(NULL) which is always 0.  This means errors are
silently ignored, leaving NULL entries in the page array, which may
later crash the kernel.

The simple solution is to call PTR_ERR() before clearing the pointer.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Link: https://lore.kernel.org/ceph-devel/aK4v548CId5GIKG1@swift.blarg.de/
Cc: stable@vger.kernel.org
Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
---
 fs/ceph/addr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 8b202d789e93..e3e0d477f3f7 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1264,7 +1264,9 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 								0,
 								gfp_flags);
 		if (IS_ERR(pages[index])) {
-			if (PTR_ERR(pages[index]) == -EINVAL) {
+			int err = PTR_ERR(pages[index]);
+
+			if (err == -EINVAL) {
 				pr_err_client(cl, "inode->i_blkbits=%hhu\n",
 						inode->i_blkbits);
 			}
@@ -1273,7 +1275,7 @@ static inline int move_dirty_folio_in_page_array(struct address_space *mapping,
 			BUG_ON(ceph_wbc->locked_pages == 0);
 
 			pages[index] = NULL;
-			return PTR_ERR(pages[index]);
+			return err;
 		}
 	} else {
 		pages[index] = &folio->page;
-- 
2.47.2


