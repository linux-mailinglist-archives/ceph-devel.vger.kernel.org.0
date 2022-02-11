Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F0804B255C
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Feb 2022 13:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349878AbiBKMM3 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Feb 2022 07:12:29 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbiBKMM2 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Feb 2022 07:12:28 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94542E56
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:12:27 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id fh9so8359442qvb.1
        for <ceph-devel@vger.kernel.org>; Fri, 11 Feb 2022 04:12:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ONeXesWkDq1T1rGiHOjrw8MGGvxhsHkA+E5J4kI2J6I=;
        b=BrC5A+YeNBSEr5tyuqQZs+HFEoVBBGTY3ZwM0lNDtwdJOvuQlSAhAjXx2yPUB8cqfQ
         UujBEuWg/0rBp7hzRhcyDoi3IaB68n4gE4mmgujQqaoMeWqOq4Ll2HpvZ6drvz9aAVKX
         iSlCYPm7cKVeJ72GYYhJRvYm3IDGIeBlZVD/sdyCUIbkjCg8cEzKE5kFQ3d7GhvM3kKo
         RIdC/SXKj4iuKV78IVHvirhEw/zf1bLnJkrBKRsm4iyp+dV/WzfRkTAguvOd93lzdtJL
         uG4vj8RICez7cnzai3a1vyw0dbkqj5v2bAv8xNNkGMhLoj5PMgksnGSHBn+mzTuLj+Uk
         Yp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ONeXesWkDq1T1rGiHOjrw8MGGvxhsHkA+E5J4kI2J6I=;
        b=TxOMxIF0PEEWJj+EsCci+V4qgUgCsgzdsemm03MDI82Kv44vQisTZSD4+TfH0g/Fsq
         SS03oWV/GOSCt54xtQgzEzsXAI4EI8F5QpascEosSdaLelzuYu23K1vxvZ+LFn5tsjsR
         Z7B27AWjVnW4Jmuv3kP0iOTcrfMJI4qmabvqStGjSSk520WpakCF3TAu84wXfn2MBK+Z
         7D9+Su/zRUtDVx3oeDRwSQKwCVy2g/9TWeyg6bgiicmitQBMpunRjoknQ1LV43SzlMgh
         e0Pb/C8jmh4Ep/j1bJwp4i13MbuWZ/iToTgePyFHNxj2PSV0SIq6owTMtbXyXvN9BVxC
         DrKQ==
X-Gm-Message-State: AOAM530KnAvVFisnmTMJBJZb8uHl+or+21l1AFBuRepgoOWBwTvj6JYq
        Dr6mspNqUzlTiIemXjtVVRk=
X-Google-Smtp-Source: ABdhPJz5a+woH/tNbQonUArsmCUrc4O3HCCqC//E19rOgAaMWwcj4OMVErhpBOzbm0PjqXwEqLskbQ==
X-Received: by 2002:a0c:ed23:: with SMTP id u3mr768109qvq.74.1644581546720;
        Fri, 11 Feb 2022 04:12:26 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id w10sm13389270qtj.73.2022.02.11.04.12.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Feb 2022 04:12:26 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v9 0/1] ceph: add getvxattr support
Date:   Fri, 11 Feb 2022 12:12:16 +0000
Message-Id: <20220211121217.166680-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

changes to v9:
* dropped mds session vetting

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 25 ++++++++++++++++++
 fs/ceph/mds_client.h         |  6 +++++
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              |  9 +++++--
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 92 insertions(+), 2 deletions(-)

-- 
2.31.1

