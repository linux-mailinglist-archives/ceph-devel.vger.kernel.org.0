Return-Path: <ceph-devel+bounces-4296-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C3C7D0018C
	for <lists+ceph-devel@lfdr.de>; Wed, 07 Jan 2026 22:07:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A3B3630D049B
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jan 2026 21:03:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 404D13164B8;
	Wed,  7 Jan 2026 21:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b3FNOgeq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-dy1-f195.google.com (mail-dy1-f195.google.com [74.125.82.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13352DAFA2
	for <ceph-devel@vger.kernel.org>; Wed,  7 Jan 2026 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767819740; cv=none; b=ltFWztyLcny1d3Y1EDNLD303bO8FhjEEUMLPZpxfSwMHNtb1VnXCh66Tl+lI3HlFa3krT4snG4KwTfD3jjYuEXKiTe/s+60Yu9Jjux1IWWz4tdO2BQlTFxeGDtbTGUoYxL+ZZmY6ctYqw29AXSErrcU0hFFVGawPXfdFbuvFBeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767819740; c=relaxed/simple;
	bh=UlXDD3O2ByrzfSkEqfgz2FOR/jMbTQQ8iVq+JeEXgDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjSp5XVq0yYWkVjN2xgQBRRK1YmluLZcMXAKzSERLwQoxW8cDosTMrelFt8z8cTD8mbsymNcgSZTVq+ao1eMNjqyvcVt9PukHJbpTJcKsXO5FIezlPu3B3AhlCYGuGkVRb0FDqIi9PyTD9tzFxjzJ4kLXWBcL+8pm+TvVRW0v4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b3FNOgeq; arc=none smtp.client-ip=74.125.82.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-dy1-f195.google.com with SMTP id 5a478bee46e88-2aef8e4a569so1658057eec.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jan 2026 13:02:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767819736; x=1768424536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e+E7Trlvt0oiegK/dgvIiDdQeWGh3NduIxLv4xKGd34=;
        b=b3FNOgeqEarPgzh0wct33Y1wrKOZ1miaWPU/nztZTOTqcZr7PcghaAmBgw+y1OL6FA
         XEXuQIigvW86SJccUB9qltHFiMjGiulFeKoXorYR2nbJuAwPYfwGPvZYhK2qD8Cd+DLN
         vVlW8vmwOBFEiLCnRnxBX1VlamEEBuSnOjyb6jghbnfvDiMK+ai5VBVWNc0+CrAH3IZ5
         IxWgvpJvEZMpX4mz0ccZIYLeMJikXunntT+D6XxaiCr5vi+Iu933v5GjQSCXPRu/BvJz
         ysvclVhiaDYHMkDeFwdiPLtwGc+hYE2wivF2cguF3qHeKSkqX1c21AhFGKoNUTusqthu
         iv9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767819736; x=1768424536;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e+E7Trlvt0oiegK/dgvIiDdQeWGh3NduIxLv4xKGd34=;
        b=IFidD3gtzHMVf7djry6mJRnWXZAz/vZBn9qA8doS52VSCxmhCsxxO4dGneCZWQhGfH
         0IyTfkzeJLbRm5gbelLlzTnsQXHoSKexoLAQO4uO7E7rFaXZ5Y634aCd8+Iv5MApS9ff
         DGTj2QwNpIph68dkGatMPjrPeZHlpfmnA8VBCmlSrjX4P56M2ke/XKKGOb8rZPdApUt1
         ecBBmevRuJ3XXgNiBcxBbxQk9qXvkP6zBwSCI0d/i8Hh2HBAVZANbokz/diuE4/Dnm5C
         IsY0kyV7ucnzT613uQSSZLWm4Hpo8ifbS3PoqwyJ/6eW0+l3Emp1bw1Uvrfw7UwQQrWU
         dxZA==
X-Forwarded-Encrypted: i=1; AJvYcCXVg1u4jw2N456QAmpQpSoEhXHyTiPfalVde3OLgbvQj08wmmJiLPhY4E4UQIVml30SScsUQfKSdRor@vger.kernel.org
X-Gm-Message-State: AOJu0YzdVCodgiyCgigiBMwb0TP/ya9W5k0x98nF6/g/QRziXJB45y6j
	faYK7xRl7740RAHYlX7Z8B6Pp3qX27X6EBXhHgxNA1LDEQYfkxCH30/c
X-Gm-Gg: AY/fxX6EHvK051AJlroICsKTdooCf1udaeAmNh46fV6zavSfUr9lSipKgamZyKDT+d5
	o3RMthy9Ewx+2HD1ykvmz8Lc7KHezuaAB4YNpdytwMuSA+Fv3zYalpuvxKlCGlSDQZ3S9tz3aZt
	MQ4YeLOUQsZ4cyEsItVXJNT06LuZH1cu4DYq51sLiFC8c7Fp2SfbxNa3EgkzvFrVGfqmo7EUI6U
	EBtAqMjvG+OoZy8ooM5bGOgwOHRGdnjuOXfETpXfY3UEhrdHjmMdteRp8lUrDcmExg6ghYnyMhZ
	v5exQ32uKWnov7eOUooHj7BXwx6WlqRuSvj4wXwuAHX6mIdEJPhL+Hj6UUx9KHOuZk5XV4C/+2I
	GG6GRYExz+s0poR43sCcxsB/hl5qCk5XQT4w8oNWZL1FHjL1ID9ku/EHLgfSG8Y2y3KVOtYuS+N
	fMSqkyP3BuFAmKCLy6xN0mfY7j5JnIualUNN+bLLl1ly+R6fgBs7y8nL2aAiVF
X-Google-Smtp-Source: AGHT+IGaYEwwyJ+xiqlKxx3u1rImT5in6vkJPBWncJFy16kWrM4JvVHkhraXPvmpqo2YoyQfBoyRDg==
X-Received: by 2002:a05:7300:760a:b0:2af:b9af:ea7a with SMTP id 5a478bee46e88-2b17d226fb6mr3136216eec.3.1767819735571;
        Wed, 07 Jan 2026 13:02:15 -0800 (PST)
Received: from celestia.turtle.lan (static-23-234-115-121.cust.tzulo.com. [23.234.115.121])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b170673b2esm7730320eec.6.2026.01.07.13.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 13:02:15 -0800 (PST)
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
Subject: [PATCH v2 5/6] ceph: Assert writeback loop invariants
Date: Wed,  7 Jan 2026 13:01:38 -0800
Message-ID: <20260107210139.40554-6-CFSworks@gmail.com>
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

This expectation is currently not clear enough, as evidenced by two
recent patches which fix oopses caused by `pages` persisting into
the next loop iteration:
- "ceph: Do not propagate page array emplacement errors as batch errors"
- "ceph: Free page array when ceph_submit_write fails"

Use an explicit BUG_ON() at the top of the loop to assert the loop's
preexisting expectation that `pages` is cleaned up by the previous
iteration. Because this is closely tied to `locked_pages`, also make it
the previous iteration's responsibility to guarantee its reset, and
verify with a second new BUG_ON() instead of handling (and masking)
failures to do so.

Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 fs/ceph/addr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3becb13a09fe..f2db05b51a3b 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -1679,7 +1679,9 @@ static int ceph_writepages_start(struct address_space *mapping,
 		tag_pages_for_writeback(mapping, ceph_wbc.index, ceph_wbc.end);
 
 	while (!has_writeback_done(&ceph_wbc)) {
-		ceph_wbc.locked_pages = 0;
+		BUG_ON(ceph_wbc.locked_pages);
+		BUG_ON(ceph_wbc.pages);
+
 		ceph_wbc.max_pages = ceph_wbc.wsize >> PAGE_SHIFT;
 
 get_more_pages:
-- 
2.51.2


