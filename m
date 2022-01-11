Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0CFF48AD8D
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Jan 2022 13:24:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239849AbiAKMYt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 11 Jan 2022 07:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237953AbiAKMYs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 11 Jan 2022 07:24:48 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB307C06173F
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 04:24:48 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id i8-20020a17090a138800b001b3936fb375so4981684pja.1
        for <ceph-devel@vger.kernel.org>; Tue, 11 Jan 2022 04:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35K3NPsS5wxQA2IJqEZ+DO6YL9U13yHdov6U+4wSihU=;
        b=QB715bk3wiMSNZIlbJvvRafUAIoD10BpuPe7yI3Po0utsAN5aIsDQdw6/Tsv82IF8w
         AB9pxH995ujwIiX8lr3XjoOEisY3GScojsRnjIDhZijTqBTWqf8mgYAOVA56WQoNqbuQ
         QJ/3mXaWi+t9nuZIMo01/23Nr3F/pyhu+pEtNf0WBECP2p2Q1R5HeJ381BHRe5+XdqI/
         BhaMp9zY5LlnjjniLubxgdBKa8hmWThDT1mtCMcftsdW1wFZUzTTjJEOpU9a+s4NyaKr
         uMzTywRsB3PKX5GTpQw4yVBqpgPkCxt4I4k00dwdqbS+5kyiO+hEmbIc4FYrITKXge8E
         ohzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=35K3NPsS5wxQA2IJqEZ+DO6YL9U13yHdov6U+4wSihU=;
        b=XoGdSoXicDEVTHbqwgvgSIDUEBTyD5q0fYhQK9hG1i6SaBGywGcz8wo8zArt6Pm+Zw
         YF0Ecc20KrsYHd94i9iwibske4TO4aekTJn7j+T1ma4BUhiE309PcSyDCp5TyfdxmZ5D
         bkIrYboPC/I1c/lCYkfZ2Fq7RSAPYYf7IF4rEXRrn0T4oC7xqlZGPJmoqSTQzlZyE7Wz
         0vMdnX9OBSn4bxEh79YITCBg1FkDP0t2SgX0gmEFCqEqLWqAzUVM6KPCpMCqgJoujIQW
         5VLZbJ6K/TZklG6zQn6Kp7IMi3JdJUyD31XJjQOsVEPCzlETL75RZyWMXPwQiL0dovn1
         uVDQ==
X-Gm-Message-State: AOAM531qRdjIwsNg7/l84qWKCzvsI6BJsBw0SnWxF0PYGQbNhIzvEP1F
        U8yS2pxuVMlWGfjqb4BSOwI=
X-Google-Smtp-Source: ABdhPJz9F/H5lyqZuyq+4kzQiH8c7MT/clvJ2yWv7vHS9oTrJcGfGTk/5Yp2QNAmK+bATQt+QdzIdA==
X-Received: by 2002:a17:90b:4c05:: with SMTP id na5mr2881042pjb.94.1641903888294;
        Tue, 11 Jan 2022 04:24:48 -0800 (PST)
Received: from indraprastha.. ([49.207.223.193])
        by smtp.gmail.com with ESMTPSA id d8sm6292081pfu.141.2022.01.11.04.24.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 04:24:47 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH 0/1] ceph: add getvxattr support
Date:   Tue, 11 Jan 2022 17:54:30 +0530
Message-Id: <20220111122431.93683-1-mchangir@redhat.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add getvxattr op support to handle fetching xattr values for:
 * ceph.dir.pin*
 * ceph.dir.layout*
 * ceph.file.layout*

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 51 ++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         | 27 ++++++++++++++-
 fs/ceph/mds_client.h         | 12 ++++++-
 fs/ceph/strings.c            |  1 +
 fs/ceph/super.h              |  1 +
 fs/ceph/xattr.c              | 65 ++++++++++++++++++++++++++++++++++++
 include/linux/ceph/ceph_fs.h |  1 +
 7 files changed, 156 insertions(+), 2 deletions(-)

-- 
2.34.1

