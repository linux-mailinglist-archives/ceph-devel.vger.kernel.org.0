Return-Path: <ceph-devel+bounces-1908-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B90AA99CBCD
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 15:46:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 83788283D69
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Oct 2024 13:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C066F1A76CF;
	Mon, 14 Oct 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="DjYDxTRx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C481DA53
	for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 13:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728913594; cv=none; b=IWAp/+Seyy/ktMu1EUHZ+1wCZLvNGQUyeLNBVHGL5GbmiUytO7SjVBe3KdfU1WQx/O+hq2JAh5wZGrHEguR6ONQtfup/1jOwSbtHj6lUWwolts+Hx9YPc7kNPkCaCy8mu/hTKEe599VtZpz7pIvuoqWTVCt4goI2JJRZnhnn2Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728913594; c=relaxed/simple;
	bh=vA7gQ4QlD4+heVbKXE77HzaXG+U08fb6uLAkt7Vn3Z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PlnIf9YOqYVz1oOAkXHuWlMcWkhVujfzA4FX7Fn8kjZXpagaJhLB9VnO9ZSuWTQy9d5y53RYez0O1PuCOkQXPVpetwEw/cSdJco3ppFa+dnHihknZ0Ou7QoIfp8+D3/osncVVRi4caZ6ROF8fxM6/zpppzYhFPL2SkzkM2xM+IE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=DjYDxTRx; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-6cbe9e8bbb1so26941766d6.1
        for <ceph-devel@vger.kernel.org>; Mon, 14 Oct 2024 06:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1728913592; x=1729518392; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0BDbkRqRkZ58RWGTUQtyX05fcLDqJrW9w2cIMEG6OCY=;
        b=DjYDxTRx8m00gJWRzTN+Rhe/kkqWQkKykQYUS0a5BrfBpVMA0O/BdU6OU4qSfCxuAs
         24x1BqfOc4RxI11XCFCW+3qcglW6ANtNWXuylsxAXfqwK09Tz8pOu4xypGntYYXWyZde
         ntj6AQ0D7AkKSVIiic3RCB1tgSAeF4S9d1gt50wEQkTuw7NsRaFHbukHttshgsMBuYgb
         fqCz6HZXWebMgKkrRpgTnacy8KvRarS3FTnNmOHiHACNhIkxlvhX2Ka/2WiokLNCeBGG
         ndzU68LIaFaF8zwVoPUl4E5NwqEHTKkT1lWKRRlty1AFOyAqvH1HCQWh5IZR6z4oShbt
         XO3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728913592; x=1729518392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0BDbkRqRkZ58RWGTUQtyX05fcLDqJrW9w2cIMEG6OCY=;
        b=jXXZPoCizHhMiDwiG1YRITjVWGTKr5MmPMfvsH8LhkNAO/OqiL1uUfnfMAuCbksqNq
         YDoRcLqueU+jLbXagQrYQaXAHBZ+NP0Ft6IXqpnX8vmzQh3JkCcNmVp7PL4pZWF5W5X8
         CXn8LqZG5y6AZEBYGSVnL6Cxfi0XC9gTHztlQrDb2Jaqkj19ffPZ1d+hkGkJEZXCOIOg
         Vf1bO2ufCKREHIe2JG/rjV2xwvtfcabfN/1Yz4NepYiq+/R75s3FSnNWrQ2To1sCvX1V
         sz1oZmwCzTbXfs3aC7bJqbuE8eBlMc3VK5V31J04JJspbhImF7BmqJXcoUkIHt+yUb3Q
         XueA==
X-Forwarded-Encrypted: i=1; AJvYcCVbBOa3GzIVYMnZP1AHnoMY0ErYkp+rAHH0BAKOdlVN/7QQYZBGs5CYepqxacwdO8tnIJ/3buZy9EWj@vger.kernel.org
X-Gm-Message-State: AOJu0Yy5BRNdAuYAsmr83zQDbqVFReEmgwZ2vC/4ivT/Y4oNw6d+MxQd
	gBL/xZqBBssb+Kf3VsVGH0fCSTESvL7u/MLKXzZjM38BWP9XaiiEinkm7sSSKA==
X-Google-Smtp-Source: AGHT+IEGCA21dHb5ZzF4Xh/HRGRpD5nKJtwOP87LWxQeHszz39wKm/idCKHUJWwBDMxS2aVbxac2GQ==
X-Received: by 2002:a05:6214:2c06:b0:6cb:e603:1c3a with SMTP id 6a1803df08f44-6cbf9d43c48mr113730346d6.25.1728913592130;
        Mon, 14 Oct 2024 06:46:32 -0700 (PDT)
Received: from batbytes.com ([216.212.123.7])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6cbe85a7700sm45584966d6.7.2024.10.14.06.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2024 06:46:31 -0700 (PDT)
From: Patrick Donnelly <batrick@batbytes.com>
To: Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>,
	ceph-devel@vger.kernel.org (open list:CEPH DISTRIBUTED FILE SYSTEM CLIENT (CEPH)),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/2] ceph: requalify some char pointers as const
Date: Mon, 14 Oct 2024 09:46:23 -0400
Message-ID: <20241014134625.700634-2-batrick@batbytes.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014134625.700634-1-batrick@batbytes.com>
References: <20241014134625.700634-1-batrick@batbytes.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Patrick Donnelly <pdonnell@redhat.com>

Signed-off-by: Patrick Donnelly <pdonnell@redhat.com>
---
 fs/ceph/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 73f321b52895..42bdbe5b7ef9 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -286,7 +286,7 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
 	struct ceph_fsid fsid;
 	struct ceph_parse_opts_ctx *pctx = fc->fs_private;
 	struct ceph_mount_options *fsopt = pctx->opts;
-	char *fsid_start, *fs_name_start;
+	const char *fsid_start, *fs_name_start;
 
 	if (*dev_name_end != '=') {
 		dout("separator '=' missing in source");
-- 
Patrick Donnelly, Ph.D.
He / Him / His
Red Hat Partner Engineer
IBM, Inc.
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D


