Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDF4D4B0A90
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 11:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239622AbiBJK3u (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 10 Feb 2022 05:29:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239593AbiBJK3t (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 10 Feb 2022 05:29:49 -0500
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CB5A314
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 02:29:50 -0800 (PST)
Received: by mail-qk1-x72e.google.com with SMTP id b22so4293223qkk.12
        for <ceph-devel@vger.kernel.org>; Thu, 10 Feb 2022 02:29:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hcl/hqegEgoXsmmS7hX92K0QzhTFCknL/Vm7ejeIZ/c=;
        b=Ch0uuoEi+afb0wuLG1iMztObnj9xxBI6vqtynrKJlFnXuFgel7BfdGx2GYeTu5fCAR
         5cpVZSIxiu+NoYWdMO+/W/Zl0ui5dO6s8rBM+moaiymKISTVBPeoA+aRCtIhFwwvwwQu
         dB8njCnCTAILeLAcixV//6Fp+R8mEksFKOmkcKFUOQC1drPfs8uUORon21DzCSaeQfgF
         8uasWcU7W3oBxmvOMTPxRMDNHV7BeX/UwaikbKIvKBetjFzxHjIqZe1pWjBjZfNQ9iK/
         loBSMgUjhpUoQ1FGfDcL/MS4eXTKkguZNOqgk7NE7OvtagpiwN1zVfVZ3qI5XES9H8Su
         kE9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=hcl/hqegEgoXsmmS7hX92K0QzhTFCknL/Vm7ejeIZ/c=;
        b=vD0UCY25kWFwbj7Rjz1Ig+oo9S/R5Z1wY+SXGE3zkY/O3SmbIspbxah/7UyGe3xmR0
         naR2c7LRfqFALXbRpMvsv08poVmjlsb31ZAx8oep6arQV98nM1T5Hz42mYZC8+CLzO5Y
         R5BmI365/6ahneQ9rNL45b8V6U8aK9nCV+sCthuSAN0gvVjRruBFI+E0VF7SlqFTINWR
         +6hmrx0JloaC390qaUafhuzHRUQ57zw0fzh5QGLMcldJS7/xZyF59BGXAH422BXQHj1t
         gG9gnAmNhW6hr+FSQqF8sZxfWZEYmbFnTOPO4V2qF/wwgNAaFUYVkAW51Ua6q1lOrbUU
         jo9g==
X-Gm-Message-State: AOAM532RLiP6kMgKQxo0Omnhgz4JUxyLsYwXx0ly00xQgilt+lJY7/G+
        n9fEahOc6u8VYz9993iUqOc=
X-Google-Smtp-Source: ABdhPJxoZ+Pqw/z92V5adxFa5+bqmKX0ZZNk6WAGJGCo1b0ZNL/Hq/sDZ16rAfocSJ06D93ebYI/Eg==
X-Received: by 2002:a05:620a:46a9:: with SMTP id bq41mr3350174qkb.245.1644488989758;
        Thu, 10 Feb 2022 02:29:49 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id m22sm9963693qkn.35.2022.02.10.02.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 02:29:49 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v8 0/1] mds: add getvxattr op support
Date:   Thu, 10 Feb 2022 10:29:38 +0000
Message-Id: <20220210102939.159059-1-mchangir@redhat.com>
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

changes in v8:
* auth cap pointer is verfied before using
* mds session vetting infra is now tied into the workflow

Milind Changire (1):
  ceph: add getvxattr op

 fs/ceph/inode.c              | 104 +++++++++++++++++++++++++++++++++++
 fs/ceph/mds_client.c         |  32 +++++++++++
 fs/ceph/mds_client.h         |  24 +++++++-
 fs/ceph/strings.c            |   1 +
 fs/ceph/super.h              |   1 +
 fs/ceph/xattr.c              |  15 ++++-
 include/linux/ceph/ceph_fs.h |   1 +
 7 files changed, 175 insertions(+), 3 deletions(-)

-- 
2.31.1

