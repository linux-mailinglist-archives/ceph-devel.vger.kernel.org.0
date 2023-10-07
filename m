Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28A577BC63A
	for <lists+ceph-devel@lfdr.de>; Sat,  7 Oct 2023 10:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234167AbjJGIws (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 7 Oct 2023 04:52:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234147AbjJGIwr (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 7 Oct 2023 04:52:47 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62204B9
        for <ceph-devel@vger.kernel.org>; Sat,  7 Oct 2023 01:52:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-40684f53ef3so28087495e9.3
        for <ceph-devel@vger.kernel.org>; Sat, 07 Oct 2023 01:52:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696668764; x=1697273564; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gGpDf0VBcZvqRh2SwXKj5dQfQYejycf85txd4Kvut3o=;
        b=xuSXo9G5DSZpMlw47oIUe2I9R9MFHeXox+irZG/vZRSbKVdHPzrktODt5ZdhvFxu2U
         5TVSsUO4UyH5ufmrG1MZeLuMegHDPNMVwOUMdxe37ra2xwngbZxdl1vd0DR6a40dnkYZ
         WrHaTidNuxzzOH3EIXLCUkJs8SadOdXr3MudOTtl1NTq0SFjXpdTsY6nsvKH2H+i/w5w
         sF0gLSciXkwRyTl58iQSL+lzki1QPjJYA2i+a3Qm//RqTAlZS0zzbPdpFvQE96gV9fas
         v91YRNH4yK3X79zAH0VTz30OXiAy/oeh5ikOPBvAQ76rwQnhUMfExC13bZjh/SBXvecP
         U9Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696668764; x=1697273564;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gGpDf0VBcZvqRh2SwXKj5dQfQYejycf85txd4Kvut3o=;
        b=CKRsBH71/DTqBcD9h9tyX8etsgzQwkJsp936ZwxuZZSNX5yvbr4r1v7lCWm95AC7RH
         sQ/hQH8amfodICMNkW8ao+N6IxJuWLg/FM+FmKLOkSeMcrx3qEiYBEx7R2MpnMgLcs2W
         9p4QF390T+o4nOpxqD2MxzBFm5itXGxaQpNfx/KQKgnpNjB2kvKM/t3+5I8uI+R+JEbT
         0A878D451viVDOBEvz+6Lw0/7dGIBRYORjv/VNmOoGCAwHxeXqRabVHdeSb90wzSX4+p
         CGrI4+dix5fyN4upOBaEIIPToYzTN8hem3+tgyrIrCoXmYnVWts6rbZ8ZK71nfR7g9HL
         6HkA==
X-Gm-Message-State: AOJu0YwTZC96VOu83rJbaV+13yKYfeQAhHVl0OkDOqWEZn+y4O2KcDHf
        5rGECXHrp7PxTJoTJZeheqfLZw==
X-Google-Smtp-Source: AGHT+IGBXBfIz+KaAEbZZXWVYvfiGUuZBp9LlIFw0Wy1HxE4t7QAeJXKMNjPETFa527p/A1pIaKTVw==
X-Received: by 2002:a1c:6a16:0:b0:406:44fe:7621 with SMTP id f22-20020a1c6a16000000b0040644fe7621mr9147876wmc.25.1696668763412;
        Sat, 07 Oct 2023 01:52:43 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id s13-20020adfeccd000000b003198a9d758dsm3660149wro.78.2023.10.07.01.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Oct 2023 01:52:42 -0700 (PDT)
Date:   Sat, 7 Oct 2023 11:52:39 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Luis Henriques <lhenriques@suse.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH] ceph: fix type promotion bug on 32bit systems
Message-ID: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In this code "ret" is type long and "src_objlen" is unsigned int.  The
problem is that on 32bit systems, when we do the comparison signed longs
are type promoted to unsigned int.  So negative error codes from
do_splice_direct() are treated as success instead of failure.

Fixes: 1b0c3b9f91f0 ("ceph: re-org copy_file_range and fix some error paths")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
32bit is so weird and ancient.  It's strange to think that unsigned int
has more positive bits than signed long.

 fs/ceph/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index b1da02f5dbe3..b5f8038065d7 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -2969,7 +2969,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
 		ret = do_splice_direct(src_file, &src_off, dst_file,
 				       &dst_off, src_objlen, flags);
 		/* Abort on short copies or on error */
-		if (ret < src_objlen) {
+		if (ret < (long)src_objlen) {
 			dout("Failed partial copy (%zd)\n", ret);
 			goto out;
 		}
-- 
2.39.2

