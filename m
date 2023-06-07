Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFD14726812
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 20:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbjFGSLD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 14:11:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjFGSLA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 14:11:00 -0400
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5E71FE3
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 11:10:46 -0700 (PDT)
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com [209.85.218.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 633C93F120
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 18:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1686161442;
        bh=iEnhNZXEpvf6z44xxB3rnp1IhVt5v+qShuvQ8nza8PQ=;
        h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
         MIME-Version;
        b=YasmJgXZG3E0HmxlVrzH2xTR8xVIHtxJ80CKsS1O5uJR4aIRZmV3RdeDUXsfVr9zU
         6KzWC2QcvkFYxoniG8Cky+ubEN9MX5uC75zL+bre7z5K1B3hoNkYOlwwaXxhRuBYuI
         zfnIBPL9u8fbjZXGHItEFVO3eL0OtGRtFdtSgf+1mWQcvBbUtTLClFRv/whM8SRTKB
         HMKBGgx9DpUSrPDh6+9Pn9GsNH6IWbqOVAJYSa9xox2aB75et/1ToAt3Oc6MbZeEyz
         6/DQwCXEEVX42zgxezfqhAFrAYyL/0KkyV3ZvIZPB3M47dcmvw4JRJuL9CyEgjjeO8
         vQiZKcpMa1UmQ==
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-94a341efd9aso692731666b.0
        for <ceph-devel@vger.kernel.org>; Wed, 07 Jun 2023 11:10:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686161440; x=1688753440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iEnhNZXEpvf6z44xxB3rnp1IhVt5v+qShuvQ8nza8PQ=;
        b=UY2L52vWBypNyKQy3wXBvLE4kjkUs8DOtjbLfk6rutD4p00SNdAAnzle9a7Q7Nihqv
         nnZgnh9Pb5DPktEhtRXNPj5Hhys4K1kKh+EfDMlKkOUw98GGNkXL64hwEQMicYBL4I56
         7itX25Eb5zyBCgVrAv/mT4tZgxfkCBO4ldioVRcywa6fvGha6k+FE5btQqVPLOfduEWV
         xSTNH+Ao1bB7e39T/QvNj+i6kCShtwnKSIFQS/bZnVdWGpCkCXqd1zFLe2V5pd9Aoffz
         NLjArJGO/kUscwC4hPUshJTNgWlScQG2cmKQU6YqeDAThz4/ULLUA9IhjA4T21Hx+wC/
         1YOA==
X-Gm-Message-State: AC+VfDwSYsJmJAyVrgNHh2b0sMv2k9VcJF43QCn/OcrShkCSXY4VNcj9
        +oNgroC7oHAkgUS9sUomLfXtFooT+UKFl/rLTTvUsnqKgaBLy4OfqMq5LGzxRywmorJqrL1DgMy
        3x+PB6dorJDISE0iL5NlZvVz6LRGEG2hN3duhwgE=
X-Received: by 2002:a17:907:6d98:b0:96f:ea85:3ef6 with SMTP id sb24-20020a1709076d9800b0096fea853ef6mr7344058ejc.62.1686161440261;
        Wed, 07 Jun 2023 11:10:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5kN0yD5UKteqOZCdE8d2DUc0BogNgwOVnzz8+4Qovf99098TrosTx+jldMHixGqT6jVCGfZQ==
X-Received: by 2002:a17:907:6d98:b0:96f:ea85:3ef6 with SMTP id sb24-20020a1709076d9800b0096fea853ef6mr7344043ejc.62.1686161440120;
        Wed, 07 Jun 2023 11:10:40 -0700 (PDT)
Received: from amikhalitsyn.local (dslb-002-205-064-187.002.205.pools.vodafone-ip.de. [2.205.64.187])
        by smtp.gmail.com with ESMTPSA id oz17-20020a170906cd1100b009745edfb7cbsm7170494ejb.45.2023.06.07.11.10.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 11:10:39 -0700 (PDT)
From:   Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>
To:     xiubli@redhat.com
Cc:     brauner@kernel.org, stgraber@ubuntu.com,
        linux-fsdevel@vger.kernel.org,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org,
        Alexander Mikhalitsyn <aleksandr.mikhalitsyn@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 04/14] ceph: allow idmapped mknod inode op
Date:   Wed,  7 Jun 2023 20:09:47 +0200
Message-Id: <20230607180958.645115-5-aleksandr.mikhalitsyn@canonical.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
References: <20230607180958.645115-1-aleksandr.mikhalitsyn@canonical.com>
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
v4:
	- call mnt_idmap_get
---
 fs/ceph/dir.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index cb67ac821f0e..aaae586de4de 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -884,6 +884,7 @@ static int ceph_mknod(struct mnt_idmap *idmap, struct inode *dir,
 	req->r_parent = dir;
 	ihold(dir);
 	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
+	req->r_mnt_idmap = mnt_idmap_get(idmap);
 	req->r_args.mknod.mode = cpu_to_le32(mode);
 	req->r_args.mknod.rdev = cpu_to_le32(rdev);
 	req->r_dentry_drop = CEPH_CAP_FILE_SHARED | CEPH_CAP_AUTH_EXCL;
-- 
2.34.1

