Return-Path: <ceph-devel+bounces-4294-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 30D92D0017A
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 22:06:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 31BA13045CD0
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 21:03:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2615B2BDC05;
	Wed,  7 Jan 2026 21:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J53VGxvM"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312A2D73B9
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 21:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819734; cv=none; b=HJe4EcwRvc5QZjJVGk+HYFCCmOx/uASk9maDEYrKPPekDHqQCLsNXSfOxgJBGpkbArdOUBWkpHZdkGtxp/IMxp1jzYmUce3ZOT+HkTfJfWY7SMXe2cSwR3Zd+zP6UOYfYg2uVjPWv0CPqZw8GeWTm8Q6rlSpuSpdF9eLMaWFDGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819734; c=relaxed/simple;
	bh=OToRqjvmUYJ/hQ/uywMC5tHsYvK3gXP3yNUZuoCsk/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TQFwPuXiAWubo0ug7CDfIPYMOfTp62JkFv+wSYSxY4PxypR879bbhYcBpM/PkuoErbqoKD+QmG6zqw4tad5ObOqbyIV0mxmI2w8bBXa9eKt7ugGHVKObSXGqj/JeAtCQeYcmTMPfNTNR23KozyvH462xCrlUmajNdEnJokWjjPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=J53VGxvM; arc=none smtp.client-ip=74.125.82.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2abe15d8a4bso4131431eec.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jan 2026 13:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819732; x=1768424532; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=StC5RRMJpz+kQrLWAhYbYP3HFYIHTdt3vEQL2gvPaOI=;
        b=J53VGxvMIZxqirtQX3wYHg+/odvWOpaJHAskxJ3YBshcYnKwwF3R4WbljGmaRUg+Qs
         /xM/QUDAH2e4UOswRlUSenqeRQHu9du25kCP8hgxpxODXi+BCkpSLQ6SqFg425Uc3h/h
         FvT75zjj1BcV2WJ0n3YOWALK11q/QXQXdrkarHvM9KjaW+OmVv4BSNpY3JzubrEcPwbc
         myhm6x5d3G3GaVDNxgHulCWD37Uh0mcDQFfjgC47Giq4JtqmVCyNjFKHe4zio9wqD/lm
         TS3qlJpzAhkku6vYjEHjy3j9CKPkdJ0Bo0iu34g73a5cVVd1STbIUpHtOub7fNjfbiEo
         VeIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819732; x=1768424532;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=StC5RRMJpz+kQrLWAhYbYP3HFYIHTdt3vEQL2gvPaOI=;
        b=ogBNFakUYU3ljv7Ijm70OVz8Oa7cDFjvOlUkbI3mQxyjKP6lnL4z4WkXlezpqLZ2Pr
         Aj3G7CmaTBnJINRs9uF21Pc9tpnVm1+4eHFQpeeFIwq/FEyqFbaXF1TVN2gwHOHYbG35
         krv1xTk3VPmaHd5fqNIChJOZacnFNIDoUAh/SHHl04scIh/NUG3lLUV9WyiS+YocrGLn
         SU1GkY0hUKS2vwA4TARHlEd1YcsMWTa8/mdEL/pm7MnVWb1Br1uuFuLM1dyQtDsFZbhC
         IFISL6DiuTmaMrZV8zLqkpD1E2Hef+e4uCkhcvo+68rk9XGuIHRojJj0MPnZwiMSxCDU
         yLCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhRvtcsH+4qzAxzDfTr/7YfJ6RGz0ZafesW5enAa/jgt2Lzq7BcM42J5OrWya5q1iYCPmngBxsCw/p@vger.kernel.org
X-Gm-Message-State: AOJu0YyQM48Z01MAuCMxGqNGNOLcwXxiogP/BHFUbSQ+RlFM09544XSu
	d7AGUCLP2HBcJajbxM5iFPbPV7SV/jLnB0Nw8AmfixUEykpNQ/tQTuXM
X-Gm-Gg: AY/fxX4CR1JpweZWdC0IEAiXK8tm6Ra8eg4v7LwM6DfQzxKWctCoVXoK9e2i4Qyjwjm
	kCOCYZ4uKzgK+XWQ+d+e03NKPvclvBY/Ao4GlGGOTlrP9lddVE4VtHtSE4HzsoiYFdlQpDzzjEy
	ELBYOoFx5g1jWOacVEgjJI7DIOSJh+FNHRKiTHfrw0IYrBdPxKE+a6ocFTpga2CXz7zmajj2IXh
	99i5+ciBtZKOcnhTym7l8HyQdbgAqYQ0wuckFmGFGugUYKEmaqwilyoBfGJJSDRYBQ/wkjo/SFU
	HLSdWBc4DdO0H3AlPeQSBvtWZZlQwhsyNQ/aaa1JfXS5AeLkfhZTUcyneugIkIy5ERoLlz3NldZ
	fkL7cjP70fDHUWEoltrX0nFUUw/bOGvOStqp8YVY/kdNUkw6NTD38GSbEO7NEJeUPlhN/CVMCQL
	jAjYhJF3LjLMUxFaDp2DaDenpBMi8rhdvA1BtR3Y3qK9op1rAeMYbm1qPKaxfm
X-Google-Smtp-Source: AGHT+IHsusTxGdP1PS4z/IoCh9itAIP1JdP4x5wJw6BXtiBXvisAnQNe01ae9GbbYPWzAyzvMWqFZw==
X-Received: by 2002:a05:7301:e2b:b0:2ae:5ffa:8daa with SMTP id 5a478bee46e88-2b17d200bc3mr2817972eec.5.1767819731857;
        Wed, 07 Jan 2026 13:02:11 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170673b2esm7730320eec.6.2026.01.07.13.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:11 -0800 (PST)
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
	Sam Edwards <CFSworks@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/6] ceph: Free page array when ceph_submit_write fails
Date: Wed,  7 Jan 2026 13:01:36 -0800
Message-ID: <20260107210139.40554-4-CFSworks@gmail.com>
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

If `locked_pages` is zero, the page array must not be allocated:
ceph_process_folio_batch() uses `locked_pages` to decide when to
allocate `pages`, and redundant allocations trigger
ceph_allocate_page_array()'s BUG_ON(), resulting in a worker oops (and
writeback stall) or even a kernel panic. Consequently, the main loop in
ceph_writepages_start() assumes that the lifetime of `pages` is confined
to a single iteration.

The ceph_submit_write() function claims ownership of the page array on
success. But failures only redirty/unlock the pages and fail to free the
array, making the failure case in ceph_submit_write() fatal.

Free the page array (and reset locked_pages) in ceph_submit_write()'s
error-handling 'if' block so that the caller's invariant (that the array
does not outlive the iteration) is maintained unconditionally, making
failures in ceph_submit_write() recoverable as originally intended.

Fixes: 1551ec61dc55 ("ceph: introduce ceph_submit_write() method")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 2b722916fb9b..467aa7242b49 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1466,6 +1466,14 @@ int ceph_submit_write(struct address_space *mapping,
 			unlock_page(page);
 		}
 
+		if (ceph_wbc->from_pool) {
+			mempool_free(ceph_wbc->pages, ceph_wb_pagevec_pool);
+			ceph_wbc->from_pool = false;
+		} else
+			kfree(ceph_wbc->pages);
+		ceph_wbc->pages = NULL;
+		ceph_wbc->locked_pages = 0;
+
 		ceph_osdc_put_request(req);
 		return -EIO;
 	}
-- 
2.51.2


