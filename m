Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C8644D2F1C
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Mar 2022 13:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231956AbiCIMe2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 9 Mar 2022 07:34:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231295AbiCIMe0 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 9 Mar 2022 07:34:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223F037AA4
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 04:33:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D070BB8203F
        for <ceph-devel@vger.kernel.org>; Wed,  9 Mar 2022 12:33:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55548C340E8;
        Wed,  9 Mar 2022 12:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646829205;
        bh=TP6ddltMtKMGXxZF5XUPhxe+ZTD3S+zyQoRgQc2kd3s=;
        h=From:To:Subject:Date:From;
        b=WtXgUosy+vNkC4D5NBIVPw0bX/rmxROnxh+b3I4A2FJWLIay4dUl3MUawpLUZv3Y6
         lH8jpGrsJpUt7eTLdYL9/KWelZgoGM0PUDc2mkrJKWl1HJWCMejmh2Lfx2vkvLbnay
         yYDUFzAprYQIAqi6L+mxGatCkZR2gclQu8EeU7sP3hHc/0EUFRiPtC9RYq3HcogaUM
         U+CqvbvQhjBSOR0B1o0tld3YtjfyOIA0yDyMbYGiVG+uH/gsGU5ORjbaskOV1AlFBk
         SQDI0EQsYcVUjsG2kk/lxTXI4b+4F5oq6yubtEiN7lPMmAY6KcZ67mFV27DZF0QXro
         aji7+B/3O8UXw==
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, idryomov@gmail.com
Subject: [PATCH 0/3] ceph: support for sparse read in msgr2 crc path
Date:   Wed,  9 Mar 2022 07:33:20 -0500
Message-Id: <20220309123323.20593-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

This patchset is a revised version of the one I sent a couple of weeks
ago. This adds support for sparse reads to libceph, and changes cephfs
over to use instead of non-sparse reads. The sparse read codepath is a
drop in replacement for regular reads, so the upper layers should be
able to use it interchangeibly.

This is necessary for the (ongoing) fscrypt work. We need to know which
regions in a file are actually sparse so that we can avoid decrypting
them.

The next step is to add the same support to the msgr2 secure codepath.
Currently that code sets up a scatterlist with the final destination
data pages in it and passes that to the decrypt routine so that the
decrypted data is written directly to the destination.

My thinking here is to change that to decrypt the data in-place for
sparse reads, and then we'll just parse the decrypted buffer via
calling sparse_read and copy the data into the right places.

Ilya, does that sound sane? Is it OK to pass gcm_crypt two different
scatterlists with a region that overlaps?

Jeff Layton (3):
  libceph: add sparse read support to msgr2 crc state machine
  libceph: add sparse read support to OSD client
  ceph: convert to sparse reads

 fs/ceph/addr.c                  |   2 +-
 fs/ceph/file.c                  |   4 +-
 include/linux/ceph/messenger.h  |  31 +++++
 include/linux/ceph/osd_client.h |  38 ++++++
 net/ceph/messenger.c            |   1 +
 net/ceph/messenger_v2.c         | 215 ++++++++++++++++++++++++++++++--
 net/ceph/osd_client.c           | 163 ++++++++++++++++++++++--
 7 files changed, 435 insertions(+), 19 deletions(-)

-- 
2.35.1

