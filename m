Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39A11E828E
	for <lists+ceph-devel@lfdr.de>; Fri, 29 May 2020 17:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgE2Pw4 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 29 May 2020 11:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726838AbgE2Pw4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 29 May 2020 11:52:56 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0058CC03E969;
        Fri, 29 May 2020 08:52:55 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id l1so1253854ede.11;
        Fri, 29 May 2020 08:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fMGxgw+sEmNPr6Q4iwWqHNaQyBQy24CypPRwCfCtM1Y=;
        b=LV0PIhe4CyEEkkar0BTsUfQE5vRxgqzdjttHubbMvijQycBeRPvnWBMsH4/cjXdP4M
         WCaN3ufs2q35n7FD2t2B2TDAk2QEeO1nMoadE/jljA7QgS4/lTxL4noH9Jg8A1/WocWi
         RBJjtvLdIQeIH2J5zwDhfuHI6I5l+8k9mwsqZe45Rit4x14PtxVAWhba70eGvKBz3SEW
         yuj3DP7buQ3YyRIhAdbFUB4BU2ETyGjkdNobZSVNqinsX5FAqSEMuCf9nyp6xnX26OCJ
         Ht+yAoZ1SYmaTLd8e2GWz/Ka7tTnGPkfEG4HHn+K85gnP9XQlPl+uOIZtukMz5yzQLeM
         TwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fMGxgw+sEmNPr6Q4iwWqHNaQyBQy24CypPRwCfCtM1Y=;
        b=Np1jjVQhd4N+IiceCGUesrhPjCK+iTE3gO1wyAcZbO81M1LSTjvcxBGCM4q+oGxTxg
         GmD5zmtC1gMXA24Axq/04L2gOONckPf/QCSDlo8mGIzlatT8G+Le/IwK7IHe25BWS40O
         V0fEOuai0Em6NO4T8AYZbZzVrmQjYefWznbuhpES4ItkdjU7Qtbjb/Rh2RpwHerlpRdL
         wT5Wgg8gf00FN9KPm3b6PB9f50X6ydjL89ZCXXzeo/2vz3mTu8b1EMH1ClLo/C7JRjIZ
         Rtw8TIc34lQSsBdW7d1D6niNuZoRq2G3orPzQFm+DWrvJEFtO8LOBUhfycoF+Enr+rBF
         rjWw==
X-Gm-Message-State: AOAM532gIyaOlqzJRPEK2LNSuOojNrda6Dh0XuCu6d3vZqhpB2jxGx+D
        2SfNQ0EUV9CtrNKW/EZMIceMMPfvgjY=
X-Google-Smtp-Source: ABdhPJxo6gpWgpRMjfE5xD2jRWWvNxh8NLNeRKHFGZ6Mu+dtuokHAUR7BghAtHizX/bijCaZEIScIA==
X-Received: by 2002:a50:9b0f:: with SMTP id o15mr9218779edi.325.1590767574667;
        Fri, 29 May 2020 08:52:54 -0700 (PDT)
Received: from kwango.local (ip-94-112-129-237.net.upcbroadband.cz. [94.112.129.237])
        by smtp.gmail.com with ESMTPSA id r18sm5953572eds.29.2020.05.29.08.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 May 2020 08:52:54 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fixes for 5.7-rc8
Date:   Fri, 29 May 2020 17:52:57 +0200
Message-Id: <20200529155257.21043-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit 9cb1fd0efd195590b828b9b865421ad345a4a145:

  Linux 5.7-rc7 (2020-05-24 15:32:54 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.7-rc8

for you to fetch changes up to fb33c114d3ed5bdac230716f5b0a93b56b92a90d:

  ceph: flush release queue when handling caps for unknown inode (2020-05-27 13:03:57 +0200)

----------------------------------------------------------------
Cache tiering and cap handling fixups, both marked for stable.

----------------------------------------------------------------
Jeff Layton (1):
      ceph: flush release queue when handling caps for unknown inode

Jerry Lee (1):
      libceph: ignore pool overlay and cache logic on redirects

 fs/ceph/caps.c        | 2 +-
 net/ceph/osd_client.c | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)
