Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93B924B03E5
	for <lists+ceph-devel@lfdr.de>; Thu, 10 Feb 2022 04:25:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232434AbiBJDWU (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Feb 2022 22:22:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiBJDWS (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Feb 2022 22:22:18 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF03A1EAFA
        for <ceph-devel@vger.kernel.org>; Wed,  9 Feb 2022 19:22:20 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id g4so3220051qto.1
        for <ceph-devel@vger.kernel.org>; Wed, 09 Feb 2022 19:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkVuoRECOJ8acOzo7fTP5X3tAdER6ONx7V3J6tf+Dmg=;
        b=oIO2y+34c47h996WkAFdc7/xBl2oWTYAvfpNnZ0P4NdkdYiD1QMLWy3qL27pI32Dp6
         naa5dEPy9cbUIcuuVzDEoyooSx6D9fQpeE2wm7Yt/MpeeaXXtb3skk16s2o4u9rBZnlI
         t61yhVftMqJoMyYHM83gGHz6WOQYzJUJU/Q1PDV98BwCDjMhV4dZTR/NOizxdRCCMic9
         rl+FZX5zFwgVJkEUpHxYwTKUKjOKl2ohDuo/w+QODyRikaXA9h5Y9kx0q9cRJz3SOa5J
         pq+X5xukOP2qUe9ckpjadw+SjHyE3FBTlUMpI39ijy6P3HepY+lPhzd28d3k7HRk7X35
         cMKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nkVuoRECOJ8acOzo7fTP5X3tAdER6ONx7V3J6tf+Dmg=;
        b=UzoCySOOfL6N++dXSKu02WT3pRZgeZgc/XlWS8vjilmcPmQ40n+wN6m6aVsmULDq4W
         i56PBB6+5nmPvvy9CBQZb9TZlv7vpA5/m27c0Sd9rmt5F/CXa1NTENr4bAOfdj8zIDpG
         s6VdXaR/ZrS6N0IDoC3s7RC/6DwHUJwTfSCCHVCgXqF+k0a+j7dfRt+NExY1/XIEsDbZ
         PtGk5zlouNoHe15vKAUhQFx26czGg/WVwnSCt4GV3WCS76v+o24t3z+sUM6FgSQ1iXAQ
         HSRshl761hWSXvd4NxHWaK/UMzVRmVgfZ2QM04WNBM14NBWqG/etKybIHwy+v434QrX+
         3VIA==
X-Gm-Message-State: AOAM5310b6gL2zcigNaQM/gqaL4ecm/96BMwClp2vF9aaA1Th0eiCDvN
        19svFpb4SJOChb3pdsEXRE4=
X-Google-Smtp-Source: ABdhPJzXiKMGEtGNcdz9PD6lSByHnknzlh8LcDRmFvKM57n2Ajdj6vgTSTPClSOEV9+g9u5MPafn6w==
X-Received: by 2002:ac8:5f8a:: with SMTP id j10mr3539761qta.120.1644463339998;
        Wed, 09 Feb 2022 19:22:19 -0800 (PST)
Received: from vossi01.front.sepia.ceph.com ([8.43.84.3])
        by smtp.gmail.com with ESMTPSA id l12sm10077117qtk.25.2022.02.09.19.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 19:22:19 -0800 (PST)
From:   Milind Changire <milindchangire@gmail.com>
X-Google-Original-From: Milind Changire <mchangir@redhat.com>
To:     Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>, ceph-devel@vger.kernel.org
Cc:     Milind Changire <mchangir@redhat.com>
Subject: [PATCH v7 0/1] mds: add getvxattr support
Date:   Thu, 10 Feb 2022 03:21:55 +0000
Message-Id: <20220210032156.156924-1-mchangir@redhat.com>
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

changes in v7:
* added callback to vet mds session for getvxattr

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

