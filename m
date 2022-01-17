Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4E2C4900A7
	for <lists+ceph-devel@lfdr.de>; Mon, 17 Jan 2022 05:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbiAQEAA (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 16 Jan 2022 23:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234214AbiAQEAA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 16 Jan 2022 23:00:00 -0500
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D85E5C061574
        for <ceph-devel@vger.kernel.org>; Sun, 16 Jan 2022 19:59:59 -0800 (PST)
Received: by mail-qv1-xf32.google.com with SMTP id k9so1773216qvv.9
        for <ceph-devel@vger.kernel.org>; Sun, 16 Jan 2022 19:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gNZI0ySEf5eUqxpCv6158sHomHq/Sd1bCqTVuJvZx4=;
        b=OCsINVDhGfOg2l9dES3Tt6mgoDylzsT0RLppAWevozO9zfussT8JQ22BJQAxcZPWtn
         rssB1cRbmTXPzo/gHa7Pt1ha/xPuBkstCvBD5XqYW89/Zi6X4laBTU4llLBktfnGegYX
         Po4Hj3ICxjln4m7bCat0p0aAin9Sj2TyXcPnOJq/3xTkXWd/S2djJw7Gx/3jzq0bAQ43
         0WeYeAAaDyoY6XOeookpcDcio1uNrvYhg2XgBb5b8OguBmE0BRIG4e29bt8ZWlF5pEMx
         BwANu+wBciz0ATIBJs5sXNFMkUY9JgGRx7xu3UJUXZYTkw9TDKhYTF1JqTTVo52/G0ON
         ROxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6gNZI0ySEf5eUqxpCv6158sHomHq/Sd1bCqTVuJvZx4=;
        b=KAhdS4aYL4reMi7P/juqkgI2ZKYf+uqnuimLSsubuvwAoJTC7uk9Fwh5vHWmxtd1pB
         +8tKrTgF6CZ4FLnw4jxe38naBQpSx5iI1hJGbAe6TNX3Tb8EhEN32wF1L8ZOGo+JE/aS
         /GtQ5Z3Lk6QDCPKPrPX1OxWVimQbHNSGCmURDJgK8RZxCVBFDWAqhcPYeF7aPTtlPL6M
         J4iHqVhIV7n/+1sSvi3a5lPRZVayN5XqRaCDOMRrT3VtB3jmw22CYIMkx6HP5r6wHgfg
         xIHtA6/hgkkM8f5YHLpCkNOxA8oiq9RzKYsde7eYJJl0pbbiWJ6G6XNK4LQBHKm+YHF5
         1V/g==
X-Gm-Message-State: AOAM531XmYZptk3oCHo2KVI7I1z5haE6e2jteaXUn4fK58xcQTdMQLy0
        3andlPKf2w7tIfQR06ImBt0bmoQHvPbNwIQD
X-Google-Smtp-Source: ABdhPJzWwcotrIGFYGGTGM8Gt33ioSZim2QieJJCj5TbnC544fv6zHzpvvAg7KwL9vxr7uJfMAlUNg==
X-Received: by 2002:a05:6214:762:: with SMTP id f2mr5581381qvz.0.1642391998937;
        Sun, 16 Jan 2022 19:59:58 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id j5sm7729570qki.9.2022.01.16.19.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 19:59:58 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v3 0/1] ceph: add support for getvxattr op
Date:   Mon, 17 Jan 2022 03:59:45 +0000
Message-Id: <20220117035946.22442-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Adds support for getting ceph virtual xattrs using the new getvxattr op.

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

