Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 357CB417156
	for <lists+ceph-devel@lfdr.de>; Fri, 24 Sep 2021 13:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245013AbhIXLyG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 24 Sep 2021 07:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230238AbhIXLyF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 24 Sep 2021 07:54:05 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B56F3C061574;
        Fri, 24 Sep 2021 04:52:32 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dm26so812093edb.12;
        Fri, 24 Sep 2021 04:52:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSNvjCExtWWaouZU29wSOE723s18INbZL7SOu8rGcPA=;
        b=G4VHn+qeg5Q2Ksa6mwxhckNnnJHftHQqNLdTSYmivMC7/b+amqHJHRkur02SNoz+dv
         Dq52p2Ontc1JW47AnhavE/DzbYTUL0ez6PkrOr8CuKrX9A0/iUTlL1a8ZmMqv9qrQWXJ
         bSh9oksdh1h7TFa6jFkrQUJk62WrRtrOKQU59L9eLnffRVGi7X607Pz8dVXPfbL9p3o4
         5kuXb93pOIvUijluVZc0sJ6BKwgmrOnwI7yAFWSsnzSs3XgphoqMyHl6Ydr+kCVzgGua
         Xvox0C5Gzn2qWjrrtjp6Pa1n9Ux5X/Mppb9Tf0UPqaGlQRzd+phOXqlLhHFVn+E+yykq
         9vVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DSNvjCExtWWaouZU29wSOE723s18INbZL7SOu8rGcPA=;
        b=jmo/NHtbM76Zp8WUS9CwH9D1zRlLGekbayN9Bis2S17taaGWhNZWxMPonAJQxJqFGz
         HAYaOLK1nxwPhU9N8BP+WP5wV30rtz6n233Cka01C41AbDHVAIuRHwKshuOD/BPJNOzL
         +quq9cKYetwblYGWGs3SZhmWse2uC9sCep0jlqFvT4zhZwtN9ZQerllamwj/Ih0qM3m/
         VuigskhBRLJ3zOLwhzkBGiqnltRtVx/sacnYHfzmex90HIk94k5f5xRNaARdIw4SRmUQ
         UIPyUeXmGomZmtJDkwZCaD1Ecyp9pDBjduFDXNtsRZMTJVVQYbmFs73Er0ryao4mAAGl
         ZSsw==
X-Gm-Message-State: AOAM533xyUQm7yJXpcGif0NZUyaynCfbowNoXaHpWJx+E8S1WZL8z8ze
        0KjMh/NCnuFrkyCkhScHnms=
X-Google-Smtp-Source: ABdhPJwlPdhFM3Jre8Xju039LHGThYUr+wgR9NN7IRv75XCaaB2ztLNdEMfB9C6z4njth+MY8gyfRA==
X-Received: by 2002:a50:9d04:: with SMTP id v4mr4341100ede.399.1632484351360;
        Fri, 24 Sep 2021 04:52:31 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-171-183.net.upcbroadband.cz. [94.112.171.183])
        by smtp.gmail.com with ESMTPSA id s3sm5086264ejm.49.2021.09.24.04.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 04:52:30 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 5.15-rc3
Date:   Fri, 24 Sep 2021 13:52:01 +0200
Message-Id: <20210924115201.1182-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit e4e737bb5c170df6135a127739a9e6148ee3da82:

  Linux 5.15-rc2 (2021-09-19 17:28:22 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.15-rc3

for you to fetch changes up to 708c87168b6121abc74b2a57d0c498baaf70cbea:

  ceph: fix off by one bugs in unsafe_request_wait() (2021-09-21 17:39:20 +0200)

----------------------------------------------------------------
A fix for a potential array out of bounds access from Dan.

----------------------------------------------------------------
Dan Carpenter (1):
      ceph: fix off by one bugs in unsafe_request_wait()

 fs/ceph/caps.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)
