Return-Path: <ceph-devel+bounces-1722-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8814D95B93E
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 17:02:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00AEDB28304
	for <lists+ceph-devel@lfdr.de>; Thu, 22 Aug 2024 15:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C2881CC8BB;
	Thu, 22 Aug 2024 15:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="UKAPoAOP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E31171CB31F
	for <ceph-devel@vger.kernel.org>; Thu, 22 Aug 2024 15:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724338898; cv=none; b=eIfxLKT8HAjAiMHRiLavJk91eNTBLRjV7scV2tuuJemk7ZCvl4j9Cf0GcSPOmBEZs452W3UaNhzR+4LVG2eqFqGUCloGvhHmFk3bio6s/eHf3ytkTvmFbKYJcABjioZb/4N+iCEpv6yTSBOWqfNUmnBCdM/yQcDQreaNrwpbLg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724338898; c=relaxed/simple;
	bh=HzRe2jksaT1cCrv5dqF/GmSe0qz6I9yQwld3Skd3v7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=slxOG6BZ6QOPWlYGfeP2Zh72uMJVlT3BlQIRav6yLHQW61GPqJgXbr8lpRemPZRKC0R5il9JJ3mGJPQtGI1Hkmc0IXOUiQTqV7hqDtas7nC0IBqM+ZodmK4um4No9/1cQ2nOISTPgG1lK4unBYueihcLlBSQ6TUdy2lgY9OXzRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=UKAPoAOP; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1724338893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Y98WIZxKPFZj+2fDBLN5zYtw3h6tEOgBZP3SB9fAeHs=;
	b=UKAPoAOPyrn+AMDGfHUPIoUA8EUJAXCgwrZJPhdrpeespcNzxfmshcuqV7eeDBb9bpF+6y
	uh68LvbwqilVyS66bOc1czbFnr3iDOjxGcB4JsMAGQj0GhKWJqmUjNkelXjdG5LbqvkgnQ
	O1xQaMM2NwO+Jv5suNayKpla6LvF84Q=
From: "Luis Henriques (SUSE)" <luis.henriques@linux.dev>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	"Luis Henriques (SUSE)" <luis.henriques@linux.dev>
Subject: [RFC PATCH] ceph: fix out-of-bound array access when doing a file read
Date: Thu, 22 Aug 2024 16:01:13 +0100
Message-ID: <20240822150113.14274-1-luis.henriques@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

If, while doing a read, the inode is updated and the size is set to zero,
__ceph_sync_read() may not be able to handle it.  It is thus easy to hit a
NULL pointer dereferrence by continuously reading a file while, on another
client, we keep truncating and writing new data into it.

This patch fixes the issue by adding extra checks to avoid integer overflows
for the case of a zero size inode.  This will prevent the loop doing page
copies from running and thus accessing the pages[] array beyond num_pages.

Link: https://tracker.ceph.com/issues/67524
Signed-off-by: Luis Henriques (SUSE) <luis.henriques@linux.dev>
---
Hi!

Please note that this patch is only lightly tested and, to be honest, I'm
not sure if this is the correct way to fix this bug.  For example, if the
inode size is 0, then maybe ceph_osdc_wait_request() should have returned
0 and the problem would be solved.  However, it seems to be returning the
size of the reply message and that's not something easy to change.  Or maybe
I'm just reading it wrong.  Anyway, this is just an RFC to see if there's
other ideas.

Also, the tracker contains a simple testcase for crashing the client.

 fs/ceph/file.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 4b8d59ebda00..dc23d5e5b11e 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1200,9 +1200,9 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		}
 
 		idx = 0;
-		if (ret <= 0)
+		if ((ret <= 0) || (i_size == 0))
 			left = 0;
-		else if (off + ret > i_size)
+		else if ((i_size >= off) && (off + ret > i_size))
 			left = i_size - off;
 		else
 			left = ret;
@@ -1210,6 +1210,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			size_t plen, copied;
 
 			plen = min_t(size_t, left, PAGE_SIZE - page_off);
+			WARN_ON_ONCE(idx >= num_pages);
 			SetPageUptodate(pages[idx]);
 			copied = copy_page_to_iter(pages[idx++],
 						   page_off, plen, to);
@@ -1234,7 +1235,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 	}
 
 	if (ret > 0) {
-		if (off >= i_size) {
+		if ((i_size >= *ki_pos) && (off >= i_size)) {
 			*retry_op = CHECK_EOF;
 			ret = i_size - *ki_pos;
 			*ki_pos = i_size;

