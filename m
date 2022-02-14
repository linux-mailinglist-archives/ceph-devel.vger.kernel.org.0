Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB2C54B410B
	for <lists+ceph-devel@lfdr.de>; Mon, 14 Feb 2022 06:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236461AbiBNFBV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 14 Feb 2022 00:01:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbiBNFBU (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 14 Feb 2022 00:01:20 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4069451E4D
        for <ceph-devel@vger.kernel.org>; Sun, 13 Feb 2022 21:01:13 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id r9so3358413qta.1
        for <ceph-devel@vger.kernel.org>; Sun, 13 Feb 2022 21:01:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2lYKeBgdudtc0HFjQNeS9daNlOvFry1GveKYBhMC+ag=;
        b=IRsWoU3BH30imFEvIjFS9i1R4Rbo1hjRTqQneiK+/7E/65RoXsbRDB+whPCqRebtfs
         m2/D+x89lY5QTPZxzwJHWStwO51mdZV9eQA7AV9mhRZ1h87ZcXwoPwXCn5tPbfqCrxqD
         dQVzB359/uHW/+zEuqALns1e+gyhZtjd1cXd5J+r8AOsYi/AR3sqqf+oRhAFE+dxH0X2
         0pj5Bq3HFKocY8As+DUeWqxfVSbj3YvVNJNXiGUrzGhmQb9a6xwSzBxc4frJF3iYmSI9
         7wwdthdYwiTacxM4BoY8F7/jdOTpJlYA9wpyG/Y/m1LbrTDLQtqyv3EvvOFjv5x66j/3
         idPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2lYKeBgdudtc0HFjQNeS9daNlOvFry1GveKYBhMC+ag=;
        b=N/9NTKOo4WpyFoSkkyXhMALXRpk61SNGC6Tu1HBD8thaXQh4Y0TOt4taDU4N/R4pVp
         XescNpxJLVYNZScVfkykCaV5dMDfm5WizUlFefNrvskvmZlcGo3BCTE/Hm6ux2seksyi
         zsIv/5xwR58IuKBEQxT3K5qAYzJrEtzVdHOhVhU4qnxbzwpg4yXqam6QqaPR+tKvrZni
         BRPOhNA7Rpu2jjK/yHU73gYU1AytLx7DEod6XTlvpS1GF9WagsXxAFddIGqUab1UDAcK
         U07+mAjqcGtqBnoAuaOL2mguFMwYZjplAz8wF1VsKlkzuNTuB+MyHJ/hS9UC1iMXvdR0
         Q2jg==
X-Gm-Message-State: AOAM532s4PJRlGlUGvB9uOHEDDPOQxd87ymeFb8V02GZYxz+QALAtSTQ
        YmI3RBqttcU3of1puc3qH5agVna7vKHxO3oH
X-Google-Smtp-Source: ABdhPJzuLYNmVmElLjv7lCLVcmtNzpWppzU0hJFHctzB10FB0jT3XjvnK+BzZH+2skKXasubBuaeIg==
X-Received: by 2002:ac8:7771:: with SMTP id h17mr8375429qtu.454.1644814872365;
        Sun, 13 Feb 2022 21:01:12 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id br35sm15229586qkb.118.2022.02.13.21.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Feb 2022 21:01:11 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v10 0/1] ceph: add getvxattr op
Date:   Mon, 14 Feb 2022 05:01:00 +0000
Message-Id: <20220214050101.178045-1-mchangir@redhat.com>
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

changes to v10:
* commit message updated
* comments added to response decoding for skipped fields
* -ENODATA is now returned by client if server responds with -EOPNOTSUPP

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 24 +++++++++++++++++
 fs/ceph/mds_client.h         |  6 +++++
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 13 +++++++--
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 95 insertions(+), 2 deletions(-)

-- 
2.31.1

