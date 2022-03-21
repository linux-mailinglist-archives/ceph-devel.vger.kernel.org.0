Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACA74E2FF0
	for <lists+ceph-devel@lfdr.de>; Mon, 21 Mar 2022 19:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245052AbiCUS2Z (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 21 Mar 2022 14:28:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350635AbiCUS1s (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 21 Mar 2022 14:27:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355B860CC8
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 11:26:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DD547B81997
        for <ceph-devel@vger.kernel.org>; Mon, 21 Mar 2022 18:26:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49374C340F4;
        Mon, 21 Mar 2022 18:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647887180;
        bh=5SZHnj1FwN4kCn+999YC/KMUISpb0O32xW1z9mMFTKg=;
        h=From:To:Cc:Subject:Date:From;
        b=kFDa5NNC4be0TqbbeZXnOCbC21p99I4qcbO1pCVP9lwirtxd4zVGKS4qMGLFe3Iyl
         sI2ZIcoe7cwZxrMjZTwuPZEpEJ1wSwLkr3pMtHZRNVA+8V0bxhp1OEa+FuVxJ0ldmF
         d0E9FZ9RcAXRqQRTeq2TDQ+skyW96TtJHs80AJK4DON8gS5WI6Err098xbZk5B2vzk
         qQMcc6vCoqbanm4SCxN28b76e5D/nnMZ7MEfEtHRHHKtybpjzMu1kdnE8FhXqmj+pE
         vQ9TQuJGMk6hsy9lOMF7tqyPKuwUE912Gczke2tDf4See59skesz7q/Yh66mafKlKr
         YB1C837usoPDA==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org
Subject: [PATCH v4 0/5] ceph/libceph: add support for sparse reads to msgr2 crc codepath
Date:   Mon, 21 Mar 2022 14:26:13 -0400
Message-Id: <20220321182618.134202-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This is a revised version of the sparse read code I posted a week or so
ago. Sparse read support is required for fscrypt integration work, but
may be useful on its own.

The main differences from the v3 set are a couple of small bugfixes, and
the addition of a new "sparseread" mount option to force the cephfs
client to use sparse reads. I also renamed the sparse_ext_len field to
be sparse_ext_cnt (as suggested by Xiubo).

Ilya, at this point I'm mostly looking for feedback from you. Does this
approach seem sound? If so, I'll plan to work on implementing the v2-secure
and v1 codepaths next.

These patches are currently available in the 'ceph-sparse-read-v4' tag
in my kernel tree here:

    https://git.kernel.org/pub/scm/linux/kernel/git/jlayton/linux.git/

Jeff Layton (5):
  libceph: add spinlock around osd->o_requests
  libceph: define struct ceph_sparse_extent and add some helpers
  libceph: add sparse read support to msgr2 crc state machine
  libceph: add sparse read support to OSD client
  ceph: add new mount option to enable sparse reads

 fs/ceph/addr.c                  |  18 ++-
 fs/ceph/file.c                  |  51 ++++++-
 fs/ceph/super.c                 |  16 +-
 fs/ceph/super.h                 |   8 +
 include/linux/ceph/messenger.h  |  29 ++++
 include/linux/ceph/osd_client.h |  71 ++++++++-
 net/ceph/messenger.c            |   1 +
 net/ceph/messenger_v2.c         | 170 +++++++++++++++++++--
 net/ceph/osd_client.c           | 255 +++++++++++++++++++++++++++++++-
 9 files changed, 593 insertions(+), 26 deletions(-)

-- 
2.35.1

