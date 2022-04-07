Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91C864F7E88
	for <lists+ceph-devel@lfdr.de>; Thu,  7 Apr 2022 14:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbiDGMEb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 7 Apr 2022 08:04:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231553AbiDGME3 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 7 Apr 2022 08:04:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 226FB4BFE9
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 05:02:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 839ADCE2761
        for <ceph-devel@vger.kernel.org>; Thu,  7 Apr 2022 12:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461E7C385A4;
        Thu,  7 Apr 2022 12:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649332946;
        bh=Ebx+PXPb3c0pIOS7fmBRjdM8ZY7fYixJGu6VUcv6NmE=;
        h=From:To:Cc:Subject:Date:From;
        b=qnLH7SFuBDAJ9q0iurGs5AJJrUoOPm+Y+wuoK2dzlZZZdyRXavT/p0j1E1p0Tk8Sk
         FAVEvygeTlXLYOCmrMSrjspobIddzGPJR3l7vnLCdi93hmPKNY+vO9wbLQLAOItoAr
         L4nuPs86LCw1PMvF0vgOwmfRMQNjl9fLn0WiZEl4392tPuMjRibaL4FjfE84VHq3Xx
         qvfTIVP20hHPMsbaE9Nj62BTgIvU4QHNIYLvxTPorfOZU3k/U9XhLTxg+NgP36T/1x
         W0CTsa0R+opwOJP+9BY65gr/aEUMD3aN0dzSRJ2svw0RwGgBZ8IcDo6gIR4fo76Q86
         xJ+OyGb183olg==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, dhowells@redhat.com
Cc:     idryomov@gmail.com, xiubli@redhat.com, linux-cachefs@redhat.com
Subject: [RFC PATCH 0/5] ceph: convert to netfs_direct_read_iter
Date:   Thu,  7 Apr 2022 08:02:19 -0400
Message-Id: <20220407120224.76156-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patch is based on top of David Howells' netfs-lib branch [1]. That
tree adds new O_DIRECT read helpers to netfs.ko. This patchset converts
ceph to use it. With this, all of the usual xfstests pass for me on
ceph.

We should be able to rip out a large part of ceph_direct_read_write with
this set. I haven't done that here, and will probably wait until we have
converted ceph to use netfs DIO write helpers (which don't exist yet).
Once that's in place, we can just remove that function and related
infrastructure wholesale.

I'd like to get this into our testing branch for an eventual merge into
v5.19. We need it in our testing branch for a bit though.

David, in the past, I think we just based our master branch on top of
whatever branch you were feeding to -next. Around -rc3, could you
rebase netfs-lib on top of that and use that as a base for what you're
feeding into -next? Then we can just base our -next feeder branch onto
yours.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/log/?h=netfs-lib

David Howells (1):
  ceph: Use the provided iterator in ceph_netfs_issue_op()

Jeff Layton (4):
  netfs: don't error out on short DIO reads
  ceph: set rsize in netfs_i_context from mount options
  ceph: enhance dout messages in issue_read codepaths
  ceph: switch to netfs_direct_read_iter

 fs/ceph/addr.c  | 55 ++++++++++++++++++++++++++++++++-----------------
 fs/ceph/file.c  |  3 +--
 fs/ceph/inode.c |  3 ++-
 fs/netfs/io.c   |  5 -----
 4 files changed, 39 insertions(+), 27 deletions(-)
-- 
2.35.1

