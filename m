Return-Path: <ceph-devel+bounces-3215-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ED46AE87E5
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 17:24:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 483FA1C24A82
	for <lists+ceph-devel@lfdr.de>; Wed, 25 Jun 2025 15:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3CF32BE7AB;
	Wed, 25 Jun 2025 15:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p4zTCpIm"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C129E11A
	for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 15:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750864935; cv=none; b=P87Wnqqbr6dBIug61TuLJWcwfK8mroTJW0k6BAVN61ytuzW3kGiQwh1JqJGi9yMJKvGxLG4Jk0/2qMO4rV09Hlz5BNHXDjKRYDASDP25dJN3QyDtnHFzqLoK1L8KTGOIzUU+sF8g5bPEiva7YYwLaQqluOoCTfccVv7UHGqKuzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750864935; c=relaxed/simple;
	bh=aTkJQnR/3DETZjCrMFipfbUfY5SsPpOZ1VX4D8ujLV0=;
	h=Message-ID:Date:From:To:Cc:Subject:MIME-Version:Content-Type:
	 Content-Disposition; b=XzDapm1f3YPnA3AQmOZg9vyW+mlVEQ28OkTsdS9iwQXmaQ0mLlzz8da3U+GLCltI8Rd0KMgk58UsGi9itLvICHh7p2pJ+kgQ7QJKN7x7e7MpuX7SxOQPOTd34cHOcJ8kAuBMwvzC7Y++BS2oYWLWeT2WbR4HDcP7yiG7z88oiPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p4zTCpIm; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-735b9d558f9so601910a34.2
        for <ceph-devel@vger.kernel.org>; Wed, 25 Jun 2025 08:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750864933; x=1751469733; darn=vger.kernel.org;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=u98SmNY03cRBjpwBKU5+I1U9gP6hvTPRDks/D5f8cPE=;
        b=p4zTCpImNNnbGlWsO67b4H/W/CW0sjDE6vYfK0JTfFywa0bcYYIzVSNig62b/x39R4
         JDGiM/OHl+d8uz7zpjMy6OtMtzBDY8iG3Bbg8qBV1FEsh6ZtefUqNxxFM6lsTZyO+eKW
         UYsD/uFynkjrMFgA/W80A+pGH853Kg2iu0zxZ07hF6K7t07q0qK8ynWNoszVl0mK+iSI
         IflvDX4+qiZ6LrKrFNAAiSC8sCCkRULMqZ0GpGCWtsmjk5ViyhtHQGcYbvQKIM8bV7hc
         /TCo+PocYltKNpxDCeHBCsEvTVl46HykTQsXZUt99IqDf6qKQtCzhk5+jhbNqBK/0Uhc
         d96A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750864933; x=1751469733;
        h=content-disposition:mime-version:subject:cc:to:from:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u98SmNY03cRBjpwBKU5+I1U9gP6hvTPRDks/D5f8cPE=;
        b=frhF1CRiiNyoWn9IcTPu5eVnPzcrfGl1z98ZNgUYkDBwxfN8uX4ntUGuOV06l1Ru/v
         yRBTTG8k3PZcVwccDnSPkk3AQhdZ6nqmOLXCdwq1RBgAh8LBxpspytcptLM6FF/QGJWH
         nDG2rAx+oCqP4t0WdK6KHzRR8sTxV6c+DozC+R+cnC9fnD8eYk5vDwSHFab/CzL3RSkZ
         8/EMd8w8aCzqoEf0Hz+9A0i9IC//LkOZfRBQDp6kXXh1PSy//t+LigZ/6dagX0eG7FP3
         6NVZQ4zDZAtKWxgrpbbcp0K6K/wJvagKWfJCx0BR1udI/g4EMMnudpqxzP3Rnu9VFQLq
         N1dQ==
X-Forwarded-Encrypted: i=1; AJvYcCUq1olVOSb6Imh9g0aWJTpR+GGxSccLorRcwzOUqYOzHEa69oyQS8VQZ8+8vuvNIAspn98hrIxvDX0L@vger.kernel.org
X-Gm-Message-State: AOJu0YyfvA5enwhh9XTiZnW4JK93A6fNYCla+/bhKTXTpmjHDsgM9J+o
	q9yK9V6ASAmViGacL+B3xQHJLkm46Bx3RKKH1Ue2p2gijNj4p60mN5d8QRtGzohkrug=
X-Gm-Gg: ASbGncvSJhKPmJEiLjg9JqQs2LgNCn35aUoAkM3A/r87/R8QoQNIocfQW+b49g/X3fT
	RvhVtp64G28g79UdQgzAgXRrt5r0Gp7GUhwUe9mVgpL6CwF1azqbxWlJqZ1PZaO+pqxYblBXBAi
	y7FL4MB+JaIHf6g2gLUgum+CL2i8JIhyOpLf+bdPeC2eCo+5ouV/6a5RdlYWkz7PCkEzCgcD6Q1
	TIk4VjjFeIl4U4mIGa0qS3iBVqaRXfTsdIEdTVujXUVJA4p7vITUEmGNGsg5wxSlLtI/sOlSjES
	BabI+IHADLcZpSeSvPUAxPR7H3rbVdiJm0Kv7PkVBurr/Dpo86aDz4P8JvPuP5n7gAJPdw==
X-Google-Smtp-Source: AGHT+IHkG6dat7iqtvzwTRnE7a7/Ug1VTKQvcFownkvnX4pRkEWxDAtT4ssRBcmMzlRv3IfqQ4RMqQ==
X-Received: by 2002:a05:6830:8088:b0:72b:7cc8:422 with SMTP id 46e09a7af769-73adc7eb8eemr1793945a34.20.1750864932939;
        Wed, 25 Jun 2025 08:22:12 -0700 (PDT)
Received: from localhost ([2603:8080:b800:f700:1fca:a60b:12ab:43a3])
        by smtp.gmail.com with UTF8SMTPSA id 46e09a7af769-73a90ca9c12sm2236713a34.50.2025.06.25.08.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 08:22:12 -0700 (PDT)
Message-ID: <685c1424.050a0220.baa8.d6a1@mx.google.com>
X-Google-Original-Message-ID: <@sabinyo.mountain>
Date: Wed, 25 Jun 2025 10:22:11 -0500
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Xiubo Li <xiubli@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: fix NULL vs IS_ERR() bug in ceph_zero_partial_page()
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The filemap_lock_folio() never returns NULL.  It returns error pointers.
Update the checking to match.

Fixes: 483239f03149 ("ceph: convert ceph_zero_partial_page() to use a folio")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/ceph/file.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index d5c674d2ba8a..f6e63265c516 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2536,12 +2536,13 @@ static inline void ceph_zero_partial_page(struct inode *inode,
 	struct folio *folio;
 
 	folio = filemap_lock_folio(inode->i_mapping, offset >> PAGE_SHIFT);
-	if (folio) {
-		folio_wait_writeback(folio);
-		folio_zero_range(folio, offset_in_folio(folio, offset), size);
-		folio_unlock(folio);
-		folio_put(folio);
-	}
+	if (IS_ERR(folio))
+		return;
+
+	folio_wait_writeback(folio);
+	folio_zero_range(folio, offset_in_folio(folio, offset), size);
+	folio_unlock(folio);
+	folio_put(folio);
 }
 
 static void ceph_zero_pagecache_range(struct inode *inode, loff_t offset,
-- 
2.47.2


