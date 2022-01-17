Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D67794900A1
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 04:49:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236924AbiAQDsg (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Jan 2022 22:48:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbiAQDsf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Jan 2022 22:48:35 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9E5C061574
        for <ceph-devel@vger.kernel.org>; Sun, 16 Jan 2022 19:48:35 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id bb9so12542416qtb.5
        for <ceph-devel@vger.kernel.org>; Sun, 16 Jan 2022 19:48:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HO9XX7W/NaISBh8DMETIj+nfjWPCZXqje9q/1RyQt7o=;
        b=CAAOHgKphqXABHTTEpwaXqJjTdpGMRdju7DuzkACBM6mDrjyCus/yY7NLZdX7cUvnl
         9ONqyncFFNllOR++YLayIs8FDfjtdwfSTC540eIj/r5AOAfbe4dWQXRpTD6hHJnyjM7l
         T5XUEim36NqaHb0WGCthx6ICSeZlfHEvwyxniqJTwr2AEMXjddozhgBOahLAVrJ/vbJq
         bbKGMDZMoPyK3Mj/hs+SDa5lUYyM0411i6ki9IGYiNlHDsPHzLRBDr2qF1FvJHqQ4/Et
         JaqKGc8DUNANgz7hrr52LQtDmQEPal7bysBjAb/WRsH9xLs2sJCNP64uIzIJFzOsT91x
         vhLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HO9XX7W/NaISBh8DMETIj+nfjWPCZXqje9q/1RyQt7o=;
        b=LvLhxHnndRA462sRSleZIkBE5tlOKl/OLJ1Dmdlrw7uoZJ65kotH+BHRfNCUzoSMEq
         7SIQDLctOlDLx4pIaT0WcQ4X1c8YDmLyBFDh1gMyeA0fI4am7QMhSJmGjQ60ssZlnq59
         tejQHkWzqMVxq+hQkBEeB00PSTrPTh5jzHY95O/kmfBairAZlQzRRNr54BQsqouXnN9K
         eVKj2prbePafX54n7hKvr90ww9IpdTmK6WyPzHoMYmyEXU4pgVqtw7+pLO263Q1lzabT
         cjnQED6uhLyjrPPkqLmDBVFv5ZeYIS4nTtIlWfJTSRXug7/iAokzjDXwuz7DEvf+pS3k
         P7ng==
X-Gm-Message-State: AOAM530LBDR6yKQ5FZoAFqhbt/A1JIzrSYu5xUfuSv7j4KmtYK3KuYcI
        HzGFvnYA1VPDjR8AidSuUMg=
X-Google-Smtp-Source: ABdhPJx4OND6tjCBr1eqmuufaj6VM6kFJ57BjXdOa0cAIRJ4cPHJ2uRXcc42xL3gnX9i4M3BvBpXTw==
X-Received: by 2002:ac8:5dc6:: with SMTP id e6mr12628026qtx.343.1642391314467;
        Sun, 16 Jan 2022 19:48:34 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id y65sm4226530qkb.134.2022.01.16.19.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 19:48:33 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v2 0/1] ceph: add getvxattr op support
Date:   Mon, 17 Jan 2022 03:47:46 +0000
Message-Id: <20220117034747.22229-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adds support for the new getvxattr op to fetch ceph virtual xattrs.

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 33 +++++++++++++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 124 insertions(+), 2 deletions(-)

-- 
2.31.1

