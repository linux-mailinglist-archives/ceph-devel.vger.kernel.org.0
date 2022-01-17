Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B2B490464
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 09:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbiAQIwT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 17 Jan 2022 03:52:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbiAQIwS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 17 Jan 2022 03:52:18 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73759C061574
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 00:52:18 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id v7so18545139qtw.13
        for <ceph-devel@vger.kernel.org>; Mon, 17 Jan 2022 00:52:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXqr0dyOBiUuqEgvE8MXmQHk3q+nPEvgXJSVqsvFZv8=;
        b=lwBCy6KWOef0pHHd3En5ZCCyLOcYbzfwVbTLZKn1QMYmcFp5jRkHq86GzrV0KGLHnv
         mnICu1dmi0SueP2WgAyAGbCyufHLl26sBA2BPB0pR0ZHDZMmvp21h+d+zBHKxpYjj9mX
         Yo5iExXB3LhNR791JHIV4CxWAg3PAY2LVnIdbd3QjCVHhEr5ROoNTjvwgiO4eSGZH9SH
         yF/UKS6OIHlaNvvW24IyEdEvZgVDMObdexMABAIAGwpY4wHDvhWtyzlGI8q0b15EiPBA
         tchMR3LJW7ZaepdaPRf3+kOZgUfAOg3/XawkBoAbxkj7g2DcOsyXCKn/4F5RI2OKVbvC
         B2hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gXqr0dyOBiUuqEgvE8MXmQHk3q+nPEvgXJSVqsvFZv8=;
        b=nYRO6ZpnYtl0HNpYKsX41n5Uta09cFeVfWwyXHvLQ2+GZeeym6TaJ/kzooRrid3gBM
         fDJ46zmm41HuNsFvipVx3wFGDpLZ6yBd8LDjJX0+UIuGEBH0rdWYZplJChbJFfMboFXQ
         f6+8erMU0ohVjR7ZRkRxPA8Qjtt/1IAhBcSo9XoWxNdmfac7wp/ycZk6zD/E0PhXNm/o
         NFitw5YvyfrJTUO/BwwEh61srTjw4migR1a8bLKNjxMeeVhHGDrHLN2Nf8EoFs6J/fUZ
         XppnLRE5/2QyAQFfrTEn6doVlWSoGSTYgGKpebmllYziGfcAej92wjhxLaMhO+6ArFll
         wchQ==
X-Gm-Message-State: AOAM531Ny/kL+XeDzhpKn46Oe8sBoZ0+Bvavs2upW709/8c07vH6v5q1
        dNxl4WO++r+6Ex9ur4CduHw=
X-Google-Smtp-Source: ABdhPJzUy4Co9kMYWoq1hMApStVW5imv7L68bpqfQIcSG35SFg+TCxW2P4ne94gaTTtPYJ4HwpBdDQ==
X-Received: by 2002:a05:622a:1703:: with SMTP id h3mr8560743qtk.510.1642409537429;
        Mon, 17 Jan 2022 00:52:17 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id p67sm7960187qkf.49.2022.01.17.00.52.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 00:52:15 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v4 0/1] ceph: add support for getvxattr op
Date:   Mon, 17 Jan 2022 08:51:41 +0000
Message-Id: <20220117085142.23638-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adds support for getting ceph virtual xattrs using the new getvxattr op.

fixed in v4:
* fixed dout format specifier for size_t types to %zu in place of %lu

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 34 ++++++++++++++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 125 insertions(+), 2 deletions(-)


base-commit: fd84bfdddd169c219c3a637889a8b87f70a072c2
-- 
2.31.1

