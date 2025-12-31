Return-Path: <ceph-devel+bounces-4240-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFC8CEB37D
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 05:06:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A641930334D4
	for <lists+ceph-devel@lfdr.de>; Wed, 31 Dec 2025 04:05:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BF39630F92E;
	Wed, 31 Dec 2025 04:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eeFvztkq"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A9B26E719
	for <ceph-devel@vger.kernel.org>; Wed, 31 Dec 2025 04:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767153947; cv=none; b=hHE68W0J4F6bhQA5cugCVED7afQ84ooS2xoA10/SUcqOQop8pi1gBiNZWQuWZcMnxYYZzgOnV0/UoPafWuPaSBG1FhQOXZrueABKcpcUM3EcErbBAM0oYjDxPGKMNvdOl3dPX7gMz98AXrUAR41FuqPjjNR5FQ58uNMlef9qqFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767153947; c=relaxed/simple;
	bh=eyTjdiZ37TXITwaXTn301I67o5O9HQL17aDOi0EXwfg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=tO/8lVew7kl9eQhsvY0sBjpCGFGuq9/lrkdd28+RpoE4TMSxsriceDDw23V4XqZIFBfc5lTVyPPh+LG+dfLE/0kr7jI125XZv+cAwA9Vn3DceWSkePAtOICo4clVDBH7U885lNes1u5ewM0lkC777MYNQT/f58kaVyG/OVR3yXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eeFvztkq; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-34c1d98ba11so11316623a91.3
        for <ceph-devel@vger.kernel.org>; Tue, 30 Dec 2025 20:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767153945; x=1767758745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=pkAsjBRWEEiZYWip+Ahck4hdZ1l64PIDTBXDn8AsGi8=;
        b=eeFvztkq81L3QWaWrgIu4tkSHBK6hb+ZZ79VMV1zLNGOGP2CsDyN0EVfBFDEFKATIv
         ITJhQXVd8+ng77APt1ftyolqOx6lO3i1Ujex9x2vrXL2V17rTTQS6fw+YmQcGzCRdzbj
         ENwJbCdFNmkp2Z9C62ltg6pe6BkVOzkO+HGk+sIjlmFiCGFVPcUygBmx4PqHKQ+cWTuD
         4rR6PIwxxhXMGB3c3vyRbdHjcWQHWgEPHBmHvXnTpGJuKslr/oJT9GYn0WutDYjPBVvu
         5H8svpOahfD9FE6qpNJlj4Hwi1EppLSypgSJWGMafTDvwXTO4OBaaAmF3JmbGOlFCDUx
         rAew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767153945; x=1767758745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pkAsjBRWEEiZYWip+Ahck4hdZ1l64PIDTBXDn8AsGi8=;
        b=YX2z/WgZ69YAA4hxs/lJj/ZB5WctDt4PXfhmUsQC5zSwuBSPYhjL7I31G/g4LnH3x8
         lphMr2Ei8mZC19QU2lQGy5ZUQkJNVZx2lOWpBVEEcZOxeyHH19kbulbhqrtWJU1fSR4c
         c0pqllqeV9iem5SJILwAE+4AeMu6Bjir1ULBS9PCWpAqBpePwVspNoUGS/7wjsu15YeN
         wcVOI6JAsWyLu3TZeu3cc3Rcj40tBRw5hdO3aeyE3ufrNXrnI0adsG5/Vp7NS5Y5ZIpr
         Tk1fqaOowW40P1GzfkftJPUH5YyzFCQyHzxyeU9UiBypFVSdgbfcWCpc5/H7+c0o34xy
         tzYw==
X-Gm-Message-State: AOJu0YyP+F4zOgTekCXXWiwqrsZcPt9NDiq3dDt+zNFI7T2LWQ7JP2yN
	dSBuSlMWQOBLE2YZsTzNe57TFQd8fTohAejJRTeeYxqxjNvFeQba7U+k
X-Gm-Gg: AY/fxX5CfYi1GWgV5SMMSWxk4IFBwyIZC1NZpBVsKuVudjHLk8xggADjFsVbbjiypmd
	e8dan8OHlnJIQGXu8AuLkjVgeu9E8IGlqnB97h00LC2ZUsTY851uhisZ98wL2nyclrHozKfLKY7
	WTwnrXSL8G3ibly8g81lamzfk9y5IiyobWNU0EmtRTGghCLqItBh5zpatt+wykm2uYixqSqtiLJ
	awxC93OnGFlpWk40GiXt9NZ2qD6Sz7TYDHShGZbNOTxzj8dQNMb3aYlUxwGT8n1zN+7gi//GCXM
	ipdPGQ1lFVyfAmTsxo5mALrNbTOJW7+L6R94FJRziwSn525B+XmKRfFgIrRpxwDf6fk4aLmlIZ/
	MVWAmz+lL/ETo+hTSUWGhDE/zWmo9iXS8H9BMKU+WkWQfJhsqlkh7sluFZIWxe7wgs4LVcbME9J
	+kxtNgtKygB+by
X-Google-Smtp-Source: AGHT+IHmwVuVPd14CTWSWw20fJ8pJCHFwc60F8kZ7BvwaFuBaAN+ZziuMDF1m9md2lPkEAIcYEYwqA==
X-Received: by 2002:a17:90b:1f92:b0:345:badf:f1b7 with SMTP id 98e67ed59e1d1-34e921cd4admr26688901a91.28.1767153945213;
        Tue, 30 Dec 2025 20:05:45 -0800 (PST)
Received: from celestia ([69.9.135.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34e92228b64sm31319667a91.10.2025.12.30.20.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Dec 2025 20:05:44 -0800 (PST)
From: Sam Edwards <cfsworks@gmail.com>
X-Google-Original-From: Sam Edwards <CFSworks@gmail.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sam Edwards <CFSworks@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] libceph: Reset sparse-read on fault
Date: Tue, 30 Dec 2025 20:05:06 -0800
Message-ID: <20251231040506.7859-1-CFSworks@gmail.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When a fault occurs, the connection is abandoned, reestablished, and any
pending operations are retried. The OSD client tracks the progress of a
sparse-read reply using a separate state machine, largely independent of
the messenger's state.

If a connection is lost mid-payload or the sparse-read state machine
returns an error, the sparse-read state is not reset. The OSD client
will then interpret the beginning of a new reply as the continuation of
the old one. If this makes the sparse-read machinery enter a failure
state, it may never recover, producing loops like:

  libceph:  [0] got 0 extents
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read
  libceph: data len 142248331 != extent len 0
  libceph: osd0 (1)...:6801 socket error on read

Therefore, reset the sparse-read state in osd_fault(), ensuring retries
start from a clean state.

Cc: stable@vger.kernel.org
Signed-off-by: Sam Edwards <CFSworks@gmail.com>
---
 net/ceph/osd_client.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index 3667319b949d..1a7be2f615dc 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -4281,6 +4281,9 @@ static void osd_fault(struct ceph_connection *con)
 		goto out_unlock;
 	}
 
+	osd->o_sparse_op_idx = -1;
+	ceph_init_sparse_read(&osd->o_sparse_read);
+
 	if (!reopen_osd(osd))
 		kick_osd_requests(osd);
 	maybe_request_map(osdc);
-- 
2.51.2


