Return-Path: <ceph-devel+bounces-4234-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B738CEB1F6
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 03:56:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 03AF83032108
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 02:55:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9ADF22E613A;
	Wed, 31 Dec 2025 02:55:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PQ2lS/m6"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD6B12E62CE
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 02:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767149730; cv=none; b=cXsFlyX+Sxq9aXlosBSzoN9rHqMLLdrT2IxRDZhsTSf2uMx6ILUqKDzDJcVwGx+OXhZUD5m11rk9bM9Otx3Zc33dfICRVdwj+AozFen2xBNS6KiA4qnNER/6P05+kRkV1WugfM0mfZinCXbRFz1CptbY+rar5l/XLocAmaD0UxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767149730; c=relaxed/simple;
	bh=w1Epuv8pplEL0CHRjiqpgO68o19GjvzKVSFTQ/iERRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhZnAYu0WuashvCZTQkr2jQjDdOVfY5BlkImtROGMFeh1W1rhg9ymFCAPu6C3i7FWM4GVxuJ79erDx71M5GTgnlapqbIzZd+kmbpSCV6LnJqjcGsYavFWhdXoQNAAMXcG1cTEsrUATqAQQVpN6x6MDX+d2gSgfs82u9cqu3DLuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PQ2lS/m6; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so7756191b3a.0
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 18:55:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767149728; x=1767754528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ovFZ7nDpGXAGjzX1rK/nF0C1dw1vDfNt7z4qsrWCWJw=;
        b=PQ2lS/m6xVR43MYALQcEXKGkrLrqODYxOZDmTvpL1wlF9ZFreFNLoDP2EX5gRkzbE7
         wZKCqmAcc4lsYm/6HK29ud0NBE+r/17xaen+GNpPAPG5ZLhYML5iBItX1GOvkg3xMDCp
         42y9esTtVBJt0BioiBEHpHAdVXs8qw63IHUqLolL6SxdbdqcTop+7TPGGMKoJEidj4D5
         j6LnxVgOtaC/35y2/M4nVTuK+l7kqZMvFuRgi+eA/M2Z8r1z9sp6YfrfWyElE6fS679F
         OfhGiE8YNx7jrZN9E6CoPBHAJwO83xDVs1Go2Nk9XKHJHT+aDtPRrgxMt+6X8/sqfRj1
         mZgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767149728; x=1767754528;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ovFZ7nDpGXAGjzX1rK/nF0C1dw1vDfNt7z4qsrWCWJw=;
        b=HoDZjzPv8peVkD2/3Z+05Wy2F9KkRBnD4eUuGz9gTgmGUBiXWztGJzp321l+VYmx3L
         huoYwO3lixFnSZNT2Jn30d2iKDEROQuYh5zzVt++ZcbDMaKmjR72q037NsdCHJQmdWZt
         U5LwE/kHRtQZEI3A5UiBm73EFH47BgkAhtyZFJAS2YtfAvzw4w/IJKJ6gOJUu2WaLIZS
         WILc0McQtHWx3S4wCho6YO54eVb9Ldbjv3b1SeKUHeueeO+GQpOSPuWirWUR+EEk2mau
         4vmvn7gLCsENehwv+/aN8t40wTGlEkcQQ+PxjDY15w1C4It8dDQDSAjnujWst7xE0L7G
         YcRQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv/UDc5gb52C9xIeIQd3LB5xVdC8IBPzUtc8PG8bfyDoJKhrJO39rz7Z95GOphriW0xK6d2rkp1oKh@vger.kernel.org
X-Gm-Message-State: AOJu0YwyLJmk3+Z22kLKZdG+dZ29Jkw0PXdOr2BKcWY7c3/ShcpNh0dy
	wwagAEW5/q3esZgC/PcDgWshpErIaWPw8r+vZgOSixVpc4m+4ktrXOY3SwOhkg==
X-Gm-Gg: AY/fxX7mtoucIbbLF0C4zexEtCpNALVE7scvrlHpmFeR03xgFswCoNZtbk+Pu8gOorv
	pYxWcOSG/dcQ+HGSyIFSz16+GGltbt1GiWsMlfbLKZi8apJyRp8G6cUR8dzawt4NdQhIu5R9MQU
	ACRMI9wYH5O/zNm3s9tpozKhtNLdpg32KdfTXW5/UI4s7RcaC3255xvUDkkEoG0oJf8q69EsiOf
	xQ3zPkM4jIOWJfMBoYIvu5vkY/+kJBsTYaPJ/z53ZXqk1++U1fojDmWa5YAERY0Uz4szf7LVLzb
	4Ax3FxKrxk51TN7tR0YLpbSZWEWUXOb5i5ShMuX2nZLL/PYjxXyAHLKVrc916L/qZ+ZMGu+Q1Gl
	5YtLRlHMpr0LQ8VSaQ8VitlU5q9dCQt5PPtp8ttHfISa+7J4qSKIcDlBO9H9N2GHYaaXlaFx9/r
	Rgaw==
X-Google-Smtp-Source: AGHT+IFjVb9L7i5dRy0ErgLaowmMDW/jAgagrfbQrXsnKJtMt/MDazwp5eKXxShX9HNXUzfl7Ik/Yw==
X-Received: by 2002:a05:6a00:1d14:b0:7e8:43f5:bd44 with SMTP id d2e1a72fcca58-7ff6725797emr32738775b3a.48.1767149728092;
        Tue, 30 Dec 2025 18:55:28 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e892926sm33623646b3a.66.2025.12.30.18.55.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 18:55:26 -0800 (PST)
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
Subject: [PATCH 1/5] ceph: Do not propagate page array emplacement errors as batch errors
Date: Tue, 30 Dec 2025 18:43:12 -0800
Message-ID: <20251231024316.4643-2-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251231024316.4643-1-CFSworks@gmail.com>
References: <20251231024316.4643-1-CFSworks@gmail.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When fscrypt is enabled, move_dirty_folio_in_page_array() may fail
because it needs to allocate bounce buffers to store the encrypted
versions of each folio. Each folio beyond the first allocates its bounce
buffer with GFP_NOWAIT. Failures are common (and expected) under this
allocation mode; they should flush (not abort) the batch.

However, ceph_process_folio_batch() uses the same `rc` variable for its
own return code and for capturing the return codes of its routine calls;
failing to reset `rc` back to 0 results in the error being propagated
out to the main writeback loop, which cannot actually tolerate any
errors here: once `ceph_wbc.pages` is allocated, it must be passed to
ceph_submit_write() to be freed. If it survives until the next iteration
(e.g. due to the goto being followed), ceph_allocate_page_array()'s
BUG_ON() will oops the worker. (Subsequent patches in this series make
the loop more robust.)

Note that this failure mode is currently masked due to another bug
(addressed later in this series) that prevents multiple encrypted folios
from being selected for the same write.

For now, just reset `rc` when redirtying the folio and prevent the
error from propagating. After this change, ceph_process_folio_batch() no
longer returns errors; its only remaining failure indicator is
`locked_pages == 0`, which the caller already handles correctly. The
next patch in this series addresses this.

Fixes: ce80b76dd327 ("ceph: introduce ceph_process_folio_batch() method")
Cc: stable@vger.kernel.org
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 63b75d214210..3462df35d245 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1369,6 +1369,7 @@ int ceph_process_folio_batch(struct address_space *mapping,
 		rc = move_dirty_folio_in_page_array(mapping, wbc, ceph_wbc,
 				folio);
 		if (rc) {
+			rc = 0;
 			folio_redirty_for_writepage(wbc, folio);
 			folio_unlock(folio);
 			break;
-- 
2.51.2


