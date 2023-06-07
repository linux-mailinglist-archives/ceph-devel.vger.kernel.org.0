Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB49726424
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 17:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241377AbjFGPVo (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 11:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241333AbjFGPVe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 11:21:34 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3B31FEB
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 08:21:24 -0700 (PDT)
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com [209.85.218.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9FCA33F120
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 15:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686151281;
        bh=61DFfawCj3HGFJsReurDN7P2vYgJDYyfahDHmmx8fag=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=JSAZiIXwxfBpViPn/OF2KPke7uOrQ34kzcSDmQd/IudYehaMnEFGfkTOqu7hMF4sX
         bUj9CtL+wBDBPFon80qDPmW9BS7OKqqyuqYhlaAb9L6UbZ3qwpges3Fl0m20arxg4b
         rhXQORo8BCiIbiq/nQiwmi29q8ZzJdYDi19b4aMxds2nYh6u8431w0aFPsY3p/9SPt
         0nhWa2tYMMtMWTds22SkBO0oXbGGNq8fsi5PWZ+SktQ2Ljr7aVjzHJpwuALj+rKIl/
         R8NTLkVf1bqFsf23GVLOrRlj3yhX4Uv8avTlxKh2Ja6BxZ99uimLdHbs3tdIq1iC1x
         u7Or6iTzG2SeQ==
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-977e6c94186so288007366b.1
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 08:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686151281; x=1688743281;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=61DFfawCj3HGFJsReurDN7P2vYgJDYyfahDHmmx8fag=;
        b=feEYJqEfoPcaJWt1UsF2V/XwAFJrjE08JJZh65xbpFarrSljscLX9rVD0jxBxgykYm
         3pl2OmYaAsMfvrQwJTtt2t1aXGFJJ8kr6LPUHizlimT1MfLR8Zq7YwWztjNGjKEPN3Cy
         b+PJoN3BlCWwGozaHDpg1O/c5m0RZenU+4OsbbgCgTehuRKkKf3ZXfXEvXeioEVwF1XY
         aY4ufeBZ/ge0elIYv11gu+3qvw600podsD8nUDQMtkE9FCAuVZnNK0LiHGxvTfA54C+e
         cLiTSaDBZNv9rPRFPEXDPMwME4Q3jD1LTE68jT1nArOqkp7GP/ibD+guZh6oRrVCzkYZ
         S2CA==
X-Gm-Message-State: AC+VfDwCW//SKOL+v3tj/6KqCRGNING56edjygeQjk3ydN3jLLYCrRF5
        r0Kk4I5dwMz+BciVYRdxhRXB+xgU6J2QYArwdsuEqYb+FF0xWMcAdEeXV3qXTfKWE4FCAJMqZfo
        HKZ7EjQIKgY0io16iO5oh38iGhfTY3/eIPzqB7xg=
X-Received: by 2002:a17:907:97d6:b0:967:2abb:2cec with SMTP id js22-20020a17090797d600b009672abb2cecmr6488799ejc.64.1686151281357;
        Wed, 07 Jun 2023 08:21:21 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4NxqHb7zbbbgKKCIgUNRWQ9EnUGowkrrNsCgPXtuxOt7a7blhZ9JFrVyuZ5X4Fkx09tgkKtg==
X-Received: by 2002:a17:907:97d6:b0:967:2abb:2cec with SMTP id js22-20020a17090797d600b009672abb2cecmr6488785ejc.64.1686151281197;
        Wed, 07 Jun 2023 08:21:21 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id w17-20020a056402129100b005147503a238sm6263441edv.17.2023.06.07.08.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 08:21:20 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 04/14] ceph: allow idmapped mknod inode op
Date:   Wed,  7 Jun 2023 17:20:28 +0200
Message-Id: <20230607152038.469739-5-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607152038.469739-1-aleksandr.mikhalitsyn@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>

Enable ceph_mknod() to handle idmapped mounts. This is just a matter of
passing down the mount's idmapping.

Cc: Xiubo Li <xiubli@redhat.com>
Cc: Jeff Layton <jlayton@kernel.org>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: ceph-devel@vger.kernel.org
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index cb67ac821f0e..8d3fedb3629b 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -884,6 +884,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = idmap;
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
-- 
2.34.1

