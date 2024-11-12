Return-Path: <ceph-devel+bounces-2072-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B7589C63C5
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2024 22:50:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 78B1AB23118
	for <lists+ceph-devel@lfdr.de>; Tue, 12 Nov 2024 21:16:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11854219E5F;
	Tue, 12 Nov 2024 21:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="QsXA01Io"
X-Original-To: ceph-devel@vger.kernel.org
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E36149DFF
	for <ceph-devel@vger.kernel.org>; Tue, 12 Nov 2024 21:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731446174; cv=none; b=dUxwQrIUJdWnuOHjpo3Jga1BTkjZdrzuRZC+GL3/hsqTo5UtxaU1ljIqu0uLfn1XYuv5EEr7Akhl5llLlPUurLzit7YvmgiFzsmPtJdpChB1MEeoQMvAi9S2kLWhckhzmfqO20aWBZoFVyB4Gu+pJLaPjmyv1BZ3FGLUXtBek0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731446174; c=relaxed/simple;
	bh=idgxBwg+ecmwQcPU8J7cbMzIR9H2YKpY1e19001XMEg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nadh1tuTaR3M2vX+KvX2s4HEqTegxI0zYEUs48PZzNw15gXg931EphwjYAYYDG4Do34cheIjV3RLUBazakgYAInXtFCjbbp5RMarHxMhKRinFOKjnXj/pqdMU0EdFQdIAJT3YXNBXzd+cUQgfqu6yowLslsRX7RB8vJNr5JH/ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=QsXA01Io; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1731446166;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wYcFeXVW7KhZxdfS3M8PWwaYqDY2atAEB5NmiQdrI4U=;
	b=QsXA01IoLTbZvYcUDy2kp6PmUxzSK/joDX1DR4euJIP1AHt8h+xHqstix+Ql6Yp26ctWH7
	LKe80B2VlbNeUAR+8/2L0z9wJS5QYkkVFQNGNq+9e2+5DN9Sdb39tAIAekCfLMftIakP/y
	3PE0AQKsIL5IVyDLkUj8KTRanob6rOs=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ceph: Use str_true_false() helper in status_show()
Date: Tue, 12 Nov 2024 22:14:39 +0100
Message-ID: <20241112211439.207184-2-thorsten.blum@linux.dev>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

Remove hard-coded strings by using the str_true_false() helper function.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 fs/ceph/debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/debugfs.c b/fs/ceph/debugfs.c
index 24c08078f5aa..fdf9dc15eafa 100644
--- a/fs/ceph/debugfs.c
+++ b/fs/ceph/debugfs.c
@@ -357,7 +357,7 @@ static int status_show(struct seq_file *s, void *p)
 
 	seq_printf(s, "instance: %s.%lld %s/%u\n", ENTITY_NAME(inst->name),
 		   ceph_pr_addr(client_addr), le32_to_cpu(client_addr->nonce));
-	seq_printf(s, "blocklisted: %s\n", fsc->blocklisted ? "true" : "false");
+	seq_printf(s, "blocklisted: %s\n", str_true_false(fsc->blocklisted));
 
 	return 0;
 }
-- 
2.47.0


