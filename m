Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD3026624F
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Sep 2020 17:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgIKPj5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Sep 2020 11:39:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726472AbgIKPhk (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Sep 2020 11:37:40 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDAA4C06134A;
        Fri, 11 Sep 2020 07:20:45 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id a9so4993195wmm.2;
        Fri, 11 Sep 2020 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gN13gPqvYkWcNzH2Uwv+GmnslbiGIqRbQHhRY0tX3Lo=;
        b=m3GXCdrVi+A6Fz+n7OUH+hws2XtD5fHIAPJeKXlO4F77lEkHSht43l4dcrMNCXq2y6
         yhQqmUK2IgpzvqLfMm4QA0D6OHYFRsWiZj8zGLz+Dt+uHsgB1R3GXrj6pz0uBS4n7ohS
         NiK80Agerxnjtj+qRP27Q7U2F/YKGIhYYnzL2Gxz7G2jqVl2ak4ccdgaFozOL9htBcNX
         V2ORH+72hTqbHlIVtVfGlmRBmnEXJjBkZ2sG/SVp6WCXMzWZN9Nl0VHoi2Wccbk+pr5b
         mDIHn6D0eEmi9zQkZIVWSM43zKz9xNDIlCf2Vzu+WsiBhpfV/O4INp+GPPlU50yT6U4U
         vsUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gN13gPqvYkWcNzH2Uwv+GmnslbiGIqRbQHhRY0tX3Lo=;
        b=XVSP4W4AZpxU+iPwSFdeWFKwG9QxAOil/TQ4aBY5xY0yJiU7yhvRmbUoPBKSgU63Hi
         mW/MjQzyQHTD6D3vTj+3Ynaym0zKCPn4SVZB5Ob1qGA222+WUqZPAcC+0/Nvi0r764KV
         3iJTJn4xcaFC8g20SqV3R8dw+Ok9pf6vN5+RAAXxEej4Qe5iTGpUO6pbgUuROyKy9PSN
         Bteg6d2V+jy0D7PZuKwDG+CXPIa2ljhS0UtbLhQJjtWEMZZCu0Nsr58T0AWFox3/i3YB
         e8xPmB1+X/YkIO00Gz0Yxjq7uNySgDLewgul9yNO7bU0kQBl6RSJUQ9JdPkKhT8pB+eu
         Imqw==
X-Gm-Message-State: AOAM530L688X7KsfOfJ5YwksQWLEGIlnxNr2vBAmNRfuGEYWof5Pcu6g
        ELdzQaKw6huPXpBvuwFjpumLa/q9vzKt/A==
X-Google-Smtp-Source: ABdhPJwkUDGFAhdLzwJB79JsXkFg2IwuehHSLw8AyxjzVNXgs82dxgHeD3gQv3LMBFSZhC1hSwliOA==
X-Received: by 2002:a1c:67d4:: with SMTP id b203mr2428028wmc.120.1599834043505;
        Fri, 11 Sep 2020 07:20:43 -0700 (PDT)
Received: from kwango.redhat.com (ip-94-112-132-16.net.upcbroadband.cz. [94.112.132.16])
        by smtp.gmail.com with ESMTPSA id d3sm5003712wrr.84.2020.09.11.07.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2020 07:20:42 -0700 (PDT)
From:   Ilya Dryomov <idryomov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] Ceph fix for 5.9-rc5
Date:   Fri, 11 Sep 2020 16:20:37 +0200
Message-Id: <20200911142037.23366-1-idryomov@gmail.com>
X-Mailer: git-send-email 2.19.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi Linus,

The following changes since commit f4d51dffc6c01a9e94650d95ce0104964f8ae822:

  Linux 5.9-rc4 (2020-09-06 17:11:40 -0700)

are available in the Git repository at:

  https://github.com/ceph/ceph-client.git tags/ceph-for-5.9-rc5

for you to fetch changes up to f44d04e696feaf13d192d942c4f14ad2e117065a:

  rbd: require global CAP_SYS_ADMIN for mapping and unmapping (2020-09-07 13:14:30 +0200)

----------------------------------------------------------------
A fix to add missing capability checks in rbd, marked for stable.

----------------------------------------------------------------
Ilya Dryomov (1):
      rbd: require global CAP_SYS_ADMIN for mapping and unmapping

 drivers/block/rbd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)
