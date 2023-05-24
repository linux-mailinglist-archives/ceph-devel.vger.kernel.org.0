Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42ECF70FA5A
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 17:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbjEXPfy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 11:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236458AbjEXPfG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 11:35:06 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F4F0E78
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:45 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 17B3D41B3C
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 15:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684942452;
        bh=H9xVyVFm2J6DXYIa+xt6L2ldHLbh9SntsfJpFosG5pA=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=Zawuf/mUkmxlmKjHvIo8YkQSISYNN+oWu6UQULQ9n9gWrJqpLjKOh5JPYWyQ8geoG
         Hw7AmdLSei0NlWx2u1LIA9JJ5i+JSzekz6o3DUvHrAEOBFAMXnMVvFIhT4Q0WT+ULk
         UqIm3MoOZsifKN/Dla0l5bq/Z5CQ08NVPkWUV0LwN+W8+lFqQAszr/AI+sXEKMZh1T
         hbSXjiyAGZPmlr81YS4w6n3dIBi2vLLR7IRGlVyI1MqdWgbAhZPHS4X3T4wS7O8kuA
         7XfJv2cu8ORgf/J6FtoI8L+QicvwLh9z7QREZz6NNcG2PPkL/iY+wHFwbmHQlmQjQH
         Ahyge8wYY8zzg==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-970e0152da7so132635666b.2
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 08:34:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684942446; x=1687534446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=H9xVyVFm2J6DXYIa+xt6L2ldHLbh9SntsfJpFosG5pA=;
        b=BAju4ydI9NAryBorcircmPxLZJvPNJTOLBei4tEGYG4Zx5i1tPgQxKyXDrTj4ypVCA
         PUaGigFbNsP1XEg8EZxF6NBgV/Bc5BxEUZP8pjBCmdTOiSZJOLDAsxV/OVZ7UmJ/ItYX
         WlxSrmIOkFU2sRNBN2Fd8RVN7xhGwdfAkNcm/EG/mLGcaHmxV/4kbNI0W/mpGciyhgP1
         jiXoLy1BpdB0upFy6whBw/f3CWfHIZlmIsOeShtiYQ430fBkN/OH7AoAP1qij7HGpZXf
         EXQ00hzj1zxVSa5GZFmPQpMQEf60qnwGxD0fFZ6+gBx+OQSKg7ybvVV0lkhlgv/sA9+A
         5zwA==
X-Gm-Message-State: AC+VfDxlzzYAHpKqcaj+040exS4cgTUhELUCbFvqAwGzMNnQQqSyRCLT
        1Nn06KDERZ3P2mvpSrUsEYZ79OtkvI4vRitv+Ie11n2AVPwwzL675MJ0cY1pATeJ6y8MFhB0r1g
        8TvoWJJQSkuxavcy2SlVriKkXXDXxDTjqC7pVb8g=
X-Received: by 2002:a17:907:c07:b0:96a:c661:fa1 with SMTP id ga7-20020a1709070c0700b0096ac6610fa1mr20640400ejc.46.1684942446758;
        Wed, 24 May 2023 08:34:06 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4XpCjIcxhdoliupK6KKdEUY8jcq27fFWoCooizfqJ+xFZsiS/Txtj9EH8UgEqevhz9hzz8ew==
X-Received: by 2002:a17:907:c07:b0:96a:c661:fa1 with SMTP id ga7-20020a1709070c0700b0096ac6610fa1mr20640376ejc.46.1684942446551;
        Wed, 24 May 2023 08:34:06 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-088-074-206-207.088.074.pools.vodafone-ip.de. [88.74.206.207])
        by smtp.gmail.com with ESMTPSA id p26-20020a17090664da00b0096f7105b3a6sm5986979ejn.189.2023.05.24.08.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 May 2023 08:34:06 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 06/13] ceph: allow idmapped mkdir inode op
Date:   Wed, 24 May 2023 17:33:08 +0200
Message-Id: <20230524153316.476973-7-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230524153316.476973-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_mkdir() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 3996572060da..a4b1ee5ce6b6 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1024,6 +1024,7 @@ static int ceph_mkdir(struct mnt_idmap *idmap, struct inode *dir,
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
 	req->r_args.mkdir.mode = cpu_to_le32(mode);
+	req->r_mnt_idmap = idmap;
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
 	req->r_dentry_unless = CEPH_CAP_FILE_EXCL;
 	if (as_ctx.pagelist) {
-- 
2.34.1

